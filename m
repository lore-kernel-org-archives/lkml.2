Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab0FRTmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:42:53 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:39011 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0FRTmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:42:52 -0400
Date: Fri, 18 Jun 2010 15:42:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, Mitch Bradley <wmb@laptop.org>
Subject: [PATCH] x86: OLPC: add support for calling into OpenFirmware (v5)
Message-ID: <20100618154245.2e00af2a@dev.queued.net>
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
table, we grab and install that one entry permanently in the kernel's
page table.

This is currently only used by the OLPC XO.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 Documentation/x86/zero-page.txt  |    1 +
 arch/x86/Kconfig                 |    9 +++
 arch/x86/include/asm/bootparam.h |   11 ++++-
 arch/x86/include/asm/olpc_ofw.h  |   31 +++++++++++
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/head_32.S        |    6 ++
 arch/x86/kernel/olpc.c           |   12 ++---
 arch/x86/kernel/olpc_ofw.c       |  106 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c          |    6 ++
 9 files changed, 175 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/olpc_ofw.h
 create mode 100644 arch/x86/kernel/olpc_ofw.c

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index feb37e1..cf5437d 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -18,6 +18,7 @@ Offset	Proto	Name		Meaning
 080/010	ALL	hd0_info	hd0 disk parameter, OBSOLETE!!
 090/010	ALL	hd1_info	hd1 disk parameter, OBSOLETE!!
 0A0/010	ALL	sys_desc_table	System description table (struct sys_desc_table)
+0B0/010	ALL	olpc_ofw_header	OLPC's OpenFirmware CIF and friends
 140/080	ALL	edid_info	Video mode setup (struct edid_info)
 1C0/020	ALL	efi_info	EFI 32 information (struct efi_info)
 1E0/004	ALL	alk_mem_k	Alternative mem check, in KB
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
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 6be33d8..8e62185 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -70,6 +70,14 @@ struct sys_desc_table {
 	__u8  table[14];
 };
 
+/* Gleaned from OFW's set-parameters in cpu/x86/pc/linux.fth */
+struct olpc_ofw_header {
+	__u32 ofw_magic;	/* OFW signature */
+	__u32 ofw_version;
+	__u32 cif_handler;	/* callback into OFW */
+	__u32 irq_desc_table;
+} __attribute__((packed));
+
 struct efi_info {
 	__u32 efi_loader_signature;
 	__u32 efi_systab;
@@ -92,7 +100,8 @@ struct boot_params {
 	__u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
 	__u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
 	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
-	__u8  _pad4[144];				/* 0x0b0 */
+	struct olpc_ofw_header olpc_ofw_header;		/* 0x0b0 */
+	__u8  _pad4[128];				/* 0x0c0 */
 	struct edid_info edid_info;			/* 0x140 */
 	struct efi_info efi_info;			/* 0x1c0 */
 	__u32 alt_mem_k;				/* 0x1e0 */
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
new file mode 100644
index 0000000..3e63d85
--- /dev/null
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -0,0 +1,31 @@
+#ifndef _ASM_X86_OLPC_OFW_H
+#define _ASM_X86_OLPC_OFW_H
+
+/* index into the page table containing the entry OFW occupies */
+#define OLPC_OFW_PDE_NR 1022
+
+#define OLPC_OFW_SIG 0x2057464F	/* aka "OFW " */
+
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+
+/* run an OFW command by calling into the firmware */
+#define olpc_ofw(name, args, res) \
+	__olpc_ofw((name), ARRAY_SIZE(args), args, ARRAY_SIZE(res), res)
+
+extern int __olpc_ofw(const char *name, int nr_args, void **args, int nr_res,
+		void **res);
+
+/* determine whether OFW is available and lives in the proper memory */
+extern void olpc_ofw_detect(void);
+
+/* install OFW's pde permanently into the kernel's pgtable */
+extern void setup_olpc_ofw_pgd(void);
+
+#else /* !CONFIG_OLPC_OPENFIRMWARE */
+
+static inline void olpc_ofw_detect(void) { }
+static inline void setup_olpc_ofw_pgd(void) { }
+
+#endif /* !CONFIG_OLPC_OPENFIRMWARE */
+
+#endif /* _ASM_X86_OLPC_OFW_H */
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
index 37c3d4b..ff4c453 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -131,6 +131,12 @@ ENTRY(startup_32)
 	movsl
 1:
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+	/* save OFW's pgdir table for later use when calling into OFW */
+	movl %cr3, %eax
+	movl %eax, pa(olpc_ofw_pgd)
+#endif
+
 #ifdef CONFIG_PARAVIRT
 	/* This is can only trip for a broken bootloader... */
 	cmpw $0x207, pa(boot_params + BP_version)
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
index 0000000..54a8754
--- /dev/null
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -0,0 +1,106 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/olpc_ofw.h>
+
+/* address of OFW callback interface; will be NULL if OFW isn't found */
+static int (*olpc_ofw_cif)(int *);
+
+/* page dir entry containing OFW's pgdir table; filled in by head_32.S */
+u32 olpc_ofw_pgd __initdata;
+
+static DEFINE_SPINLOCK(ofw_lock);
+
+#define MAXARGS 10
+
+void __init setup_olpc_ofw_pgd(void)
+{
+	pgd_t *base, *ofw_pde;
+
+	if (!olpc_ofw_cif)
+		return;
+
+	/* fetch OFW's PDE */
+	base = early_ioremap(olpc_ofw_pgd, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
+	if (!base) {
+		printk(KERN_ERR "failed to remap OFW's pgd - disabling OFW!\n");
+		olpc_ofw_cif = NULL;
+		return;
+	}
+	ofw_pde = &base[OLPC_OFW_PDE_NR];
+
+	/* install OFW's PDE permanently into the kernel's pgtable */
+	set_pgd(&swapper_pg_dir[OLPC_OFW_PDE_NR], *ofw_pde);
+	flush_tlb();
+	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
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
+	/* call into ofw */
+	spin_lock_irqsave(&ofw_lock, flags);
+	ret = olpc_ofw_cif(ofw_args);
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
+void __init olpc_ofw_detect(void)
+{
+	struct olpc_ofw_header *hdr = &boot_params.olpc_ofw_header;
+	unsigned long start;
+
+	/* ensure OFW booted us by checking for "OFW " string */
+	if (hdr->ofw_magic != OLPC_OFW_SIG)
+		return;
+
+	olpc_ofw_cif = (int (*)(int *))hdr->cif_handler;
+
+	if ((unsigned long)olpc_ofw_cif < OFW_MIN) {
+		printk(KERN_ERR "OFW detected, but cif has invalid address 0x%lx - disabling.\n",
+				(unsigned long)olpc_ofw_cif);
+		olpc_ofw_cif = NULL;
+		return;
+	}
+
+	/* determine where OFW starts in memory */
+	start = round_down((unsigned long)olpc_ofw_cif, OFW_BOUND);
+	printk(KERN_INFO "OFW detected in memory, cif @ 0x%lx (reserving top %ldMB)\n",
+			(unsigned long)olpc_ofw_cif, (-start) >> 20);
+	reserve_top_address(-start);
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b4ae4ac..b008e78 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -102,6 +102,7 @@
 
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
+#include <asm/olpc_ofw.h>
 
 #include <asm/percpu.h>
 #include <asm/topology.h>
@@ -736,10 +737,15 @@ void __init setup_arch(char **cmdline_p)
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
+	/* OFW also may relocate the fixmap */
+	olpc_ofw_detect();
+
 	early_trap_init();
 	early_cpu_init();
 	early_ioremap_init();
 
+	setup_olpc_ofw_pgd();
+
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
-- 
1.5.6.5

