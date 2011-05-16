Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1EPSuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:50:25 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48934 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1EPSuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:50:20 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 1/5] MFD: TPS65910: Add support for TPS65911 device
Date: Mon, 16 May 2011 13:50:09 -0500
Message-Id: <C338DCFF-6434-4033-A532-C1F989A7E29C@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65911 is the next generation of the TPS65910 family of
PMIC chips. It adds a few features:

- Watchdog Timer
- PWM & LED generators
- Comparators for system control status

It also adds a set of Interrupts and GPIOs, among other things.

The driver exports a function to identify between different
versions of the tps65910 family, allowing other modules to
identify the capabilities of the current chip.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/tps65910.c       |    5 +++-
 include/linux/mfd/tps65910.h |   46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index bf649cf..11c4a66 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -139,6 +139,8 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
 
+	tps65910->id = id->driver_data;
+
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 	if (!pmic_plat_data)
 		return -EINVAL;
@@ -192,7 +194,8 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id tps65910_i2c_id[] = {
-       { "tps65910", 0 },
+       { "tps65910", TPS65910 },
+       { "tps65911", TPS65911 },
        { }
 };
 MODULE_DEVICE_TABLE(i2c, tps65910_i2c_id);
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index be08a0c..6ceea0d 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -17,6 +17,14 @@
 #ifndef __LINUX_MFD_TPS65910_H
 #define __LINUX_MFD_TPS65910_H
 
+/* TPS chip id list */
+#define TPS65910			0
+#define TPS65911			1
+
+/* TPS regulator type list */
+#define REGULATOR_LDO			0
+#define REGULATOR_DCDC			1
+
 /*
  * List of registers for component TPS65910
  *
@@ -97,6 +105,21 @@
 #define TPS65910_MAX_REGISTER				0x80
 
 /*
+ * List of registers specific to TPS65911
+ */
+#define TPS65911_VDDCTRL				0x27
+#define TPS65911_VDDCTRL_OP				0x28
+#define TPS65911_VDDCTRL_SR				0x29
+#define TPS65911_LDO1					0x30
+#define TPS65911_LDO2					0x31
+#define TPS65911_LDO5					0x32
+#define TPS65911_LDO8					0x33
+#define TPS65911_LDO7					0x34
+#define TPS65911_LDO6					0x35
+#define TPS65911_LDO4					0x36
+#define TPS65911_LDO3					0x37
+
+/*
  * List of register bitfields for component TPS65910
  *
  */
@@ -702,6 +725,23 @@
 #define JTAGVERNUM_VERNUM_SHIFT				0
 
 
+/* Register VDDCTRL (0x27) bit definitions */
+#define VDDCTRL_ST_MASK                                  0x03
+#define VDDCTRL_ST_SHIFT                                 0
+
+
+/*Register VDDCTRL_OP  (0x28) bit definitios */
+#define VDDCTRL_OP_CMD_MASK                              0x80
+#define VDDCTRL_OP_CMD_SHIFT                             7
+#define VDDCTRL_OP_SEL_MASK                              0x7F
+#define VDDCTRL_OP_SEL_SHIFT                             0
+
+
+/*Register VDDCTRL_SR  (0x29) bit definitions */
+#define VDDCTRL_SR_SEL_MASK                              0x7F
+#define VDDCTRL_SR_SEL_SHIFT                             0
+
+
 /* IRQ Definitions */
 #define TPS65910_IRQ_VBAT_VMBDCH			0
 #define TPS65910_IRQ_VBAT_VMHI				1
@@ -742,6 +782,7 @@ struct tps65910 {
 	struct device *dev;
 	struct i2c_client *i2c_client;
 	struct mutex io_mutex;
+	unsigned int id;
 	int (*read)(struct tps65910 *tps65910, u8 reg, int size, void *dest);
 	int (*write)(struct tps65910 *tps65910, u8 reg, int size, void *src);
 
@@ -771,4 +812,9 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
 int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		struct tps65910_platform_data *pdata);
 
+static inline int tps65910_chip_id(struct tps65910 *tps65910)
+{
+	return tps65910->id;
+}
+
 #endif /*  __LINUX_MFD_TPS65910_H */
-- 
1.7.1

