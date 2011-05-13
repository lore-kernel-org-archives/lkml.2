Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab1EMPqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:46:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52886 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981Ab1EMPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Dh5JLuISsRMCdJWRCL7+Rz8Wbx1vgK9PkXu6pYVUbT/2D5AGh1jREPJYnrakNM6r+5
         jX/gEaPFdITnVdpYOLzd+9NtRWbv5siZrsmUrPImqVc1dklgWRMjZz9aqgnEa2P9nbmW
         C4gqu35beKLpQ/KoY5XVd88kNF57FlxTd1hVk=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
Date: Fri, 13 May 2011 17:46:18 +0200
Message-Id: <1305301580-9924-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305301580-9924-1-git-send-email-tj@kernel.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptracer->signal->wait_chldexit was used to wait for TRAPPING; however,
->wait_chldexit was already complicated with waker-side filtering
without adding TRAPPING wait on top of it.  Also, it unnecessarily
made TRAPPING clearing depend on the current ptrace relationship - if
the ptracee is detached, wakeup is lost.

There is no reason to use signal->wait_chldexit here.  We're just
waiting for JOBCTL_TRAPPING bit to clear and given the relatively
infrequent use of ptrace, bit_waitqueue can serve it perfectly.

This patch makes JOBCTL_TRAPPING wait use bit_waitqueue instead of
signal->wait_chldexit.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |   10 ++++++++--
 kernel/signal.c |    3 +--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 5cd77a8..41fd45e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -24,6 +24,12 @@
 #include <linux/regset.h>
 
 
+static int ptrace_trapping_sleep_fn(void *flags)
+{
+	schedule();
+	return 0;
+}
+
 /*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
@@ -271,8 +277,8 @@ unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
 	if (wait_trap)
-		wait_event(current->signal->wait_chldexit,
-			   !(task->jobctl & JOBCTL_TRAPPING));
+		wait_on_bit(&task->jobctl, ilog2(JOBCTL_TRAPPING),
+			    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
 	return retval;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 91e57d3..fff3036 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -239,8 +239,7 @@ static void task_clear_jobctl_trapping(struct task_struct *task)
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
-		__wake_up_sync_key(&task->parent->signal->wait_chldexit,
-				   TASK_UNINTERRUPTIBLE, 1, task);
+		wake_up_bit(&task->jobctl, ilog2(JOBCTL_TRAPPING));
 	}
 }
 
-- 
1.7.1

