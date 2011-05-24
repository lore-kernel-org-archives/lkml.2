Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab1EXSic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:38:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073Ab1EXSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=P9Lg46i9EHdw112dP0LFDP/be3N2f9iZtjniH+N/VQMJCQNC0R3iqH1ui8w5paJDDG
         XaplEWMctbtHRZyOw8x9Io7xo42xoqj4OC6jhsmLX69Z3cir4FxaRBFmkJn6Zjd+i+Bt
         mbH/KBE1KaEjjOeOB2IjibDsBrZXvFT1LspY8=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/19] ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
Date: Tue, 24 May 2011 20:37:27 +0200
Message-Id: <1306262259-7285-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
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
index b44dc43..3be5d1b 100644
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
@@ -273,8 +279,8 @@ unlock_creds:
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
index 17feedf..106b47e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -272,8 +272,7 @@ static void task_clear_jobctl_trapping(struct task_struct *task)
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

