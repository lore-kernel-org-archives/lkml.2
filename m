Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1E2XNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:13:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab1E2XNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dqqDk7GwxiYrczserMCB6//zfP7D0OSdP0yNaH0sPp21UUjfUD+TaX9EsQHDxIeBi2
         lPs1Y2ZKahym4YROBALii8/XOFOPuDfMMJtQbuZ3+9gUFVGqS2HQuTcZsJ50BjaFghjt
         csubwxOQE9uUv+1Ruh+q5RYvVfbV4q27xYgqs=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/17] ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
Date: Mon, 30 May 2011 01:12:31 +0200
Message-Id: <1306710760-16440-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
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

-v2: Use JOBCTL_*_BIT macros instead of ilog2() as suggested by Linus.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/ptrace.c |   10 ++++++++--
 kernel/signal.c |    3 +--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1506556..82f566b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -25,6 +25,12 @@
 #include <linux/hw_breakpoint.h>
 
 
+static int ptrace_trapping_sleep_fn(void *flags)
+{
+	schedule();
+	return 0;
+}
+
 /*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
@@ -269,8 +275,8 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	wait_event(current->signal->wait_chldexit,
-			   !(task->jobctl & JOBCTL_TRAPPING));
+	wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT,
+			    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
 	return retval;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 9ab91c5..172a4c7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -272,8 +272,7 @@ static void task_clear_jobctl_trapping(struct task_struct *task)
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
-		__wake_up_sync_key(&task->parent->signal->wait_chldexit,
-				   TASK_UNINTERRUPTIBLE, 1, task);
+		wake_up_bit(&task->jobctl, JOBCTL_TRAPPING_BIT);
 	}
 }
 
-- 
1.7.5.2

