Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab0IWQ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:28:51 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:32282 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642Ab0IWQ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:28:50 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH 2/2] OLPC: Rework BIOS signature check
Message-Id: <20100923162846.D8D409D401B@zog.reactivated.net>
Date: Thu, 23 Sep 2010 17:28:46 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=KJUwJhDBRDkA:10 a=Op-mwl0xAAAA:8 a=xRZQz1kq87uNA89Rg7YA:9 a=BOuYUHBBwgCDq1BcC9AA:7 a=hVSxGqmtYnRTfTCpPfqFYbsD91cA:4 a=d4CUUju0HPYA:10 a=BoFvMwN0snMlgc9m:21 a=G76dlFTRHT73kzak:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XO-1.5 laptop is not currently detected as an OLPC machine because
it fails this XO-1-centric check.

Now that we have OLPC OFW support in the kernel, a more sensible
check is to see if we found OFW during boot and check the architecture
property.

Also remove a now-meaningless codepath, as we're always going to have
OFW support with OLPC.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---

Replaces earlier patch: [PATCH 3/3] OLPC: Extend BIOS signature check
Now checks OFW's architecture property to be really sure that we're
running on an OLPC laptop.

 arch/x86/Kconfig                |    3 +-
 arch/x86/include/asm/olpc_ofw.h |    4 +++
 arch/x86/kernel/olpc.c          |   58 +++++++++++++++++----------------------
 arch/x86/kernel/olpc_ofw.c      |    6 ++++
 4 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0ed4c9b..c255255 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2061,6 +2061,7 @@ config SCx200HR_TIMER
 config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
+	select OLPC_OPENFIRMWARE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
@@ -2068,7 +2069,7 @@ config OLPC
 config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
 	depends on !X86_64 && !X86_PAE
-	default y if OLPC
+	default n
 	help
 	  This option adds support for the implementation of Open Firmware
 	  that is used on the OLPC XO-1 Children's Machine.
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index 08fde47..2a84781 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -21,10 +21,14 @@ extern void olpc_ofw_detect(void);
 /* install OFW's pde permanently into the kernel's pgtable */
 extern void setup_olpc_ofw_pgd(void);
 
+/* check if OFW was detected during boot */
+extern bool olpc_ofw_present(void);
+
 #else /* !CONFIG_OLPC_OPENFIRMWARE */
 
 static inline void olpc_ofw_detect(void) { }
 static inline void setup_olpc_ofw_pgd(void) { }
+static inline bool olpc_ofw_present(void) { return false; }
 
 #endif /* !CONFIG_OLPC_OPENFIRMWARE */
 
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 635888c..37c49934 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -183,8 +183,21 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-#ifdef CONFIG_OLPC_OPENFIRMWARE
-static void __init platform_detect(void)
+static bool __init check_ofw_architecture(void)
+{
+	size_t propsize;
+	char olpc_arch[5];
+	const void *args[] = { NULL, "architecture", olpc_arch, (void *)5 };
+	void *res[] = { &propsize };
+
+	if (olpc_ofw("getprop", args, res)) {
+		printk(KERN_ERR "ofw: getprop call failed!\n");
+		return false;
+	}
+	return propsize == 5 && strncmp("OLPC", olpc_arch, 5) == 0;
+}
+
+static u32 __init get_board_revision(void)
 {
 	size_t propsize;
 	__be32 rev;
@@ -193,46 +206,27 @@ static void __init platform_detect(void)
 
 	if (olpc_ofw("getprop", args, res) || propsize != 4) {
 		printk(KERN_ERR "ofw: getprop call failed!\n");
-		rev = cpu_to_be32(0);
+		return cpu_to_be32(0);
 	}
-	olpc_platform_info.boardrev = be32_to_cpu(rev);
+	return be32_to_cpu(rev);
 }
-#else
-static void __init platform_detect(void)
+
+static bool __init platform_detect(void)
 {
-	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = olpc_board(0xc2);
+	if (!check_ofw_architecture())
+		return false;
+	olpc_platform_info.flags |= OLPC_F_PRESENT;
+	olpc_platform_info.boardrev = get_board_revision();
+	return true;
 }
-#endif
 
 static int __init olpc_init(void)
 {
-	unsigned char *romsig;
-
-	/* The ioremap check is dangerous; limit what we run it on */
-	if (!is_geode() || cs5535_has_vsa2())
+	if (!olpc_ofw_present() || !platform_detect())
 		return 0;
 
 	spin_lock_init(&ec_lock);
 
-	romsig = ioremap(0xffffffc0, 16);
-	if (!romsig)
-		return 0;
-
-	if (strncmp(romsig, "CL1   Q", 7))
-		goto unmap;
-	if (strncmp(romsig+6, romsig+13, 3)) {
-		printk(KERN_INFO "OLPC BIOS signature looks invalid.  "
-				"Assuming not OLPC\n");
-		goto unmap;
-	}
-
-	printk(KERN_INFO "OLPC board with OpenFirmware %.16s\n", romsig);
-	olpc_platform_info.flags |= OLPC_F_PRESENT;
-
-	/* get the platform revision */
-	platform_detect();
-
 	/* assume B1 and above models always have a DCON */
 	if (olpc_board_at_least(olpc_board(0xb1)))
 		olpc_platform_info.flags |= OLPC_F_DCON;
@@ -254,8 +248,6 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
-unmap:
-	iounmap(romsig);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
index 3218aa7..7873204 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -74,6 +74,12 @@ int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
 }
 EXPORT_SYMBOL_GPL(__olpc_ofw);
 
+bool olpc_ofw_present(void)
+{
+	return olpc_ofw_cif != NULL;
+}
+EXPORT_SYMBOL_GPL(olpc_ofw_present);
+
 /* OFW cif _should_ be above this address */
 #define OFW_MIN 0xff000000
 
-- 
1.7.2.2

