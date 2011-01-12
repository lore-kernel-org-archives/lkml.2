Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1ALOxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:53:44 -0500
Received: from www.tglx.de ([62.245.132.106]:50498 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab1ALOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:53:41 -0500
Date: Wed, 12 Jan 2011 15:53:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86/olpc for 2.6.38
Message-ID: <alpine.LFD.2.00.1101121552280.12146@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-olpc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-olpc-for-linus

Thanks,

	tglx

------------------>
Andres Salomon (3):
      x86, of: Define irq functions to allow drivers/of/* to build on x86
      x86, olpc: Add OLPC device-tree support
      x86, olpc: Speed up device tree creation during boot


 arch/x86/Kconfig                  |    6 +
 arch/x86/include/asm/irq.h        |    3 +
 arch/x86/include/asm/olpc_ofw.h   |    9 ++
 arch/x86/include/asm/prom.h       |    1 +
 arch/x86/kernel/irq.c             |   10 ++
 arch/x86/mm/init_32.c             |    2 +
 arch/x86/platform/olpc/Makefile   |    1 +
 arch/x86/platform/olpc/olpc_dt.c  |  183 +++++++++++++++++++++++++++++++++++++
 arch/x86/platform/olpc/olpc_ofw.c |    5 +
 9 files changed, 220 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/prom.h
 create mode 100644 arch/x86/platform/olpc/olpc_dt.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e330da2..ef34031 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2049,11 +2049,17 @@ config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
 	depends on !X86_64 && !X86_PAE
 	default n
+	select OF
 	help
 	  This option adds support for the implementation of Open Firmware
 	  that is used on the OLPC XO-1 Children's Machine.
 	  If unsure, say N here.
 
+config OLPC_OPENFIRMWARE_DT
+	bool
+	default y if OLPC_OPENFIRMWARE && PROC_DEVICETREE
+	select OF_PROMTREE
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 13b0eba..8d2c671 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,6 +10,9 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+/* Even though we don't support this, supply it to appease OF */
+static inline void irq_dispose_mapping(unsigned int virq) { }
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index 2a84781..641988e 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -8,6 +8,8 @@
 
 #ifdef CONFIG_OLPC_OPENFIRMWARE
 
+extern bool olpc_ofw_is_installed(void);
+
 /* run an OFW command by calling into the firmware */
 #define olpc_ofw(name, args, res) \
 	__olpc_ofw((name), ARRAY_SIZE(args), args, ARRAY_SIZE(res), res)
@@ -26,10 +28,17 @@ extern bool olpc_ofw_present(void);
 
 #else /* !CONFIG_OLPC_OPENFIRMWARE */
 
+static inline bool olpc_ofw_is_installed(void) { return false; }
 static inline void olpc_ofw_detect(void) { }
 static inline void setup_olpc_ofw_pgd(void) { }
 static inline bool olpc_ofw_present(void) { return false; }
 
 #endif /* !CONFIG_OLPC_OPENFIRMWARE */
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE_DT
+extern void olpc_dt_build_devicetree(void);
+#else
+static inline void olpc_dt_build_devicetree(void) { }
+#endif /* CONFIG_OLPC_OPENFIRMWARE_DT */
+
 #endif /* _ASM_X86_OLPC_OFW_H */
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
new file mode 100644
index 0000000..b4ec95f
--- /dev/null
+++ b/arch/x86/include/asm/prom.h
@@ -0,0 +1 @@
+/* dummy prom.h; here to make linux/of.h's #includes happy */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 83ec017..d833d1b 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/of.h>
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
@@ -275,6 +276,15 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
+#ifdef CONFIG_OF
+unsigned int irq_create_of_mapping(struct device_node *controller,
+		const u32 *intspec, unsigned int intsize)
+{
+	return intspec[0];
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+#endif
+
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0e969f9..8c852e4 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -45,6 +45,7 @@
 #include <asm/bugs.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/olpc_ofw.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/paravirt.h>
@@ -715,6 +716,7 @@ void __init paging_init(void)
 	/*
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
+	olpc_dt_build_devicetree();
 	sparse_init();
 	zone_sizes_init();
 }
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index c31b8fc..e797428 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_OLPC)		+= olpc.o
 obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
+obj-$(CONFIG_OLPC_OPENFIRMWARE_DT)	+= olpc_dt.o
diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
new file mode 100644
index 0000000..dab8746
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -0,0 +1,183 @@
+/*
+ * OLPC-specific OFW device tree support code.
+ *
+ * Paul Mackerras	August 1996.
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
+ *    {engebret|bergner}@us.ibm.com
+ *
+ *  Adapted for sparc by David S. Miller davem@davemloft.net
+ *  Adapted for x86/OLPC by Andres Salomon <dilinger@queued.net>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bootmem.h>
+#include <linux/of.h>
+#include <linux/of_pdt.h>
+#include <asm/olpc_ofw.h>
+
+static phandle __init olpc_dt_getsibling(phandle node)
+{
+	const void *args[] = { (void *)node };
+	void *res[] = { &node };
+
+	if ((s32)node == -1)
+		return 0;
+
+	if (olpc_ofw("peer", args, res) || (s32)node == -1)
+		return 0;
+
+	return node;
+}
+
+static phandle __init olpc_dt_getchild(phandle node)
+{
+	const void *args[] = { (void *)node };
+	void *res[] = { &node };
+
+	if ((s32)node == -1)
+		return 0;
+
+	if (olpc_ofw("child", args, res) || (s32)node == -1) {
+		pr_err("PROM: %s: fetching child failed!\n", __func__);
+		return 0;
+	}
+
+	return node;
+}
+
+static int __init olpc_dt_getproplen(phandle node, const char *prop)
+{
+	const void *args[] = { (void *)node, prop };
+	int len;
+	void *res[] = { &len };
+
+	if ((s32)node == -1)
+		return -1;
+
+	if (olpc_ofw("getproplen", args, res)) {
+		pr_err("PROM: %s: getproplen failed!\n", __func__);
+		return -1;
+	}
+
+	return len;
+}
+
+static int __init olpc_dt_getproperty(phandle node, const char *prop,
+		char *buf, int bufsize)
+{
+	int plen;
+
+	plen = olpc_dt_getproplen(node, prop);
+	if (plen > bufsize || plen < 1) {
+		return -1;
+	} else {
+		const void *args[] = { (void *)node, prop, buf, (void *)plen };
+		void *res[] = { &plen };
+
+		if (olpc_ofw("getprop", args, res)) {
+			pr_err("PROM: %s: getprop failed!\n", __func__);
+			return -1;
+		}
+	}
+
+	return plen;
+}
+
+static int __init olpc_dt_nextprop(phandle node, char *prev, char *buf)
+{
+	const void *args[] = { (void *)node, prev, buf };
+	int success;
+	void *res[] = { &success };
+
+	buf[0] = '\0';
+
+	if ((s32)node == -1)
+		return -1;
+
+	if (olpc_ofw("nextprop", args, res) || success != 1)
+		return -1;
+
+	return 0;
+}
+
+static int __init olpc_dt_pkg2path(phandle node, char *buf,
+		const int buflen, int *len)
+{
+	const void *args[] = { (void *)node, buf, (void *)buflen };
+	void *res[] = { len };
+
+	if ((s32)node == -1)
+		return -1;
+
+	if (olpc_ofw("package-to-path", args, res) || *len < 1)
+		return -1;
+
+	return 0;
+}
+
+static unsigned int prom_early_allocated __initdata;
+
+void * __init prom_early_alloc(unsigned long size)
+{
+	static u8 *mem;
+	static size_t free_mem;
+	void *res;
+
+	if (free_mem < size) {
+		const size_t chunk_size = max(PAGE_SIZE, size);
+
+		/*
+		 * To mimimize the number of allocations, grab at least
+		 * PAGE_SIZE of memory (that's an arbitrary choice that's
+		 * fast enough on the platforms we care about while minimizing
+		 * wasted bootmem) and hand off chunks of it to callers.
+		 */
+		res = alloc_bootmem(chunk_size);
+		if (!res)
+			return NULL;
+		prom_early_allocated += chunk_size;
+		memset(res, 0, chunk_size);
+		free_mem = chunk_size;
+		mem = res;
+	}
+
+	/* allocate from the local cache */
+	free_mem -= size;
+	res = mem;
+	mem += size;
+	return res;
+}
+
+static struct of_pdt_ops prom_olpc_ops __initdata = {
+	.nextprop = olpc_dt_nextprop,
+	.getproplen = olpc_dt_getproplen,
+	.getproperty = olpc_dt_getproperty,
+	.getchild = olpc_dt_getchild,
+	.getsibling = olpc_dt_getsibling,
+	.pkg2path = olpc_dt_pkg2path,
+};
+
+void __init olpc_dt_build_devicetree(void)
+{
+	phandle root;
+
+	if (!olpc_ofw_is_installed())
+		return;
+
+	root = olpc_dt_getsibling(0);
+	if (!root) {
+		pr_err("PROM: unable to get root node from OFW!\n");
+		return;
+	}
+	of_pdt_build_devicetree(root, &prom_olpc_ops);
+
+	pr_info("PROM DT: Built device tree with %u bytes of memory.\n",
+			prom_early_allocated);
+}
diff --git a/arch/x86/platform/olpc/olpc_ofw.c b/arch/x86/platform/olpc/olpc_ofw.c
index 7873204..e7604f6 100644
--- a/arch/x86/platform/olpc/olpc_ofw.c
+++ b/arch/x86/platform/olpc/olpc_ofw.c
@@ -110,3 +110,8 @@ void __init olpc_ofw_detect(void)
 			(unsigned long)olpc_ofw_cif, (-start) >> 20);
 	reserve_top_address(-start);
 }
+
+bool __init olpc_ofw_is_installed(void)
+{
+	return olpc_ofw_cif != NULL;
+}
