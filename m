Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1CVKvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:51:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59470 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1CVKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k0BW2+ijGrZttLfgnVSEdanhAIbX74eIvZ2LNW9AbyzMxqtGXAR241ubZXKYvmyrJD
         +pq+MQqPyB4PFk0yU9SzIuo+W5GscRxbeyOkXBNlHmjMytmcsuNHgUWwu1YE2/tu+PHH
         JDzXXwgPC/6DLWen6bm0yKsKPIX3cIykthe0E=
Date: Tue, 22 Mar 2011 11:51:28 +0100
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH UPDATED 3/8] job control: Fix ptracer wait(2) hang and
 explain notask_error clearing
Message-ID: <20110322105128.GP12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait(2) and friends allow access to stopped/continued states through
zombies, which is required as the states are process-wide and should
be accessible whether the leader task is alive or undead.
wait_consider_task() implements this by always clearing notask_error
and going through wait_task_stopped/continued() for unreaped zombies.

However, while ptraced, the stopped state is per-task and as such if
the ptracee became a zombie, there's no further stopped event to
listen to and wait(2) and friends should return -ECHILD on the tracee.

Fix it by clearing notask_error only if WCONTINUED | WEXITED is set
for ptraced zombies.  While at it, document why clearing notask_error
is safe for each case.

Test case follows.

  #include <stdio.h>
  #include <unistd.h>
  #include <pthread.h>
  #include <time.h>
  #include <sys/types.h>
  #include <sys/ptrace.h>
  #include <sys/wait.h>

  static void *nooper(void *arg)
  {
	  pause();
	  return NULL;
  }

  int main(void)
  {
	  const struct timespec ts1s = { .tv_sec = 1 };
	  pid_t tracee, tracer;
	  siginfo_t si;

	  tracee = fork();
	  if (tracee == 0) {
		  pthread_t thr;

		  pthread_create(&thr, NULL, nooper, NULL);
		  nanosleep(&ts1s, NULL);
		  printf("tracee exiting\n");
		  pthread_exit(NULL);	/* let subthread run */
	  }

	  tracer = fork();
	  if (tracer == 0) {
		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
		  while (1) {
			  if (waitid(P_PID, tracee, &si, WSTOPPED) < 0) {
				  perror("waitid");
				  break;
			  }
			  ptrace(PTRACE_CONT, tracee, NULL,
				 (void *)(long)si.si_status);
		  }
		  return 0;
	  }

	  waitid(P_PID, tracer, &si, WEXITED);
	  kill(tracee, SIGKILL);
	  return 0;
  }

Before the patch, after the tracee becomes a zombie, the tracer's
waitid(WSTOPPED) never returns and the program doesn't terminate.

  tracee exiting
  ^C

After the patch, tracee exiting triggers waitid() to fail.

  tracee exiting
  waitid: No child processes

-v2: Oleg pointed out that exited in addition to continued can happen
     for ptraced dead group leader.  Clear notask_error for ptraced
     child on WEXITED too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
WEXITED bug fixed.  Let's tackle the ptraced per-task wait(2) thing
later.  Thanks.

 kernel/exit.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

Index: work/kernel/exit.c
===================================================================
--- work.orig/kernel/exit.c
+++ work/kernel/exit.c
@@ -1550,17 +1550,41 @@ static int wait_consider_task(struct wai
 		return 0;
 	}
 
-	/*
-	 * We don't reap group leaders with subthreads.
-	 */
-	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
-		return wait_task_zombie(wo, p);
+	/* slay zombie? */
+	if (p->exit_state == EXIT_ZOMBIE) {
+		/* we don't reap group leaders with subthreads */
+		if (!delay_group_leader(p))
+			return wait_task_zombie(wo, p);
 
-	/*
-	 * It's stopped or running now, so it might
-	 * later continue, exit, or stop again.
-	 */
-	wo->notask_error = 0;
+		/*
+		 * Allow access to stopped/continued state via zombie by
+		 * falling through.  Clearing of notask_error is complex.
+		 *
+		 * When !@ptrace:
+		 *
+		 * If WEXITED is set, notask_error should naturally be
+		 * cleared.  If not, subset of WSTOPPED|WCONTINUED is set,
+		 * so, if there are live subthreads, there are events to
+		 * wait for.  If all subthreads are dead, it's still safe
+		 * to clear - this function will be called again in finite
+		 * amount time once all the subthreads are released and
+		 * will then return without clearing.
+		 *
+		 * When @ptrace:
+		 *
+		 * Stopped state is per-task and thus can't change once the
+		 * target task dies.  Only continued and exited can happen.
+		 * Clear notask_error if WCONTINUED | WEXITED.
+		 */
+		if (likely(!ptrace) || (wo->wo_flags & (WCONTINUED | WEXITED)))
+			wo->notask_error = 0;
+	} else {
+		/*
+		 * @p is alive and it's gonna stop, continue or exit, so
+		 * there always is something to wait for.
+		 */
+		wo->notask_error = 0;
+	}
 
 	if (task_stopped_code(p, ptrace))
 		return wait_task_stopped(wo, ptrace, p);
