Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0FJEO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 00:14:28 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53581 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab0FJEOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 00:14:24 -0400
Date: Thu, 10 Jun 2010 00:14:19 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org
Subject: [PATCH] x86: OLPC: add support for calling into OpenFirmware (v2)
Message-ID: <20100610001419.7487d5f7@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for saving OFW's cif, and later calling into it to run OFW
commands.  OFW remains resident in memory, living within virtual range
0xff800000 - 0xffc00000.  A single page directory entry points to the
pgdir that OFW actually uses, so rather than saving the entire page
table, we save that one entry (and restore it for the call into OFW).

This is currently only used by the OLPC XO; however, there's nothing
restricting OFW's usage on other (x86) platforms.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                |    9 ++++
 arch/x86/include/asm/olpc_ofw.h |   35 ++++++++++++++
 arch/x86/include/asm/setup.h    |    1 +
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/head_32.S       |   34 ++++++++++++++
 arch/x86/kernel/olpc.c          |   12 ++---
 arch/x86/kernel/olpc_ofw.c      |   95 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c         |    4 ++
 8 files changed, 184 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/include/asm/olpc_ofw.h
 create mode 100644 arch/x86/kernel/olpc_ofw.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..71c194d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2062,6 +2062,15 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
+config OLPC_OPENFIRMWARE
+	bool "Support for OLPC's Open Firmware"
+	depends on !X86_64 && !X86_PAE
+	default y if OLPC
+	help
+	  This option adds support for the implementation of Open Firmware
+	  that is used on the OLPC XO-1 Children's Machine.
+	  If unsure, say N here.
+
 endif # X86_32
 
 config K8_NB
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
new file mode 100644
index 0000000..7a16734
--- /dev/null
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -0,0 +1,35 @@
+#ifndef _ASM_X86_OLPC_OFW_H
+#define _ASM_X86_OLPC_OFW_H
+
+/* index into the page table containing the entry OFW occupies */
+#define OLPC_OFW_PDE_NR 1022
+
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+
+#ifndef __ASSEMBLY__
+
+/* address of OFW callback interface; will be NULL if OFW isn't found */
+extern int (*olpc_ofw_cif)(int *);
+
+/* page dir entry containing OFW's current memory */
+extern pgdval_t olpc_ofw_pgd;
+
+/* run an OFW command by calling into the firmware */
+#define olpc_ofw(name, args, res) \
+	__olpc_ofw((name), ARRAY_SIZE(args), args, ARRAY_SIZE(res), res)
+
+extern int __olpc_ofw(const char *name, int nr_args, void **args, int nr_res,
+		void **res);
+
+/* determine/ensure OFW lives in the proper place in (virtual) memory */
+extern void olpc_ofw_detect_range(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#else /* !CONFIG_OLPC_OPENFIRMWARE */
+
+static inline void olpc_ofw_detect_range(void) { }
+
+#endif /* !CONFIG_OLPC_OPENFIRMWARE */
+
+#endif /* _ASM_X86_OLPC_OFW_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..5cba9eb 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -21,6 +21,7 @@
 #define OLD_CL_MAGIC		0xA33F
 #define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
+#define OLPC_OFW_INFO_OFFSET	0xB0	/* Relative to real mode data */
 
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e77b220..0925676 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..40cf275 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -17,6 +17,7 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
+#include <asm/olpc_ofw.h>
 #include <asm/processor-flags.h>
 #include <asm/msr-index.h>
 #include <asm/cpufeature.h>
@@ -131,6 +132,31 @@ ENTRY(startup_32)
 	movsl
 1:
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+	movl $0x0, pa(olpc_ofw_cif)
+
+	/* Did OpenFirmware boot us? */
+	movl $pa(boot_params) + OLPC_OFW_INFO_OFFSET, %ebp
+	cmpl $0x2057464F, (%ebp)	/* Magic number "OFW " */
+	jne 3f
+
+	/* Save the callback address for calling into OFW from linux */
+	mov 0x8(%ebp), %eax
+	mov %eax, pa(olpc_ofw_cif)
+
+	/*
+	 * %cr3 holds OFW's pgdir table.  For calling info OFW, we need to
+	 * the save next-to-last pgdir table entry, which points to a page
+	 * table that lives within OFW's memory.  The pgdir table contains
+	 * 1024 entries (each a 4 byte pde), so we want
+	 * ((int *) %cr3)[OLPC_OFW_PDE_NR].
+	 */
+	movl %cr3, %eax
+	movl OLPC_OFW_PDE_NR*4(%eax), %ebx
+	movl %ebx, pa(olpc_ofw_pgd)
+3:
+#endif
+
 #ifdef CONFIG_PARAVIRT
 	/* This is can only trip for a broken bootloader... */
 	cmpw $0x207, pa(boot_params + BP_version)
@@ -658,6 +684,14 @@ ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
 	.long __BOOT_DS
 
+.globl olpc_ofw_cif
+.globl olpc_ofw_pgd
+
+olpc_ofw_cif:
+	.long olpc_ofw_cif
+olpc_ofw_pgd:
+	.long olpc_ofw_pgd
+
 ready:	.byte 0
 
 early_recursion_flag:
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 8297160..1566052 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -21,10 +21,7 @@
 #include <asm/geode.h>
 #include <asm/setup.h>
 #include <asm/olpc.h>
-
-#ifdef CONFIG_OPEN_FIRMWARE
-#include <asm/ofw.h>
-#endif
+#include <asm/olpc_ofw.h>
 
 struct olpc_platform_t olpc_platform_info;
 EXPORT_SYMBOL_GPL(olpc_platform_info);
@@ -188,14 +185,15 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-#ifdef CONFIG_OPEN_FIRMWARE
+#ifdef CONFIG_OLPC_OPENFIRMWARE
 static void __init platform_detect(void)
 {
 	size_t propsize;
 	__be32 rev;
+	void *args[] = { NULL, "board-revision-int", &rev, (void *)4 };
+	void *res[] = { &propsize };
 
-	if (ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
-			&propsize) || propsize != 4) {
+	if (olpc_ofw("getprop", args, res) || propsize != 4) {
 		printk(KERN_ERR "ofw: getprop call failed!\n");
 		rev = cpu_to_be32(0);
 	}
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
new file mode 100644
index 0000000..1af8a44
--- /dev/null
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -0,0 +1,95 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/olpc_ofw.h>
+
+static DEFINE_SPINLOCK(ofw_lock);
+
+#define MAXARGS 10
+
+/* setup and do actual call into OFW */
+static int setup_ofw(int *ofw_args)
+{
+	pgd_t *base, *pde;
+	pgdval_t oldval;
+	int ret;
+
+	/* temporarily clobber %cr3[OLPC_OFW_PDE_NR] w/ olpc_ofw_pgd */
+	base = __va(read_cr3());
+	pde = &base[OLPC_OFW_PDE_NR];
+	oldval = pgd_val(*pde);
+	set_pgd(pde, __pgd(olpc_ofw_pgd));
+	flush_tlb();
+
+	/* call into ofw */
+	ret = olpc_ofw_cif(ofw_args);
+
+	/* restore %cr3[OLPC_OFW_PDE_NR] */
+	set_pgd(pde, __pgd(oldval));
+	flush_tlb();
+
+	return ret;
+}
+
+int __olpc_ofw(const char *name, int nr_args, void **args, int nr_res,
+		void **res)
+{
+	int ofw_args[MAXARGS + 3];
+	unsigned long flags;
+	int ret, i, *p;
+
+	BUG_ON(nr_args + nr_res > MAXARGS);
+
+	if (!olpc_ofw_cif)
+		return -EIO;
+
+	ofw_args[0] = (int)name;
+	ofw_args[1] = nr_args;
+	ofw_args[2] = nr_res;
+
+	p = &ofw_args[3];
+	for (i = 0; i < nr_args; i++, p++)
+		*p = (int)args[i];
+
+	spin_lock_irqsave(&ofw_lock, flags);
+	ret = setup_ofw(ofw_args);
+	spin_unlock_irqrestore(&ofw_lock, flags);
+
+	if (!ret) {
+		for (i = 0; i < nr_res; i++, p++)
+			*((int *)res[i]) = *p;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__olpc_ofw);
+
+/* OFW cif _should_ be above this address */
+#define OFW_MIN 0xff000000
+
+/* OFW starts on a 1MB boundary */
+#define OFW_BOUND (1<<20)
+
+void __init olpc_ofw_detect_range(void)
+{
+	unsigned long start;
+
+	if (!olpc_ofw_cif)
+		return;
+
+	if ((unsigned long)olpc_ofw_cif < OFW_MIN) {
+		printk(KERN_WARNING "OFW detected, but cif has invalid address 0x%lx - disabling.\n",
+				(unsigned long)olpc_ofw_cif);
+		olpc_ofw_cif = NULL;
+		return;
+	}
+
+	/* determine where OFW starts in memory */
+	start = round_down((unsigned long)olpc_ofw_cif, OFW_BOUND);
+	printk(KERN_WARNING "OFW detected in memory, cif @ 0x%lx (reserving top %ldMB)\n",
+			(unsigned long)olpc_ofw_cif, (-start) >> 20);
+	reserve_top_address(-start);
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b4ae4ac..67e98c3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -102,6 +102,7 @@
 
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
+#include <asm/olpc_ofw.h>
 
 #include <asm/percpu.h>
 #include <asm/topology.h>
@@ -736,6 +737,9 @@ void __init setup_arch(char **cmdline_p)
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
+	/* OFW also may relocate the fixmap */
+	olpc_ofw_detect_range();
+
 	early_trap_init();
 	early_cpu_init();
 	early_ioremap_init();
-- 
1.5.6.5

