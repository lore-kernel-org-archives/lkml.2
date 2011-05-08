Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1EHPuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:50:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab1EHPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LqOzqKwk20B5Nu7lny6V2axm4Vz5CNe7N/anKJ6lDciYdjj6Q/g7PKFrcH2gxR570r
         Wh44FXN35Ott8MqufdmY3DGQHFfjiwApYJEcoHH7Dlf1OewXxb5xfmrQJ2VW67qLYR7Y
         u7gSmsZENyjFiF/ZvCjND/iX+SrAd0QLt9EUI=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/11] ptrace: move fallback JOBCTL_TRAPPING clearing to get_signal_to_deliver()
Date: Sun,  8 May 2011 17:49:02 +0200
Message-Id: <1304869745-1073-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JOBCTL_TRAPPING is currently used to hide TASK_STOPPED -> TASK_TRACED
transition on ptrace attach/seize.  As such, it is set only while
tracee is inside do_signal_stop() and gets cleread by entering
TASK_TRACED in ptrace_stop(); however, if attach races with kill,
ptrace_stop() can be skipped.  To make sure the tracer is woken up in
this case, task_clear_jobctl_trapping() is always called before
leaving do_signal_stop().

To-be-added end of group stop notification will extend the use of
JOBCTL_TRAPPING to move tracee from group stop trap to INTERRUPT trap
or repeat INTERRUPT trap.  This requires TASK_TRAPPING to be
maintained inside signal delivery path.

Move the fallback clearing to the end of get_signal_to_deliver() so
that TRAPPING is maintained while tracee is inside signal delivery
path.  When killed, tracee is guaranteed to leave signal delivery path
in finite amount of time and thus TRAPPING is still guaranteed to be
cleared on kill.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 208f061..a7f65a6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -227,7 +227,10 @@ static inline void print_dropped_signal(int sig)
  * task_clear_jobctl_trapping - clear jobctl trapping bit
  * @task: target task
  *
- * If JOBCTL_TRAPPING is set, a ptracer is waiting for us to enter TRACED.
+ * If %JOBCTL_TRAPPING is set, ptracer is waiting for us to enter
+ * %TASK_TRACED.  It can be set only while we're inside do_signal_stop()
+ * and must be cleared before leaving signal delivery path.
+ *
  * Clear it and wake up the ptracer.  Note that we don't need any further
  * locking.  @task->siglock guarantees that @task->parent points to the
  * ptracer.
@@ -1978,9 +1981,6 @@ retry:
 		goto retry;
 	}
 
-	/* PTRACE_ATTACH might have raced with task killing, clear trapping */
-	task_clear_jobctl_trapping(current);
-
 	spin_unlock_irq(&current->sighand->siglock);
 
 	tracehook_finish_jctl();
@@ -2226,6 +2226,13 @@ relock:
 		do_group_exit(info->si_signo);
 		/* NOTREACHED */
 	}
+
+	/*
+	 * PTRACE_ATTACH might have raced with task killing.  Make sure
+	 * trapping is clear before leaving signal delivery path.
+	 */
+	task_clear_jobctl_trapping(current);
+
 	spin_unlock_irq(&sighand->siglock);
 	return signr;
 }
-- 
1.7.1

