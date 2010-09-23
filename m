Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab0IWUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:05:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:35105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab0IWUFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:05:39 -0400
Date: Thu, 23 Sep 2010 20:05:22 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100923162846.D8D409D401B@zog.reactivated.net>
References: <20100923162846.D8D409D401B@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Rework BIOS signature check
Message-ID: <tip-3e3c486012a3dbb113c0ca15ee265d309d77aea9@git.kernel.org>
Git-Commit-ID: 3e3c486012a3dbb113c0ca15ee265d309d77aea9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 20:05:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e3c486012a3dbb113c0ca15ee265d309d77aea9
Gitweb:     http://git.kernel.org/tip/3e3c486012a3dbb113c0ca15ee265d309d77aea9
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Thu, 23 Sep 2010 17:28:46 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 23 Sep 2010 11:15:00 -0700

x86, olpc: Rework BIOS signature check

The XO-1.5 laptop is not currently detected as an OLPC machine because
it fails this XO-1-centric check.

Now that we have OLPC OFW support in the kernel, a more sensible
check is to see if we found OFW during boot and check the architecture
property.

Also remove a now-meaningless codepath, as we're always going to have
OFW support with OLPC.

Signed-off-by: Daniel Drake <dsd@laptop.org>
LKML-Reference: <20100923162846.D8D409D401B@zog.reactivated.net>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
 
