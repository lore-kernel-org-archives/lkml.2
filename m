Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab1F3Omr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:42:47 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:40726 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1F3Oml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:42:41 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 10:42:41 EDT
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "Content-Type"
From: =?UTF-8?q?Sh=C3=A9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Cc: Sebastien.Hinderer@ens-lyon.org, Samuel.Thibault@ens-lyon.org,
        Valdis.Kletnieks@vt.edu, hpa@zytor.com, lenb@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, dilinger@queued.net
Subject: [PATCH] x86: the iris module should register a platform device and a platform driver.
Date: Thu, 30 Jun 2011 16:36:20 +0200
Message-Id: <1309444580-10803-1-git-send-email-Sebastien.Hinderer@ens-lyon.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the iris driver use the platform API, so as to be
properly exposed in /sys


Signed-off-by: Shérab <Sebastien.Hinderer@ens-lyon.org>
---
 arch/x86/platform/iris/iris.c |   69 +++++++++++++++++++++++++++++++++++------
 1 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/iris/iris.c b/arch/x86/platform/iris/iris.c
index 1ba7f5e..65f29da 100644
--- a/arch/x86/platform/iris/iris.c
+++ b/arch/x86/platform/iris/iris.c
@@ -23,6 +23,7 @@
 
 #include <linux/moduleparam.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
@@ -62,29 +63,77 @@ static void iris_power_off(void)
  * by reading its input port and seeing whether the read value is
  * meaningful.
  */
-static int iris_init(void)
+static int iris_probe(struct platform_device *pdev)
 {
-	unsigned char status;
-	if (force != 1) {
-		printk(KERN_ERR "The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.\n");
-		return -ENODEV;
-	}
-	status = inb(IRIS_GIO_INPUT);
+/*
+	unsigned char status = inb(IRIS_GIO_INPUT);
 	if (status == IRIS_GIO_NODEV) {
-		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
+		printk(KERN_ERR "This machine does not seem to be an Iris. "
+			"Power off handler not installed.\n");
 		return -ENODEV;
 	}
+*/
 	old_pm_power_off = pm_power_off;
 	pm_power_off = &iris_power_off;
 	printk(KERN_INFO "Iris power_off handler installed.\n");
-
 	return 0;
 }
 
-static void iris_exit(void)
+static int iris_remove(struct platform_device *pdev)
 {
 	pm_power_off = old_pm_power_off;
 	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
+	return 0;
+}
+
+static struct platform_driver iris_driver = {
+	.driver		= {
+		.name   = "iris",
+		.owner  = THIS_MODULE,
+	},
+	.probe          = iris_probe,
+	.remove         = iris_remove,
+};
+
+static struct resource iris_resources[] = {
+	{
+		.start  = IRIS_GIO_BASE,
+		.end    = IRIS_GIO_OUTPUT,
+		.flags  = IORESOURCE_IO,
+		.name   = "address"
+	}
+};
+
+static struct platform_device *iris_device;
+
+static int iris_init(void)
+{
+	int ret;
+	if (force != 1) {
+		printk(KERN_ERR "The force parameter has not been set to 1."
+			"The Iris poweroff handler will not be installed.\n");
+		return -ENODEV;
+	}
+	ret = platform_driver_register(&iris_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "Failed to register iris platform driver: "
+			"%d\n", ret);
+		return ret;
+	}
+	iris_device = platform_device_register_simple(
+		"iris", (-1), iris_resources, ARRAY_SIZE(iris_resources));
+	if (IS_ERR(iris_device)) {
+		printk(KERN_ERR "Failed to register iris platform device\n");
+		platform_driver_unregister(&iris_driver);
+		return PTR_ERR(iris_device);
+	}
+	return 0;
+}
+
+static void iris_exit(void)
+{
+	platform_device_unregister(iris_device);
+	platform_driver_unregister(&iris_driver);
 }
 
 module_init(iris_init);
-- 
1.7.5.4

