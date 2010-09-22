Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0IVQos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:44:48 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:19593 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab0IVQor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:44:47 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH 3/3] OLPC: Extend BIOS signature check
Message-Id: <20100922164437.5712F9D401B@zog.reactivated.net>
Date: Wed, 22 Sep 2010 17:44:37 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=zEniI-0oLhoA:10 a=Op-mwl0xAAAA:8 a=xxf6Gh7Pd-4U25aQabwA:9 a=Nv0QrfaMCrRxAVo4gq4A:7 a=866CqDku5OpZPgGCEPrTKy_POukA:4 a=d4CUUju0HPYA:10 a=wDda77cqL8FMGv8_:21 a=yjSnRRjsHjwwyRaT:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XO-1.5 laptop is not currently detected as an OLPC machine because
it fails this XO-1-centric check.

Now that we have OLPC OFW support in the kernel, a more sensible check is
to see if we found OFW during boot. This also eliminates the need to check
the BIOS signature, since we trust the detection code in olpc_ofw.c

Also remove a now-meaningless codepath, as we're always going to have
OFW support with OLPC.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig                |    2 +-
 arch/x86/include/asm/olpc_ofw.h |    4 ++++
 arch/x86/kernel/olpc.c          |   28 +---------------------------
 arch/x86/kernel/olpc_ofw.c      |    6 ++++++
 4 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 708ee0d..405237a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2055,6 +2055,7 @@ config OLPC
 	select PCI
 	select PCI_GOANY
 	select GPIOLIB
+	select OLPC_OPENFIRMWARE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
@@ -2062,7 +2063,6 @@ config OLPC
 config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
 	depends on !X86_64 && !X86_PAE
-	default y if OLPC
 	help
 	  This option adds support for the implementation of Open Firmware
 	  that is used on the OLPC XO-1 Children's Machine.
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index 08fde47..3db5556 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -21,10 +21,14 @@ extern void olpc_ofw_detect(void);
 /* install OFW's pde permanently into the kernel's pgtable */
 extern void setup_olpc_ofw_pgd(void);
 
+/* check if OFW was detected during boot */
+int olpc_ofw_present(void);
+
 #else /* !CONFIG_OLPC_OPENFIRMWARE */
 
 static inline void olpc_ofw_detect(void) { }
 static inline void setup_olpc_ofw_pgd(void) { }
+static inline int olpc_ofw_present(void) { return 0; }
 
 #endif /* !CONFIG_OLPC_OPENFIRMWARE */
 
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 10b4dce..52ecc3f 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -183,7 +183,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-#ifdef CONFIG_OLPC_OPENFIRMWARE
 static void __init platform_detect(void)
 {
 	size_t propsize;
@@ -197,37 +196,14 @@ static void __init platform_detect(void)
 	}
 	olpc_platform_info.boardrev = be32_to_cpu(rev);
 }
-#else
-static void __init platform_detect(void)
-{
-	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = olpc_board(0xc2);
-}
-#endif
 
 static int __init olpc_init(void)
 {
-	unsigned char *romsig;
-
-	/* The ioremap check is dangerous; limit what we run it on */
-	if (!is_geode() || cs5535_has_vsa2())
+	if (!olpc_ofw_present())
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
 	olpc_platform_info.flags |= OLPC_F_PRESENT;
 
 	/* get the platform revision */
@@ -250,8 +226,6 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
-unmap:
-	iounmap(romsig);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
index 3218aa7..e7bfcc4 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -74,6 +74,12 @@ int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
 }
 EXPORT_SYMBOL_GPL(__olpc_ofw);
 
+int olpc_ofw_present(void)
+{
+	return olpc_ofw_cif != NULL;
+}
+EXPORT_SYMBOL_GPL(olpc_ofw_present);
+
 /* OFW cif _should_ be above this address */
 #define OFW_MIN 0xff000000
 
-- 
1.7.2.2

