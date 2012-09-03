Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2ICPY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:24:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab2ICPY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:24:57 -0400
Date: Mon, 3 Sep 2012 17:26:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] ptrace: Introduce set_task_blockstep() helper
Message-ID: <20120903152606.GA9068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152525.GA9028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for the next fix and for uprobes
single-step fixes.

Move the code playing with TIF_BLOCKSTEP/DEBUGCTLMSR_BTF into the
new helper, set_task_blockstep().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/step.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index c346d11..7a51498 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -157,6 +157,21 @@ static int enable_single_step(struct task_struct *child)
 	return 1;
 }
 
+static void set_task_blockstep(struct task_struct *task, bool on)
+{
+	unsigned long debugctl;
+
+	debugctl = get_debugctlmsr();
+	if (on) {
+		debugctl |= DEBUGCTLMSR_BTF;
+		set_tsk_thread_flag(task, TIF_BLOCKSTEP);
+	} else {
+		debugctl &= ~DEBUGCTLMSR_BTF;
+		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
+	}
+	update_debugctlmsr(debugctl);
+}
+
 /*
  * Enable single or block step.
  */
@@ -169,19 +184,10 @@ static void enable_step(struct task_struct *child, bool block)
 	 * So no one should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
-	if (enable_single_step(child) && block) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl |= DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	} else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl &= ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (enable_single_step(child) && block)
+		set_task_blockstep(child, true);
+	else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		set_task_blockstep(child, false);
 }
 
 void user_enable_single_step(struct task_struct *child)
@@ -199,13 +205,8 @@ void user_disable_single_step(struct task_struct *child)
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl &= ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		set_task_blockstep(child, false);
 
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
-- 
1.5.5.1

