Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965374Ab1KJDls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:41:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965333Ab1KJDlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:41:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:55 2011
Message-Id: <20111109213155.270595746@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [131/264] [S390] user per registers vs. ptrace single stepping
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit a45aff5285871bf7be1781d9462d3fdbb6c913f9 upstream.

git commit 5e9a2692 "[S390] ptrace cleanup" introduced a regression
for the case when both a user PER set (e.g. a storage alteration trace) and
PTRACE_SINGLESTEP are active. The new code will overrule the user PER set
with a instruction-fetch PER set over the whole address space for ptrace
single stepping. The inferior process will be stopped after each instruction
with an instruction fetch event. Any other events that may have occurred
concurrently are not reported (e.g. storage alteration event) because the
control bits for them are not set. The solution is to merge the PER control
bits of the user PER set with the PER_EVENT_IFETCH control bit for
PTRACE_SINGLESTEP.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/ptrace.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -47,29 +47,31 @@ enum s390_regset {
 
 void update_per_regs(struct task_struct *task)
 {
-	static const struct per_regs per_single_step = {
-		.control = PER_EVENT_IFETCH,
-		.start = 0,
-		.end = PSW_ADDR_INSN,
-	};
 	struct pt_regs *regs = task_pt_regs(task);
 	struct thread_struct *thread = &task->thread;
-	const struct per_regs *new;
-	struct per_regs old;
+	struct per_regs old, new;
 
-	/* TIF_SINGLE_STEP overrides the user specified PER registers. */
-	new = test_tsk_thread_flag(task, TIF_SINGLE_STEP) ?
-		&per_single_step : &thread->per_user;
+	/* Copy user specified PER registers */
+	new.control = thread->per_user.control;
+	new.start = thread->per_user.start;
+	new.end = thread->per_user.end;
+
+	/* merge TIF_SINGLE_STEP into user specified PER registers. */
+	if (test_tsk_thread_flag(task, TIF_SINGLE_STEP)) {
+		new.control |= PER_EVENT_IFETCH;
+		new.start = 0;
+		new.end = PSW_ADDR_INSN;
+	}
 
 	/* Take care of the PER enablement bit in the PSW. */
-	if (!(new->control & PER_EVENT_MASK)) {
+	if (!(new.control & PER_EVENT_MASK)) {
 		regs->psw.mask &= ~PSW_MASK_PER;
 		return;
 	}
 	regs->psw.mask |= PSW_MASK_PER;
 	__ctl_store(old, 9, 11);
-	if (memcmp(new, &old, sizeof(struct per_regs)) != 0)
-		__ctl_load(*new, 9, 11);
+	if (memcmp(&new, &old, sizeof(struct per_regs)) != 0)
+		__ctl_load(new, 9, 11);
 }
 
 void user_enable_single_step(struct task_struct *task)


