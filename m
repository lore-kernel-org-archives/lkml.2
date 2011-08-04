Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1HDXZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:25:58 -0400
Received: from lunge.queued.net ([173.255.254.236]:34987 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1HDXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:25:54 -0400
Date: Thu, 4 Aug 2011 16:25:51 -0700
From: Andres Salomon <dilinger@queued.net>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        eric.y.miao@gmail.com, Russell King <linux@arm.linux.org.uk>,
        Mitch Bradley <wmb@laptop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, dsd@laptop.org
Subject: [PATCH RFC v1] ARM: olpc: Add support for calling into the
 XO-1.75's OpenFirmware (OFW)
Message-ID: <20110804162551.2b92b2cf@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for saving OFW's cif, and later calling into it to run OFW
commands from the kernel.  OFW remains resident in memory after boot,
and the physical/virtual addresses are passed in a boot tag.  We parse
that, and map the addresses.

This is currently only used by the OLPC XO-1.75, so it's named olpc_ofw().

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 Documentation/arm/Setup                  |    2 +
 arch/arm/Kconfig                         |    8 ++
 arch/arm/include/asm/olpc_ofw.h          |   23 ++++++
 arch/arm/include/asm/setup.h             |   24 ++++++
 arch/arm/mach-mmp/Makefile               |    1 +
 arch/arm/mach-mmp/include/mach/vmalloc.h |    2 +-
 arch/arm/mach-mmp/olpc-xo-1-75.c         |    7 ++
 arch/arm/mach-mmp/olpc_ofw.c             |  118 ++++++++++++++++++++++++++++++
 8 files changed, 184 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/include/asm/olpc_ofw.h
 create mode 100644 arch/arm/mach-mmp/olpc_ofw.c


I'm looking for input on our mechanism for calling into OLPC's openfirmware
on arm.  Some of the x86 folks are cc'd
as they had lots of comment when we did this for x86 OLPC machines.

There's a device tree patch on top of this that can be seen here:
http://dev.laptop.org/git/olpc-3.0/patch/?id=12377851f9a64a9e2098adf09f858bed7d3eae7c

Unlike the XO-1, I'd like to get this OFW communication mechanism ACKed prior to
OLPC's mass production of these units.

diff --git a/Documentation/arm/Setup b/Documentation/arm/Setup
index 0cb1e64..e9272ff 100644
--- a/Documentation/arm/Setup
+++ b/Documentation/arm/Setup
@@ -124,6 +124,8 @@ below:
 
    These are now obsolete, and should not be used.
 
+TODO: document olpc stuff
+
  commandline
 
    Kernel command line parameters.  Details can be found elsewhere.
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5adeb8b..a1d9801 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2028,6 +2028,14 @@ config ARCH_SUSPEND_POSSIBLE
 
 endmenu
 
+if ARCH_MMP
+config OLPC
+	bool "One Laptop Per Child support"
+	---help---
+	  Add support for detecting the unique features of the OLPC
+	  XO hardware.
+endif
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/arm/include/asm/olpc_ofw.h b/arch/arm/include/asm/olpc_ofw.h
new file mode 100644
index 0000000..5346e9f
--- /dev/null
+++ b/arch/arm/include/asm/olpc_ofw.h
@@ -0,0 +1,23 @@
+#ifndef _ASM_ARM_OLPC_OFW_H
+#define _ASM_ARM_OLPC_OFW_H
+
+#ifdef CONFIG_OLPC
+
+/* run an OFW command by calling into the firmware */
+#define olpc_ofw(name, args, res) \
+	__olpc_ofw((name), ARRAY_SIZE(args), args, ARRAY_SIZE(res), res)
+
+extern int __olpc_ofw(const char *name, int nr_args, const void **args,
+		int nr_res, void **res);
+
+/* map OFW's page tables into kernel memory */
+extern void setup_olpc_ofw_mapping(void);
+
+/* check if OFW was detected during boot */
+extern bool olpc_ofw_present(void);
+
+#else /* !CONFIG_OLPC */
+static inline void setup_olpc_ofw_mapping(void) { }
+#endif /* !CONFIG_OLPC */
+
+#endif /* _ASM_ARM_OLPC_OFW_H */
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index ee2ad8a..c75889e 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -143,6 +143,25 @@ struct tag_memclk {
 	__u32 fmemclk;
 };
 
+/* OLPC OpenFirmware callback parameters: see arch/arm/mach-mmp/olpc_ofw.c */
+#define ATAG_OLPC_OFW	0x41000502
+
+struct tag_olpc_ofw {
+	__u32 cif_handler;	/* callback into OFW */
+
+	/* map_desc one - OFW's main memory */
+	__u32 ofw_va;
+	__u32 ofw_pfn;		/* physical address's PFN */
+	__u32 ofw_length;
+	__u32 ofw_mem_type;	/* MT_ */
+
+	/* map_desc two - OFW's frame buffer */
+	__u32 fb_va;
+	__u32 fb_pfn;		/* physical address's PFN */
+	__u32 fb_length;
+	__u32 fb_mem_type;	/* MT_ */
+};
+
 struct tag {
 	struct tag_header hdr;
 	union {
@@ -165,6 +184,11 @@ struct tag {
 		 * DC21285 specific
 		 */
 		struct tag_memclk	memclk;
+
+		/*
+		 * OLPC specific - for OLPC's OpenFirmware implementation
+		 */
+		struct tag_olpc_ofw	olpc_ofw;
 	} u;
 };
 
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index 00a4954..398da1d 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_MACH_FLINT)	+= flint.o
 obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
 obj-$(CONFIG_MACH_TETON_BGA)	+= teton_bga.o
 obj-$(CONFIG_MACH_OLPC_XO_1_75)	+= olpc-xo-1-75.o
+obj-$(CONFIG_OLPC)		+= olpc_ofw.o
diff --git a/arch/arm/mach-mmp/include/mach/vmalloc.h b/arch/arm/mach-mmp/include/mach/vmalloc.h
index 1d0bac0..3801e26 100644
--- a/arch/arm/mach-mmp/include/mach/vmalloc.h
+++ b/arch/arm/mach-mmp/include/mach/vmalloc.h
@@ -2,4 +2,4 @@
  * linux/arch/arm/mach-mmp/include/mach/vmalloc.h
  */
 
-#define VMALLOC_END	0xfe000000UL
+#define VMALLOC_END	0xfd600000UL
diff --git a/arch/arm/mach-mmp/olpc-xo-1-75.c b/arch/arm/mach-mmp/olpc-xo-1-75.c
index 46261db..9efb351 100644
--- a/arch/arm/mach-mmp/olpc-xo-1-75.c
+++ b/arch/arm/mach-mmp/olpc-xo-1-75.c
@@ -29,6 +29,7 @@
 #include <video/pxa168fb.h>
 #include <plat/sdhci.h>
 #include <linux/mmc/sdhci.h>
+#include <asm/olpc_ofw.h>
 #include "common.h"
 
 struct olpc_platform_t olpc_platform_info;
@@ -369,6 +370,11 @@ void olpc_xo_1_75_restart(char mode, const char *cmd)
 	olpc_xo_1_75_ec_cmd(ec_cmd, NULL, 0);
 }
 
+static void __init olpc_init_early(void)
+{
+	setup_olpc_ofw_mapping();
+}
+
 static void __init olpc_xo_1_75_init(void)
 {
 	u32 twsi6_lcr;
@@ -451,4 +457,5 @@ MACHINE_START(OLPC_XO_1_75, "OLPC XO-1.75")
 	.map_io		= mmp_map_io,
 	.init_irq	= mmp2_init_irq,
 	.timer		= &mmp2_timer,
+	.init_early	= olpc_init_early,
 MACHINE_END
diff --git a/arch/arm/mach-mmp/olpc_ofw.c b/arch/arm/mach-mmp/olpc_ofw.c
new file mode 100644
index 0000000..55da24e
--- /dev/null
+++ b/arch/arm/mach-mmp/olpc_ofw.c
@@ -0,0 +1,118 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/pgtable.h>
+#include <asm/mach/map.h>
+#include <asm/olpc_ofw.h>
+#include <asm/memory.h>
+
+static struct map_desc olpc_ofw_map[] __initdata = {
+	{
+		.type		= MT_MEMORY,
+	},
+	{
+		.type		= MT_MEMORY,
+	},
+};
+
+/* address of OFW callback interface; will be NULL if OFW isn't found */
+static int (*olpc_ofw_cif)(int *);
+
+static DEFINE_SPINLOCK(ofw_lock);
+
+#define MAXARGS 10
+
+void __init setup_olpc_ofw_mapping(void)
+{
+	u32 *cif;
+
+	if (!olpc_ofw_cif)
+		return;
+
+	iotable_init(olpc_ofw_map, ARRAY_SIZE(olpc_ofw_map));
+
+	/* verify page table setup worked; *cif should point somewhere sane */
+	cif = (u32*)olpc_ofw_cif;
+	if (*cif == 0x0 || *cif > 0xffff0000) {
+		pr_err("OFW page tables are invalid (*cif=%x) - disabling.\n",
+				*cif);
+		olpc_ofw_cif = NULL;
+	}
+}
+
+int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
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
+bool olpc_ofw_present(void)
+{
+	return olpc_ofw_cif != NULL;
+}
+EXPORT_SYMBOL_GPL(olpc_ofw_present);
+
+static int __init parse_tag_olpc_ofw(const struct tag *tag)
+{
+	int i;
+
+	olpc_ofw_cif = (int (*)(int *))tag->u.olpc_ofw.cif_handler;
+
+	olpc_ofw_map[0].virtual = tag->u.olpc_ofw.ofw_va;
+	olpc_ofw_map[0].pfn = tag->u.olpc_ofw.ofw_pfn;
+	olpc_ofw_map[0].length = tag->u.olpc_ofw.ofw_length;
+
+	olpc_ofw_map[1].virtual = tag->u.olpc_ofw.fb_va;
+	olpc_ofw_map[1].pfn = tag->u.olpc_ofw.fb_pfn;
+	olpc_ofw_map[1].length = tag->u.olpc_ofw.fb_length;
+
+	if (olpc_ofw_map[0].virtual < VMALLOC_END) {
+		pr_err("Invalid start address for OFW (%lx), disabling.\n",
+				olpc_ofw_map[0].virtual);
+		olpc_ofw_cif = NULL;
+		return -EIO;
+	}
+
+	pr_info("OFW detected in memory, cif @ 0x%p:\n", olpc_ofw_cif);
+	for (i = 0; i < ARRAY_SIZE(olpc_ofw_map); i++) {
+		struct map_desc *desc = &olpc_ofw_map[i];
+		pr_info("  0x%lx - 0x%lx (%luMB)\n", desc->virtual,
+				desc->virtual + desc->length - 1,
+				desc->length >> 20);
+	}
+
+	return 0;
+}
+
+__tagtable(ATAG_OLPC_OFW, parse_tag_olpc_ofw);
-- 
1.7.2.5

