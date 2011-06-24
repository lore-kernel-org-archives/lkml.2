Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab1FXPgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446Ab1FXPgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:36:35 -0400
Date: Fri, 24 Jun 2011 17:34:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ptrace: ptrace_reparented() should check
	same_thread_group()
Message-ID: <20110624153406.GB9346@redhat.com>
References: <20110624153330.GA9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624153330.GA9346@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_reparented() naively does parent != real_parent, this means
it returns true even if the tracer _is_ the real parent. This is per
process thing, not per-thread. The only reason ->real_parent can
point to the non-leader thread is that we have __WNOTHREAD.

Change it to check !same_thread_group(parent, real_parent).

It has two callers, and in both cases the current check does not
look right.

exit_notify: we should respect ->exit_signal if the exiting leader
is traced by any thread from the parent thread group. It is the
child of the whole group, and we are going to send the signal to
the whole group.

wait_task_zombie: without __WNOTHREAD do_wait() should do the same
for any thread, only sys_ptrace() is "bound" to the single thread.
However do_wait(WEXITED) succeeds but does not release a traced
natural child unless the caller is the tracer.

Test-case:

	void *tfunc(void *arg)
	{
		assert(ptrace(PTRACE_ATTACH, (long)arg, 0,0) == 0);
		pause();
		return NULL;
	}

	int main(void)
	{
		pthread_t thr;
		pid_t pid, stat, ret;

		pid = fork();
		if (!pid) {
			pause();
			assert(0);
		}

		assert(pthread_create(&thr, NULL, tfunc, (void*)(long)pid) == 0);

		assert(waitpid(-1, &stat, 0) == pid);
		assert(WIFSTOPPED(stat));

		kill(pid, SIGKILL);

		assert(waitpid(-1, &stat, 0) == pid);
		assert(WIFSIGNALED(stat) && WTERMSIG(stat) == SIGKILL);

		ret = waitpid(pid, &stat, 0);
		if (ret < 0)
			return 0;

		printf("WTF? %d is dead, but: wait=%d stat=%x\n",
				pid, ret, stat);

		return 1;
	}

Note that the main thread simply does

	pid = fork();
	kill(pid, SIGKILL);

and then without the patch wait4(WEXITED) succeeds twice and reports
WTERMSIG(stat) == SIGKILL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- ptrace/include/linux/ptrace.h~9_ptrace_reparanted_sg	2011-06-22 19:24:13.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-06-23 19:21:00.000000000 +0200
@@ -136,7 +136,7 @@ extern bool ptrace_may_access(struct tas
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
-	return child->real_parent != child->parent;
+	return !same_thread_group(child->real_parent, child->parent);
 }
 
 static inline void ptrace_unlink(struct task_struct *child)

