Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1GGAsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:48:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:33235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1GGAr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:47:58 -0400
Date: Thu, 7 Jul 2011 00:47:51 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-a3128588b3c6be634a9013a375903e0b55668f0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1309019658-1712-4-git-send-email-dsd@laptop.org>
References: <1309019658-1712-4-git-send-email-dsd@laptop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Rename olpc-xo1 to olpc-xo1-pm
Git-Commit-ID: a3128588b3c6be634a9013a375903e0b55668f0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 00:47:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3128588b3c6be634a9013a375903e0b55668f0a
Gitweb:     http://git.kernel.org/tip/a3128588b3c6be634a9013a375903e0b55668f0a
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Sat, 25 Jun 2011 17:34:10 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Jul 2011 14:44:28 -0700

x86, olpc: Rename olpc-xo1 to olpc-xo1-pm

Based on earlier review comments, we'll no longer try to stick all of
our XO-1 goodies in a single driver. We'll split it into a power management
driver, and an EC/SCI driver.

As a first step, rename olpc-xo1 to olpc-xo1-pm, and make it builtin
instead of modular.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/1309019658-1712-4-git-send-email-dsd@laptop.org
Acked-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                                   |    7 ++-
 arch/x86/platform/olpc/Makefile                    |    2 +-
 .../platform/olpc/{olpc-xo1.c => olpc-xo1-pm.c}    |   43 +++++++-------------
 3 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..29615ee 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2073,11 +2073,12 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
-config OLPC_XO1
-	tristate "OLPC XO-1 support"
+config OLPC_XO1_PM
+	bool "OLPC XO-1 Power Management"
 	depends on OLPC && MFD_CS5535
+	select MFD_CORE
 	---help---
-	  Add support for non-essential features of the OLPC XO-1 laptop.
+	  Add support for poweroff of the OLPC XO-1 laptop.
 
 endif # X86_32
 
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index 81c5e21..cd25038 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
+obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o
diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1-pm.c
similarity index 70%
rename from arch/x86/platform/olpc/olpc-xo1.c
rename to arch/x86/platform/olpc/olpc-xo1-pm.c
index a63e948..a2a59d3 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -1,5 +1,5 @@
 /*
- * Support for features of the OLPC XO-1 laptop
+ * Support for power management features of the OLPC XO-1 laptop
  *
  * Copyright (C) 2010 Andres Salomon <dilinger@queued.net>
  * Copyright (C) 2010 One Laptop per Child
@@ -13,7 +13,6 @@
  */
 
 #include <linux/cs5535.h>
-#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
@@ -21,7 +20,7 @@
 #include <asm/io.h>
 #include <asm/olpc.h>
 
-#define DRV_NAME "olpc-xo1"
+#define DRV_NAME "olpc-xo1-pm"
 
 static unsigned long acpi_base;
 static unsigned long pms_base;
@@ -44,7 +43,7 @@ static void xo1_power_off(void)
 	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
 }
 
-static int __devinit olpc_xo1_probe(struct platform_device *pdev)
+static int __devinit xo1_pm_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int err;
@@ -76,7 +75,7 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit olpc_xo1_remove(struct platform_device *pdev)
+static int __devexit xo1_pm_remove(struct platform_device *pdev)
 {
 	mfd_cell_disable(pdev);
 
@@ -89,48 +88,36 @@ static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver cs5535_pms_drv = {
+static struct platform_driver cs5535_pms_driver = {
 	.driver = {
 		.name = "cs5535-pms",
 		.owner = THIS_MODULE,
 	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
+	.probe = xo1_pm_probe,
+	.remove = __devexit_p(xo1_pm_remove),
 };
 
-static struct platform_driver cs5535_acpi_drv = {
+static struct platform_driver cs5535_acpi_driver = {
 	.driver = {
 		.name = "olpc-xo1-pm-acpi",
 		.owner = THIS_MODULE,
 	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
+	.probe = xo1_pm_probe,
+	.remove = __devexit_p(xo1_pm_remove),
 };
 
-static int __init olpc_xo1_init(void)
+static int __init xo1_pm_init(void)
 {
 	int r;
 
-	r = platform_driver_register(&cs5535_pms_drv);
+	r = platform_driver_register(&cs5535_pms_driver);
 	if (r)
 		return r;
 
-	r = platform_driver_register(&cs5535_acpi_drv);
+	r = platform_driver_register(&cs5535_acpi_driver);
 	if (r)
-		platform_driver_unregister(&cs5535_pms_drv);
+		platform_driver_unregister(&cs5535_pms_driver);
 
 	return r;
 }
-
-static void __exit olpc_xo1_exit(void)
-{
-	platform_driver_unregister(&cs5535_acpi_drv);
-	platform_driver_unregister(&cs5535_pms_drv);
-}
-
-MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:cs5535-pms");
-
-module_init(olpc_xo1_init);
-module_exit(olpc_xo1_exit);
+arch_initcall(xo1_pm_init);
