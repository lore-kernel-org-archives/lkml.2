Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab1F3Gct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:32:49 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:33148 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758433Ab1F3Gcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:32:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Cc: Axel Lin <axel.lin@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] staging/ste_rmi4: remove cross-dependent platform data
Date: Thu, 30 Jun 2011 08:31:59 +0200
Message-ID: <1309415519-27887-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The ux500 machine was actually defining platform data for the
staging driver ste_rmi4, which is not OK. Let us instead define
some __weak platform data in the machine so that the staging
driver can override it at compile-time and we can thus have the
driver self-contained in staging.

Reported-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-u8500uib.c        |   24 +-------------
 drivers/staging/ste_rmi4/Makefile                  |    1 +
 .../staging/ste_rmi4/board-mop500-u8500uib-rmi4.c  |   32 ++++++++++++++++++++
 3 files changed, 35 insertions(+), 22 deletions(-)
 create mode 100644 drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c

diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
index d8a8734..8ce46c0 100644
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
@@ -12,34 +12,14 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/input/matrix_keypad.h>
-#include <../drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h>
 
 #include <mach/gpio.h>
 #include <mach/irqs.h>
 
 #include "board-mop500.h"
 
-/*
- * Synaptics RMI4 touchscreen interface on the U8500 UIB
- */
-
-/*
- * Descriptor structure.
- * Describes the number of i2c devices on the bus that speak RMI.
- */
-static struct synaptics_rmi4_platform_data rmi4_i2c_dev_platformdata = {
-	.irq_number     = NOMADIK_GPIO_TO_IRQ(84),
-	.irq_type       = (IRQF_TRIGGER_FALLING | IRQF_SHARED),
-	.x_flip		= false,
-	.y_flip		= true,
-	.regulator_en   = false,
-};
-
-static struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
-	{
-		I2C_BOARD_INFO("synaptics_rmi4_i2c", 0x4B),
-		.platform_data = &rmi4_i2c_dev_platformdata,
-	},
+/* Dummy data that can be overridden by staging driver */
+struct i2c_board_info __initdata __weak mop500_i2c3_devices_u8500[] = {
 };
 
 /*
diff --git a/drivers/staging/ste_rmi4/Makefile b/drivers/staging/ste_rmi4/Makefile
index 6cce2ed..176f469 100644
--- a/drivers/staging/ste_rmi4/Makefile
+++ b/drivers/staging/ste_rmi4/Makefile
@@ -2,3 +2,4 @@
 # Makefile for the RMI4 touchscreen driver.
 #
 obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4) += synaptics_i2c_rmi4.o
+obj-$(CONFIG_MACH_U8500) += board-mop500-u8500uib-rmi4.o
diff --git a/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c b/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
new file mode 100644
index 0000000..a272e48
--- /dev/null
+++ b/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
@@ -0,0 +1,32 @@
+/*
+ * Some platform data for the RMI4 touchscreen that will override the __weak
+ * platform data in the Ux500 machine if this driver is activated.
+ */
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <mach/gpio.h>
+#include <mach/irqs.h>
+#include "synaptics_i2c_rmi4.h"
+
+/*
+ * Synaptics RMI4 touchscreen interface on the U8500 UIB
+ */
+
+/*
+ * Descriptor structure.
+ * Describes the number of i2c devices on the bus that speak RMI.
+ */
+static struct synaptics_rmi4_platform_data rmi4_i2c_dev_platformdata = {
+	.irq_number     = NOMADIK_GPIO_TO_IRQ(84),
+	.irq_type       = (IRQF_TRIGGER_FALLING | IRQF_SHARED),
+	.x_flip		= false,
+	.y_flip		= true,
+};
+
+struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
+	{
+		I2C_BOARD_INFO("synaptics_rmi4_i2c", 0x4B),
+		.platform_data = &rmi4_i2c_dev_platformdata,
+	},
+};
-- 
1.7.3.2

