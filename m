Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423940Ab2LFPnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:43:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423910Ab2LFPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:43:32 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6] mfd: stmpe: Update DT support for stmpe driver
Date: Thu,  6 Dec 2012 21:13:23 +0530
Message-Id: <3db3266122f4c54f624477b3fb6763e5821bd3d0.1354807084.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

This patch extends existing DT support for stmpe devices. This updates:
- missing header files in stmpe.c
- stmpe_of_probe() with pwm, rotator and new bindings.
- Bindings are updated in binding document.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Samuel,

I have added acked by Lee as he earlier Acked this patch, most of the part is
still the same. And nothing new added.

V5->V6:
- Removed of_devide_id tables from stmpe-i2c[spi].c

 Documentation/devicetree/bindings/mfd/stmpe.txt |  9 ++++++---
 drivers/mfd/stmpe.c                             | 27 +++++++++++++++++++------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
index 8f0aeda..d2d88d9 100644
--- a/Documentation/devicetree/bindings/mfd/stmpe.txt
+++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
@@ -1,8 +1,11 @@
-* STMPE Multi-Functional Device
+* ST Microelectronics STMPE Multi-Functional Device
+
+STMPE is an MFD device which may expose following inbuilt devices: gpio, keypad,
+touchscreen, adc, pwm, rotator.
 
 Required properties:
- - compatible                   : "st,stmpe[811|1601|2401|2403]"
- - reg                          : I2C address of the device
+ - compatible                   : "st,stmpe[610|801|811|1601|2401|2403]"
+ - reg                          : I2C/SPI address of the device
 
 Optional properties:
  - interrupts                   : The interrupt outputs from the controller
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 34408b4..bb2dfdb 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -7,12 +7,15 @@
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
  */
 
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
@@ -1019,6 +1022,14 @@ void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
 {
 	struct device_node *child;
 
+	/*
+	 * Distinct names of same cell-type within multiple instances of stmpe
+	 * will be guaranteed by DT.
+	 */
+	pdata->id = -1;
+
+	pdata->irq_trigger = IRQF_TRIGGER_NONE;
+
 	of_property_read_u32(np, "st,autosleep-timeout",
 			&pdata->autosleep_timeout);
 
@@ -1027,15 +1038,16 @@ void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
 	for_each_child_of_node(np, child) {
 		if (!strcmp(child->name, "stmpe_gpio")) {
 			pdata->blocks |= STMPE_BLOCK_GPIO;
-		}
-		if (!strcmp(child->name, "stmpe_keypad")) {
+		} else if (!strcmp(child->name, "stmpe_keypad")) {
 			pdata->blocks |= STMPE_BLOCK_KEYPAD;
-		}
-		if (!strcmp(child->name, "stmpe_touchscreen")) {
+		} else if (!strcmp(child->name, "stmpe_touchscreen")) {
 			pdata->blocks |= STMPE_BLOCK_TOUCHSCREEN;
-		}
-		if (!strcmp(child->name, "stmpe_adc")) {
+		} else if (!strcmp(child->name, "stmpe_adc")) {
 			pdata->blocks |= STMPE_BLOCK_ADC;
+		} else if (!strcmp(child->name, "stmpe_pwm")) {
+			pdata->blocks |= STMPE_BLOCK_PWM;
+		} else if (!strcmp(child->name, "stmpe_rotator")) {
+			pdata->blocks |= STMPE_BLOCK_ROTATOR;
 		}
 	}
 }
@@ -1106,6 +1118,9 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 			return -ENODEV;
 		}
 		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
+	} else if (pdata->irq_trigger == IRQF_TRIGGER_NONE) {
+		pdata->irq_trigger =
+			irqd_get_trigger_type(irq_get_irq_data(stmpe->irq));
 	}
 
 	ret = stmpe_chip_init(stmpe);
-- 
1.7.12.rc2.18.g61b472e

