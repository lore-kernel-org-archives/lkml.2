Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1CMPKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:10:38 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:9767 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342Ab1CMPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:10:36 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: grant.likely@secretlab.ca
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: Use device tree for platform identification
Message-Id: <20110313151017.C255F9D401E@zog.reactivated.net>
Date: Sun, 13 Mar 2011 15:10:17 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=QMH1L2-zRVQA:10 a=Op-mwl0xAAAA:8 a=nkpQrn9TIDMzSISjtNoA:9 a=wfpXnx92m7czEnXlGncA:7 a=djOyjYbLacJkK0hq4BJrfHy5KNwA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make OLPC fully depend on device tree, and use it to identify the OLPC
platform details. Some nodes are exposed as platform devices where we
plan to use device tree for device probing.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig                 |    2 +-
 arch/x86/include/asm/olpc_ofw.h  |    9 ++----
 arch/x86/platform/olpc/Makefile  |    4 +--
 arch/x86/platform/olpc/olpc.c    |   51 ++++++++++++++++++++------------------
 arch/x86/platform/olpc/olpc_dt.c |   19 ++++++++++++++
 5 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 212186d..1dd0d8f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2069,7 +2069,7 @@ config OLPC
 	depends on !X86_PAE
 	select GPIOLIB
 	select OF
-	select OF_PROMTREE if PROC_DEVICETREE
+	select OF_PROMTREE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index c5d3a5a..2448771 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -26,15 +26,12 @@ extern void setup_olpc_ofw_pgd(void);
 /* check if OFW was detected during boot */
 extern bool olpc_ofw_present(void);
 
+extern void olpc_dt_build_devicetree(void);
+
 #else /* !CONFIG_OLPC */
 static inline void olpc_ofw_detect(void) { }
 static inline void setup_olpc_ofw_pgd(void) { }
-#endif /* !CONFIG_OLPC */
-
-#ifdef CONFIG_OF_PROMTREE
-extern void olpc_dt_build_devicetree(void);
-#else
 static inline void olpc_dt_build_devicetree(void) { }
-#endif
+#endif /* !CONFIG_OLPC */
 
 #endif /* _ASM_X86_OLPC_OFW_H */
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index c2a8cab..81c5e21 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,4 +1,2 @@
-obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
-obj-$(CONFIG_OLPC)		+= olpc_ofw.o
-obj-$(CONFIG_OF_PROMTREE)	+= olpc_dt.o
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index edaf3fe..0060fd5 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/string.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -187,41 +188,43 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-static bool __init check_ofw_architecture(void)
+static bool __init check_ofw_architecture(struct device_node *root)
 {
-	size_t propsize;
-	char olpc_arch[5];
-	const void *args[] = { NULL, "architecture", olpc_arch, (void *)5 };
-	void *res[] = { &propsize };
+	const char *olpc_arch;
+	int propsize;
 
-	if (olpc_ofw("getprop", args, res)) {
-		printk(KERN_ERR "ofw: getprop call failed!\n");
-		return false;
-	}
+	olpc_arch = of_get_property(root, "architecture", &propsize);
 	return propsize == 5 && strncmp("OLPC", olpc_arch, 5) == 0;
 }
 
-static u32 __init get_board_revision(void)
+static u32 __init get_board_revision(struct device_node *root)
 {
-	size_t propsize;
-	__be32 rev;
-	const void *args[] = { NULL, "board-revision-int", &rev, (void *)4 };
-	void *res[] = { &propsize };
-
-	if (olpc_ofw("getprop", args, res) || propsize != 4) {
-		printk(KERN_ERR "ofw: getprop call failed!\n");
-		return cpu_to_be32(0);
-	}
-	return be32_to_cpu(rev);
+	int propsize;
+	const __be32 *rev;
+
+	rev = of_get_property(root, "board-revision-int", &propsize);
+	if (propsize != 4)
+		return 0;
+
+	return be32_to_cpu(*rev);
 }
 
 static bool __init platform_detect(void)
 {
-	if (!check_ofw_architecture())
+	struct device_node *root = of_find_node_by_path("/");
+	bool success;
+
+	if (!root)
 		return false;
-	olpc_platform_info.flags |= OLPC_F_PRESENT;
-	olpc_platform_info.boardrev = get_board_revision();
-	return true;
+
+	success = check_ofw_architecture(root);
+	if (success) {
+		olpc_platform_info.boardrev = get_board_revision(root);
+		olpc_platform_info.flags |= OLPC_F_PRESENT;
+	}
+
+	of_node_put(root);
+	return success;
 }
 
 static int __init add_xo1_platform_devices(void)
diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index 044bda5..d39f63d 100644
--- a/arch/x86/platform/olpc/olpc_dt.c
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -19,7 +19,9 @@
 #include <linux/kernel.h>
 #include <linux/bootmem.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/of_pdt.h>
+#include <asm/olpc.h>
 #include <asm/olpc_ofw.h>
 
 static phandle __init olpc_dt_getsibling(phandle node)
@@ -180,3 +182,20 @@ void __init olpc_dt_build_devicetree(void)
 	pr_info("PROM DT: Built device tree with %u bytes of memory.\n",
 			prom_early_allocated);
 }
+
+/* A list of DT node/bus matches that we want to expose as platform devices */
+static struct of_device_id __initdata of_ids[] = {
+	{ .compatible = "olpc,xo1-battery" },
+	{ .compatible = "olpc,xo1-dcon" },
+	{ .compatible = "olpc,xo1-rtc" },
+	{},
+};
+
+static int __init olpc_create_platform_devices(void)
+{
+	if (machine_is_olpc())
+		return of_platform_bus_probe(NULL, of_ids, NULL);
+	else
+		return 0;
+}
+device_initcall(olpc_create_platform_devices);
-- 
1.7.4

