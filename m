Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1E0RjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:39:18 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:60470 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755990Ab1E0RjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:39:12 -0400
X-AuditID: 12074424-b7bc6ae000005a77-1e-4ddfe1bf5ec0
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with int 0xcc
Date: Fri, 27 May 2011 13:38:41 -0400
Message-Id: <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsUixCmqrbv/4X1fg/YFRhZ9V46yW1zeNYfN
	YsulZlaLzZumMlv82PCY1YHV41bbH2aPnbPusntsWtXJ5vHu3Dl2j8+b5AJYo7hsUlJzMstS
	i/TtErgyXr3JKHirVbF36UHWBsbNyl2MnBwSAiYSO2+sYoSwxSQu3FvP1sXIxSEksI9R4vPu
	pVDOBkaJq123WSCcZ0wSfSs+s4G0sAmoSHQsfcAEYosIxEk0zP7NCmIzCzhI3H58BGgsB4ew
	QKDEt5clIGEWAVWJjdfvsYPYvAJBEs8mXWGB2KwgceXKPDCbU8BA4vrfHWA1QgL6Et8vrmPD
	JT6BUWABI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXXO93MwSvdSU0k2MoMBkd1HZwdh8SOkQ
	owAHoxIPr9rB+75CrIllxZW5hxglOZiURHn9HgCF+JLyUyozEosz4otKc1KLDzFKcDArifCa
	7AfK8aYkVlalFuXDpKQ5WJTEeedJqvsKCaQnlqRmp6YWpBbBZGU4OJQkeGeDDBUsSk1PrUjL
	zClBSDNxcIIM5wEaPg2khre4IDG3ODMdIn+KUZejce2Og4xCLHn5ealS4rxPQYoEQIoySvPg
	5sASyitGcaC3hHmPg1TxAJMR3KRXQEuYgJbo/L4LsqQkESEl1cCY3mEusX3byv+V2UoPDTa4
	ynaYei867cG8/nhWQVdYmt4tzgepbyL28D6v2ph28uYs76670td/WqzdrHp/F79ZCU/sLL7X
	CYYvS2c+lj/yr5n9xI3MG0/kjVmvvMvb9nZF6i+WezIqk05PXKB0Wnvf+03TJbRO1UYcVf93
	JM/u0M7GPomzDOrJSizFGYmGWsxFxYkABWn+oQMDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the only way to issue a syscall with side effects through the
vsyscall page is to call a misaligned instruction.  I haven't
checked for that.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/traps.h    |    4 +++
 arch/x86/include/asm/vsyscall.h |    6 +++++
 arch/x86/kernel/entry_64.S      |    2 +
 arch/x86/kernel/traps.c         |    4 +++
 arch/x86/kernel/vsyscall_64.c   |   47 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0310da6..7eae1e4 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_TRAPS_H
 #define _ASM_X86_TRAPS_H
 
+#include <linux/kprobes.h>
+
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
@@ -38,6 +40,7 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
+asmlinkage void intcc(void);
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
@@ -64,6 +67,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *, long);
 dotraplinkage void do_machine_check(struct pt_regs *, long);
 #endif
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_intcc(struct pt_regs *, long);
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *, long);
 #endif
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d555973..293ae08 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -31,6 +31,12 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
+/* Emulation */
+static inline bool in_vsyscall_page(unsigned long addr)
+{
+	return (addr & ~(PAGE_SIZE - 1)) == VSYSCALL_START;
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..8e12f50 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1121,6 +1121,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
+zeroentry intcc do_intcc
+
 
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..d34894e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -872,6 +872,10 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 
+	set_system_intr_gate(0xCC, &intcc);
+	set_bit(0xCC, used_vectors);
+	printk(KERN_ERR "intcc gate isntalled\n");
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3e8dac7..6135a28 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -32,6 +32,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
+#include <linux/syscalls.h>
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
@@ -44,6 +45,7 @@
 #include <asm/desc.h>
 #include <asm/topology.h>
 #include <asm/vgtod.h>
+#include <asm/traps.h>
 
 #define __vsyscall(nr) \
 		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
@@ -92,13 +94,11 @@ static __always_inline void do_get_tz(struct timezone * tz)
 	*tz = VVAR(vsyscall_gtod_data).sys_tz;
 }
 
-static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
+static __always_inline int fallback_gettimeofday(struct timeval *tv)
 {
 	int ret;
-	asm volatile("syscall"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
+	/* Invoke do_intcc. */
+	asm volatile("int $0xcc" : "=a" (ret) : "D" (tv));
 	return ret;
 }
 
@@ -113,7 +113,7 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 
 		vread = VVAR(vsyscall_gtod_data).clock.vread;
 		if (unlikely(!vread)) {
-			gettimeofday(tv,NULL);
+			fallback_gettimeofday(tv);
 			return;
 		}
 
@@ -236,6 +236,41 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
+void dotraplinkage do_intcc(struct pt_regs *regs, long error_code)
+{
+	/* Kernel code must never get here. */
+	if (!user_mode(regs))
+		BUG();
+
+	local_irq_enable();
+
+	if (!in_vsyscall_page(regs->ip)) {
+		struct task_struct *tsk = current;
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
+			printk(KERN_INFO
+			       "%s[%d] illegal int $0xCC ip:%lx sp:%lx",
+			       tsk->comm, task_pid_nr(tsk),
+			       regs->ip, regs->sp);
+			print_vma_addr(" in ", regs->ip);
+			printk("\n");
+		}
+
+		force_sig(SIGSEGV, current);
+		return;
+	}
+
+	if (current->seccomp.mode) {
+		do_exit(SIGKILL);
+		return;
+	}
+
+	regs->ax = sys_gettimeofday((struct timeval __user *)regs->di, NULL);
+
+	local_irq_disable();
+	return;
+}
+
 static void __cpuinit cpu_vsyscall_init(void *arg)
 {
 	/* preemption should be already off */
-- 
1.7.5.1

