Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3AIL4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:56:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab3AIL4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:56:35 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH v2 1/4] uretprobes/x86: hijack return address
Date: Wed,  9 Jan 2013 12:24:49 +0100
Message-Id: <1357730692-3928-2-git-send-email-anton@redhat.com>
In-Reply-To: <1357730692-3928-1-git-send-email-anton@redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function to hijack the return address, replace it with a "trampoline"
and function to predict the stack pointer address value at return.

v2:
  remove ->doomed flag, kill task immediately

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/x86/include/asm/uprobes.h |  1 +
 arch/x86/kernel/uprobes.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 8ff8be7..c353555 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -55,4 +55,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 0ba4cfb..85e2153 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -697,3 +697,32 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		send_sig(SIGTRAP, current, 0);
 	return ret;
 }
+
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long
+		rp_trampoline_vaddr, struct pt_regs *regs)
+{
+	int rasize, ncopied;
+	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
+
+	rasize = is_ia32_task() ? 4 : 8;
+	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
+	if (unlikely(ncopied))
+		return 0;
+
+	/* check whether address has been already hijacked */
+	if (orig_ret_vaddr == rp_trampoline_vaddr)
+		return orig_ret_vaddr;
+
+	ncopied = copy_to_user((void __user *)regs->sp, &rp_trampoline_vaddr, rasize);
+	if (unlikely(ncopied)) {
+		if (ncopied != rasize) {
+			printk(KERN_ERR "uretprobe: return address clobbered: "
+					"pid=%d, %%sp=%#lx, %%ip=%#lx\n",
+					current->pid, regs->sp, regs->ip);
+			/* kill task immediately */
+			send_sig(SIGSEGV, current, 0);
+		}
+	}
+
+	return orig_ret_vaddr;
+}
-- 
1.8.0.2

