Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0JEOz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:55:27 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:35235 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab0JEOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:55:26 -0400
X-Greylist: delayed 77988 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 10:55:25 EDT
From: Daniel Drake <dsd@laptop.org>
To: mjg@redhat.com
Cc: dilinger@queued.net
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Add OLPC XO-1 rfkill driver
Message-Id: <20101005145521.D578A9D401B@zog.reactivated.net>
Date: Tue,  5 Oct 2010 15:55:21 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=5pZsCm7Rc1QA:10 a=Op-mwl0xAAAA:8 a=aag1x6BwMVUhVj85fKQA:9 a=bG41hHBPTqOXG0d83mcA:7 a=pqB_rrBIPa11ORtk9L2CJJkC_V0A:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a software rfkill switch for the WLAN interface in the OLPC XO-1
laptop. It uses the OLPC embedded controller to cut/restore power to
the Marvell WLAN chip on the motherboard.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/include/asm/olpc.h       |    2 +
 drivers/platform/x86/Kconfig      |    8 ++++
 drivers/platform/x86/Makefile     |    1 +
 drivers/platform/x86/xo1-rfkill.c |   85 +++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/xo1-rfkill.c

v2: removed "loading" message

diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 101229b..42a978c 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -89,6 +89,8 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 /* EC commands */
 
 #define EC_FIRMWARE_REV		0x08
+#define EC_WLAN_ENTER_RESET	0x35
+#define EC_WLAN_LEAVE_RESET	0x25
 
 /* SCI source values */
 
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index b49f9b1..d7e56b3 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -595,4 +595,12 @@ config INTEL_IPS
 	  functionality.  If in doubt, say Y here; it will only load on
 	  supported platforms.
 
+config XO1_RFKILL
+	tristate "OLPC XO-1 software RF kill switch"
+	depends on OLPC
+	depends on RFKILL
+	---help---
+	  Support for enabling/disabling the WLAN interface on the OLPC XO-1
+	  laptop.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index b26df2e..cd87f83 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -30,4 +30,5 @@ obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 obj-$(CONFIG_RAR_REGISTER)	+= intel_rar_register.o
 obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
 obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
+obj-$(CONFIG_XO1_RFKILL)	+= xo1-rfkill.o
 
diff --git a/drivers/platform/x86/xo1-rfkill.c b/drivers/platform/x86/xo1-rfkill.c
new file mode 100644
index 0000000..e549eee
--- /dev/null
+++ b/drivers/platform/x86/xo1-rfkill.c
@@ -0,0 +1,85 @@
+/*
+ * Support for rfkill through the OLPC XO-1 laptop embedded controller
+ *
+ * Copyright (C) 2010 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/rfkill.h>
+
+#include <asm/olpc.h>
+
+static int rfkill_set_block(void *data, bool blocked)
+{
+	unsigned char cmd;
+	if (blocked)
+		cmd = EC_WLAN_ENTER_RESET;
+	else
+		cmd = EC_WLAN_LEAVE_RESET;
+
+	return olpc_ec_cmd(cmd, NULL, 0, NULL, 0);
+}
+
+static const struct rfkill_ops rfkill_ops = {
+	.set_block = rfkill_set_block,
+};
+
+static int __devinit xo1_rfkill_probe(struct platform_device *pdev)
+{
+	struct rfkill *rfk;
+	int r;
+
+	rfk = rfkill_alloc(pdev->name, &pdev->dev, RFKILL_TYPE_WLAN,
+			   &rfkill_ops, NULL);
+	if (!rfk)
+		return -ENOMEM;
+
+	r = rfkill_register(rfk);
+	if (r) {
+		rfkill_destroy(rfk);
+		return r;
+	}
+
+	platform_set_drvdata(pdev, rfk);
+	return 0;
+}
+
+static int __devexit xo1_rfkill_remove(struct platform_device *pdev)
+{
+	struct rfkill *rfk = platform_get_drvdata(pdev);
+	rfkill_unregister(rfk);
+	rfkill_destroy(rfk);
+	return 0;
+}
+
+static struct platform_driver xo1_rfkill_driver = {
+	.driver = {
+		.name = "xo1-rfkill",
+		.owner = THIS_MODULE,
+	},
+	.probe		= xo1_rfkill_probe,
+	.remove		= __devexit_p(xo1_rfkill_remove),
+};
+
+static int __init xo1_rfkill_init(void)
+{
+	return platform_driver_register(&xo1_rfkill_driver);
+}
+
+static void __exit xo1_rfkill_exit(void)
+{
+	platform_driver_unregister(&xo1_rfkill_driver);
+}
+
+MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:xo1-rfkill");
+
+module_init(xo1_rfkill_init);
+module_exit(xo1_rfkill_exit);
-- 
1.7.2.3

