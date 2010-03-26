Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0CZBkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:40:36 -0400
Received: from server78.greatnet.de ([83.133.96.102]:41148 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0CZBke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:40:34 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: section cleanup of 88pm860x driver
Date: Fri, 26 Mar 2010 02:40:13 +0100
Message-Id: <1269567614-26995-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes three section mismatches.

WARNING: drivers/mfd/88pm860x.o(.text+0x12): Section mismatch in
reference from the function pm860x_device_exit() to the function
.devexit.text:device_irq_exit()
The function pm860x_device_exit() references a function in an exit
section.
Often the function device_irq_exit() has valid usage outside the exit
section
and the fix is to remove the __devexit annotation of device_irq_exit.

WARNING: drivers/mfd/88pm860x.o(.text+0xb0): Section mismatch in
reference from the function pm860x_device_init() to the function
.devinit.text:device_8606_init()
The function pm860x_device_init() references
the function __devinit device_8606_init().
This is often because pm860x_device_init lacks a __devinit
annotation or the annotation of device_8606_init is wrong.

WARNING: drivers/mfd/88pm860x.o(.text+0xbe): Section mismatch in
reference from the function pm860x_device_init() to the function
.devinit.text:device_8607_init()
The function pm860x_device_init() references
the function __devinit device_8607_init().
This is often because pm860x_device_init lacks a __devinit
annotation or the annotation of device_8607_init is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/mfd/88pm860x-core.c  |    6 +++---
 include/linux/mfd/88pm860x.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 6a14d2b..5b53c76 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -564,7 +564,7 @@ out:
 	return ret;
 }
 
-static void __devexit device_irq_exit(struct pm860x_chip *chip)
+static void device_irq_exit(struct pm860x_chip *chip)
 {
 	if (chip->core_irq)
 		free_irq(chip->core_irq, chip);
@@ -701,7 +701,7 @@ out:
 	return;
 }
 
-int pm860x_device_init(struct pm860x_chip *chip,
+int __devinit pm860x_device_init(struct pm860x_chip *chip,
 		       struct pm860x_platform_data *pdata)
 {
 	chip->core_irq = 0;
@@ -729,7 +729,7 @@ int pm860x_device_init(struct pm860x_chip *chip,
 	return 0;
 }
 
-void pm860x_device_exit(struct pm860x_chip *chip)
+void __devexit pm860x_device_exit(struct pm860x_chip *chip)
 {
 	device_irq_exit(chip);
 	mfd_remove_devices(chip->dev);
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 73f92c5..2165a2c 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -369,7 +369,7 @@ extern int pm860x_set_bits(struct i2c_client *, int, unsigned char,
 			   unsigned char);
 
 extern int pm860x_device_init(struct pm860x_chip *chip,
-			      struct pm860x_platform_data *pdata);
-extern void pm860x_device_exit(struct pm860x_chip *chip);
+			      struct pm860x_platform_data *pdata) __devinit ;
+extern void pm860x_device_exit(struct pm860x_chip *chip) __devexit ;
 
 #endif /* __LINUX_MFD_88PM860X_H */
-- 
1.6.3.3

