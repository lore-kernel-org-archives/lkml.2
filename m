Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2LaLMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:12:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56409 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2LaLJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:36 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 01/10] mfd: twl-core: Clean up module id lookup and definitions
Date: Mon, 31 Dec 2012 12:09:22 +0100
Message-ID: <1356952171-6109-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use enums for all module definitions:
twl_module_ids for common functionality among twl4030/twl6030
twl4030_module_ids for twl4030 specific ids
twl6030_module_ids for twl6030 specific ids

In this way the list can be managed easier when new functionality going to
be implemented.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c  | 105 +++++++++++++++++++++++-------------------------
 include/linux/i2c/twl.h |  66 ++++++++++++++++--------------
 2 files changed, 86 insertions(+), 85 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 4f3baad..b781cdd 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -74,8 +74,6 @@
 #define SUB_CHIP_ID3 3
 #define SUB_CHIP_ID_INVAL 0xff
 
-#define TWL_MODULE_LAST TWL4030_MODULE_LAST
-
 /* Base Address defns for twl4030_map[] */
 
 /* subchip/slave 0 - USB ID */
@@ -94,10 +92,7 @@
 #define TWL4030_BASEADD_MADC		0x0000
 #define TWL4030_BASEADD_MAIN_CHARGE	0x0074
 #define TWL4030_BASEADD_PRECHARGE	0x00AA
-#define TWL4030_BASEADD_PWM0		0x00F8
-#define TWL4030_BASEADD_PWM1		0x00FB
-#define TWL4030_BASEADD_PWMA		0x00EF
-#define TWL4030_BASEADD_PWMB		0x00F1
+#define TWL4030_BASEADD_PWM		0x00F8
 #define TWL4030_BASEADD_KEYPAD		0x00D2
 
 #define TWL5031_BASEADD_ACCESSORY	0x0074 /* Replaces Main Charge */
@@ -117,7 +112,7 @@
 
 /* subchip/slave 0 0x48 - POWER */
 #define TWL6030_BASEADD_RTC		0x0000
-#define TWL6030_BASEADD_MEM		0x0017
+#define TWL6030_BASEADD_SECURED_REG	0x0017
 #define TWL6030_BASEADD_PM_MASTER	0x001F
 #define TWL6030_BASEADD_PM_SLAVE_MISC	0x0030 /* PM_RECEIVER */
 #define TWL6030_BASEADD_PM_MISC		0x00E2
@@ -132,6 +127,7 @@
 #define TWL6030_BASEADD_PIH		0x00D0
 #define TWL6030_BASEADD_CHARGER		0x00E0
 #define TWL6025_BASEADD_CHARGER		0x00DA
+#define TWL6030_BASEADD_LED		0x00F4
 
 /* subchip/slave 2 0x4A - DFT */
 #define TWL6030_BASEADD_DIEID		0x00C0
@@ -188,34 +184,33 @@ static struct twl_mapping twl4030_map[] = {
 	 * so they continue to match the order in this table.
 	 */
 
+	/* Common IPs */
 	{ 0, TWL4030_BASEADD_USB },
+	{ 1, TWL4030_BASEADD_PIH },
+	{ 2, TWL4030_BASEADD_MAIN_CHARGE },
+	{ 3, TWL4030_BASEADD_PM_MASTER },
+	{ 3, TWL4030_BASEADD_PM_RECEIVER },
+
+	{ 3, TWL4030_BASEADD_RTC },
+	{ 2, TWL4030_BASEADD_PWM },
+	{ 2, TWL4030_BASEADD_LED },
+	{ 3, TWL4030_BASEADD_SECURED_REG },
+
+	/* TWL4030 specific IPs */
 	{ 1, TWL4030_BASEADD_AUDIO_VOICE },
 	{ 1, TWL4030_BASEADD_GPIO },
 	{ 1, TWL4030_BASEADD_INTBR },
-	{ 1, TWL4030_BASEADD_PIH },
-
 	{ 1, TWL4030_BASEADD_TEST },
 	{ 2, TWL4030_BASEADD_KEYPAD },
+
 	{ 2, TWL4030_BASEADD_MADC },
 	{ 2, TWL4030_BASEADD_INTERRUPTS },
-	{ 2, TWL4030_BASEADD_LED },
-
-	{ 2, TWL4030_BASEADD_MAIN_CHARGE },
 	{ 2, TWL4030_BASEADD_PRECHARGE },
-	{ 2, TWL4030_BASEADD_PWM0 },
-	{ 2, TWL4030_BASEADD_PWM1 },
-	{ 2, TWL4030_BASEADD_PWMA },
-
-	{ 2, TWL4030_BASEADD_PWMB },
-	{ 2, TWL5031_BASEADD_ACCESSORY },
-	{ 2, TWL5031_BASEADD_INTERRUPTS },
 	{ 3, TWL4030_BASEADD_BACKUP },
 	{ 3, TWL4030_BASEADD_INT },
 
-	{ 3, TWL4030_BASEADD_PM_MASTER },
-	{ 3, TWL4030_BASEADD_PM_RECEIVER },
-	{ 3, TWL4030_BASEADD_RTC },
-	{ 3, TWL4030_BASEADD_SECURED_REG },
+	{ 2, TWL5031_BASEADD_ACCESSORY },
+	{ 2, TWL5031_BASEADD_INTERRUPTS },
 };
 
 static struct regmap_config twl4030_regmap_config[4] = {
@@ -251,35 +246,25 @@ static struct twl_mapping twl6030_map[] = {
 	 * <linux/i2c/twl.h> defines for TWL4030_MODULE_*
 	 * so they continue to match the order in this table.
 	 */
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_USB },
-	{ SUB_CHIP_ID_INVAL, TWL6030_BASEADD_AUDIO },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_DIEID },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_PIH },
-
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_GPADC_CTRL },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_CHARGER },
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_GASGAUGE },
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_PWM },
-	{ SUB_CHIP_ID0, TWL6030_BASEADD_ZERO },
-	{ SUB_CHIP_ID1, TWL6030_BASEADD_ZERO },
-
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_ZERO },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_ZERO },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-
-	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_MASTER },
-	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_SLAVE_MISC },
-	{ SUB_CHIP_ID0, TWL6030_BASEADD_RTC },
-	{ SUB_CHIP_ID0, TWL6030_BASEADD_MEM },
-	{ SUB_CHIP_ID1, TWL6025_BASEADD_CHARGER },
+
+	/* Common IPs */
+	{ 1, TWL6030_BASEADD_USB },
+	{ 1, TWL6030_BASEADD_PIH },
+	{ 1, TWL6030_BASEADD_CHARGER },
+	{ 0, TWL6030_BASEADD_PM_MASTER },
+	{ 0, TWL6030_BASEADD_PM_SLAVE_MISC },
+
+	{ 0, TWL6030_BASEADD_RTC },
+	{ 1, TWL6030_BASEADD_PWM },
+	{ 1, TWL6030_BASEADD_LED },
+	{ 0, TWL6030_BASEADD_SECURED_REG },
+
+	/* TWL6030 specific IPs */
+	{ 0, TWL6030_BASEADD_ZERO },
+	{ 1, TWL6030_BASEADD_ZERO },
+	{ 2, TWL6030_BASEADD_ZERO },
+	{ 1, TWL6030_BASEADD_GPADC_CTRL },
+	{ 1, TWL6030_BASEADD_GASGAUGE },
 };
 
 static struct regmap_config twl6030_regmap_config[3] = {
@@ -305,6 +290,14 @@ static struct regmap_config twl6030_regmap_config[3] = {
 
 /*----------------------------------------------------------------------*/
 
+static inline int twl_get_last_module(void)
+{
+	if (twl_class_is_4030())
+		return TWL4030_MODULE_LAST;
+	else
+		return TWL6030_MODULE_LAST;
+}
+
 /* Exported Functions */
 
 /**
@@ -325,7 +318,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	int sid;
 	struct twl_client *twl;
 
-	if (unlikely(mod_no >= TWL_MODULE_LAST)) {
+	if (unlikely(mod_no >= twl_get_last_module())) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
@@ -367,7 +360,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	int sid;
 	struct twl_client *twl;
 
-	if (unlikely(mod_no >= TWL_MODULE_LAST)) {
+	if (unlikely(mod_no >= twl_get_last_module())) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
@@ -1228,6 +1221,10 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if ((id->driver_data) & TWL6030_CLASS) {
 		twl_id = TWL6030_CLASS_ID;
 		twl_map = &twl6030_map[0];
+		/* The charger base address is different in twl6025 */
+		if ((id->driver_data) & TWL6025_SUBCLASS)
+			twl_map[TWL_MODULE_MAIN_CHARGE].base =
+							TWL6025_BASEADD_CHARGER;
 		twl_regmap_config = twl6030_regmap_config;
 		num_slaves = TWL_NUM_SLAVES - 1;
 	} else {
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 1ff54b1..72adc88 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -39,51 +39,55 @@
  * address each module uses within a given i2c slave.
  */
 
+/* Module IDs for similar functionalities found in twl4030/twl6030 */
+enum twl_module_ids {
+	TWL_MODULE_USB,
+	TWL_MODULE_PIH,
+	TWL_MODULE_MAIN_CHARGE,
+	TWL_MODULE_PM_MASTER,
+	TWL_MODULE_PM_RECEIVER,
+
+	TWL_MODULE_RTC,
+	TWL_MODULE_PWM,
+	TWL_MODULE_LED,
+	TWL_MODULE_SECURED_REG,
+
+	TWL_MODULE_LAST,
+};
+
+/* Modules only available in twl4030 series */
 enum twl4030_module_ids {
-	TWL4030_MODULE_USB = 0,		/* Slave 0 (i2c address 0x48) */
-	TWL4030_MODULE_AUDIO_VOICE,	/* Slave 1 (i2c address 0x49) */
+	TWL4030_MODULE_AUDIO_VOICE = TWL_MODULE_LAST,
 	TWL4030_MODULE_GPIO,
 	TWL4030_MODULE_INTBR,
-	TWL4030_MODULE_PIH,
-
 	TWL4030_MODULE_TEST,
-	TWL4030_MODULE_KEYPAD,		/* Slave 2 (i2c address 0x4a) */
+	TWL4030_MODULE_KEYPAD,
+
 	TWL4030_MODULE_MADC,
 	TWL4030_MODULE_INTERRUPTS,
-	TWL4030_MODULE_LED,
-
-	TWL4030_MODULE_MAIN_CHARGE,
 	TWL4030_MODULE_PRECHARGE,
-	TWL4030_MODULE_PWM0,
-	TWL4030_MODULE_PWM1,
-	TWL4030_MODULE_PWMA,
+	TWL4030_MODULE_BACKUP,
+	TWL4030_MODULE_INT,
 
-	TWL4030_MODULE_PWMB,
 	TWL5031_MODULE_ACCESSORY,
 	TWL5031_MODULE_INTERRUPTS,
-	TWL4030_MODULE_BACKUP,		/* Slave 3 (i2c address 0x4b) */
-	TWL4030_MODULE_INT,
 
-	TWL4030_MODULE_PM_MASTER,
-	TWL4030_MODULE_PM_RECEIVER,
-	TWL4030_MODULE_RTC,
-	TWL4030_MODULE_SECURED_REG,
 	TWL4030_MODULE_LAST,
 };
 
-/* Similar functionalities implemented in TWL4030/6030 */
-#define TWL_MODULE_USB		TWL4030_MODULE_USB
-#define TWL_MODULE_PIH		TWL4030_MODULE_PIH
-#define TWL_MODULE_MAIN_CHARGE	TWL4030_MODULE_MAIN_CHARGE
-#define TWL_MODULE_PM_MASTER	TWL4030_MODULE_PM_MASTER
-#define TWL_MODULE_PM_RECEIVER	TWL4030_MODULE_PM_RECEIVER
-#define TWL_MODULE_RTC		TWL4030_MODULE_RTC
-#define TWL_MODULE_PWM		TWL4030_MODULE_PWM0
-#define TWL_MODULE_LED		TWL4030_MODULE_LED
-
-#define TWL6030_MODULE_ID0	13
-#define TWL6030_MODULE_ID1	14
-#define TWL6030_MODULE_ID2	15
+/* Modules only available in twl6030 series */
+enum twl6030_module_ids {
+	TWL6030_MODULE_ID0 = TWL_MODULE_LAST,
+	TWL6030_MODULE_ID1,
+	TWL6030_MODULE_ID2,
+	TWL6030_MODULE_GPADC,
+	TWL6030_MODULE_GASGAUGE,
+
+	TWL6030_MODULE_LAST,
+};
+
+/* Until the clients has been converted to use TWL_MODULE_LED */
+#define TWL4030_MODULE_LED	TWL_MODULE_LED
 
 #define GPIO_INTR_OFFSET	0
 #define KEYPAD_INTR_OFFSET	1
-- 
1.8.0.2

