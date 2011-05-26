Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1EZRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:15:39 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56153 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab1EZRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:15:37 -0400
Date: Thu, 26 May 2011 22:45:21 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal MCE,
 capture related information
Message-ID: <20110526171521.GD17988@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526170722.GB23266@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information

Fatal machine check exceptions (caused due to hardware memory errors) will now
result in a 'slim' coredump that captures vital information about the MCE. This
patch introduces a new panic flag, and new parameters to *panic functions
that can capture more information pertaining to the cause of crash.

Enable a new elf-notes section to store additional information about the crash.
For MCE, enable a new notes section that captures relevant register status
(struct mce) to be later read during coredump analysis.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/arm/kernel/traps.c          |    2 +-
 arch/powerpc/kernel/traps.c      |    2 +-
 arch/sh/kernel/traps_32.c        |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c |    7 +++----
 arch/x86/kernel/dumpstack.c      |    2 +-
 include/linux/elf.h              |    5 +++++
 include/linux/kernel.h           |    9 +++++----
 include/linux/kexec.h            |    9 ++++++---
 kernel/kexec.c                   |   17 +++++++++++------
 kernel/panic.c                   |   16 ++++++++--------
 10 files changed, 42 insertions(+), 29 deletions(-)

Index: linux-2.6.slim_kdump/include/linux/kernel.h
===================================================================
--- linux-2.6.slim_kdump.orig/include/linux/kernel.h
+++ linux-2.6.slim_kdump/include/linux/kernel.h
@@ -178,17 +178,18 @@ static inline void might_fault(void)
 enum panic_flags {
 	PANIC_NO_KEXEC     = (1 << 0),
 	PANIC_NO_BACKTRACE = (1 << 1),
+	PANIC_MCE          = (1 << 2),
 };
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
-NORET_TYPE void xpanic(enum panic_flags flags, int timeout,
-		       const char *fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 3, 4))) __cold;
+NORET_TYPE void xpanic(enum panic_flags flags, int timeout, void *arch_info,
+			size_t arch_info_size, const char *fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 5, 6))) __cold;
 NORET_TYPE void vpanic(enum panic_flags flags, int timeout,
-		       const char *fmt,
+		       void *arch_info, size_t arch_info_size, const char *fmt,
 		       va_list ap) __noreturn __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
Index: linux-2.6.slim_kdump/kernel/panic.c
===================================================================
--- linux-2.6.slim_kdump.orig/kernel/panic.c
+++ linux-2.6.slim_kdump/kernel/panic.c
@@ -61,21 +61,21 @@ NORET_TYPE void panic(const char *fmt, .
 {
 	va_list ap;
 	va_start(ap, fmt);
-	vpanic(0, 0, fmt, ap);
+	vpanic(0, 0, NULL, 0, fmt, ap);
 }
 EXPORT_SYMBOL(panic);
 
-NORET_TYPE void xpanic(enum panic_flags flags, int timeout,
-                       const char *fmt, ...)
+NORET_TYPE void xpanic(enum panic_flags flags, int timeout, void *arch_info,
+			size_t arch_info_size, const char *fmt, ...)
 {
 	va_list ap;
 	va_start(ap, fmt);
-	vpanic(flags, timeout, fmt, ap);
+	vpanic(flags, timeout, arch_info, arch_info_size, fmt, ap);
 }
 EXPORT_SYMBOL(xpanic);
 
-NORET_TYPE void vpanic(enum panic_flags flags, int timeout,
-		       const char * fmt, va_list args)
+NORET_TYPE void vpanic(enum panic_flags flags, int timeout, void *arch_info,
+			size_t arch_info_size, const char * fmt, va_list args)
 {
 	static char buf[1024];
 	long i, i_next = 0;
@@ -99,7 +99,7 @@ NORET_TYPE void vpanic(enum panic_flags
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-	if (!(flags & PANIC_NO_BACKTRACE))
+	if (!(flags & (PANIC_NO_BACKTRACE | PANIC_MCE)))
 		dump_stack();
 #endif
 
@@ -109,7 +109,7 @@ NORET_TYPE void vpanic(enum panic_flags
 	 * Do we want to call this before we try to display a message?
 	 */
 	if (!(flags & PANIC_NO_KEXEC))
-		crash_kexec(NULL);
+		crash_kexec(NULL, arch_info, arch_info_size, flags);
 
 	kmsg_dump(KMSG_DUMP_PANIC);
 
Index: linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.slim_kdump.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
@@ -258,8 +258,7 @@ static void wait_for_panic(void)
 	local_irq_enable();
 	while (timeout-- > 0)
 		udelay(1);
-	xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, 0,
-		"Panicing machine check CPU died");
+	xpanic(PANIC_MCE, 0, NULL, 0, "Panicing machine check CPU died");
 }
 
 static void mce_panic(char *msg, struct mce *final, char *exp)
@@ -315,8 +314,8 @@ static void mce_panic(char *msg, struct
 	if (exp)
 		pr_emerg(HW_ERR "Machine check: %s\n", exp);
 	if (!fake_panic) {
-		xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, mce_panic_timeout,
-			msg);
+		xpanic(PANIC_MCE, mce_panic_timeout, final,
+			sizeof(struct mce), msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
 }
Index: linux-2.6.slim_kdump/arch/arm/kernel/traps.c
===================================================================
--- linux-2.6.slim_kdump.orig/arch/arm/kernel/traps.c
+++ linux-2.6.slim_kdump/arch/arm/kernel/traps.c
@@ -274,7 +274,7 @@ void die(const char *str, struct pt_regs
 	ret = __die(str, err, thread, regs);
 
 	if (regs && kexec_should_crash(thread->task))
-		crash_kexec(regs);
+		crash_kexec(regs, NULL, 0, 0);
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE);
Index: linux-2.6.slim_kdump/arch/powerpc/kernel/traps.c
===================================================================
--- linux-2.6.slim_kdump.orig/arch/powerpc/kernel/traps.c
+++ linux-2.6.slim_kdump/arch/powerpc/kernel/traps.c
@@ -161,7 +161,7 @@ int die(const char *str, struct pt_regs
 
 	if (kexec_should_crash(current) ||
 		kexec_sr_activated(smp_processor_id()))
-		crash_kexec(regs);
+		crash_kexec(regs, NULL, 0, 0);
 	crash_kexec_secondary(regs);
 
 	if (in_interrupt())
Index: linux-2.6.slim_kdump/arch/sh/kernel/traps_32.c
===================================================================
--- linux-2.6.slim_kdump.orig/arch/sh/kernel/traps_32.c
+++ linux-2.6.slim_kdump/arch/sh/kernel/traps_32.c
@@ -106,7 +106,7 @@ void die(const char * str, struct pt_reg
 	oops_exit();
 
 	if (kexec_should_crash(current))
-		crash_kexec(regs);
+		crash_kexec(regs, NULL, 0, 0);
 
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
Index: linux-2.6.slim_kdump/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6.slim_kdump.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6.slim_kdump/arch/x86/kernel/dumpstack.c
@@ -241,7 +241,7 @@ EXPORT_SYMBOL_GPL(oops_begin);
 void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	if (regs && kexec_should_crash(current))
-		crash_kexec(regs);
+		crash_kexec(regs, NULL, 0, 0);
 
 	bust_spinlocks(0);
 	die_owner = -1;
Index: linux-2.6.slim_kdump/include/linux/elf.h
===================================================================
--- linux-2.6.slim_kdump.orig/include/linux/elf.h
+++ linux-2.6.slim_kdump/include/linux/elf.h
@@ -381,6 +381,11 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+/*
+ * Although numbers 1 - 6 have been defined here, the user-space include files
+ * have numbers 1 - 20 taken up. Hence defining NT_MCE as 21.
+ */
+#define NT_MCE		21		/* Machine Check Exception related data */
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
Index: linux-2.6.slim_kdump/include/linux/kexec.h
===================================================================
--- linux-2.6.slim_kdump.orig/include/linux/kexec.h
+++ linux-2.6.slim_kdump/include/linux/kexec.h
@@ -125,10 +125,12 @@ extern asmlinkage long compat_sys_kexec_
 #endif
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
-extern void crash_kexec(struct pt_regs *);
+extern void crash_kexec(struct pt_regs *, void *arch_info,
+			size_t arch_info_size, enum panic_flags);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
-void crash_save_vmcoreinfo(void);
+void crash_save_vmcoreinfo(void *arch_info, size_t arch_info_size,
+						enum panic_flags);
 void arch_crash_save_vmcoreinfo(void);
 void vmcoreinfo_append_str(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
@@ -213,7 +215,8 @@ void crash_free_reserved_phys_range(unsi
 #else /* !CONFIG_KEXEC */
 struct pt_regs;
 struct task_struct;
-static inline void crash_kexec(struct pt_regs *regs) { }
+static inline void crash_kexec(struct pt_regs *regs, void *arch_info,
+				size_t arch_info_size, enum panic_flags) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 #endif /* CONFIG_KEXEC */
 #endif /* LINUX_KEXEC_H */
Index: linux-2.6.slim_kdump/kernel/kexec.c
===================================================================
--- linux-2.6.slim_kdump.orig/kernel/kexec.c
+++ linux-2.6.slim_kdump/kernel/kexec.c
@@ -1065,7 +1065,8 @@ asmlinkage long compat_sys_kexec_load(un
 }
 #endif
 
-void crash_kexec(struct pt_regs *regs)
+void crash_kexec(struct pt_regs *regs, void *arch_info, size_t arch_info_size,
+		 enum panic_flags flags)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
@@ -1082,7 +1083,7 @@ void crash_kexec(struct pt_regs *regs)
 			kmsg_dump(KMSG_DUMP_KEXEC);
 
 			crash_setup_regs(&fixed_regs, regs);
-			crash_save_vmcoreinfo();
+			crash_save_vmcoreinfo(arch_info, arch_info_size, flags);
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
@@ -1381,7 +1382,8 @@ int __init parse_crashkernel(char 		 *cm
 
 
 
-void crash_save_vmcoreinfo(void)
+void crash_save_vmcoreinfo(void *arch_info, size_t arch_info_size,
+						enum panic_flags flags)
 {
 	u32 *buf;
 
@@ -1392,9 +1394,12 @@ void crash_save_vmcoreinfo(void)
 
 	buf = (u32 *)vmcoreinfo_note;
 
-	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
-			      vmcoreinfo_size);
-
+	if (flags & PANIC_MCE)
+		buf = append_elf_note(buf, "PANIC_MCE", NT_MCE, arch_info,
+					arch_info_size);
+	else
+		buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0,
+				vmcoreinfo_data, vmcoreinfo_size);
 	final_note(buf);
 }
 
