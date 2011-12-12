Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1LLSmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:42:14 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37406 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1LLSmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:42:06 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v3 3/5] max17042: Add support for signalling change in SOC
Date: Mon, 12 Dec 2011 10:39:31 -0800
Message-Id: <1323715173-26974-4-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
References: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

If platform has the alert pin attached to an interrupt source have the
driver signal a change in the SOC every 1 percent.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/power/max17042_battery.c |   54 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index f2ca950..ac17d36 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
@@ -43,6 +44,11 @@
 #define STATUS_SMX_BIT         (1 << 14)
 #define STATUS_BR_BIT          (1 << 15)
 
+/* Interrupt mask bits */
+#define CONFIG_ALRT_BIT_ENBL	(1 << 2)
+#define STATUS_INTR_SOC_BIT	(1 << 14)
+#define STATUS_INTR_LOW_SOC_BIT	(1 << 10)
+
 #define VFSOC0_LOCK		0x0000
 #define VFSOC0_UNLOCK		0x0080
 #define MODEL_UNLOCK1	0X0059
@@ -522,6 +528,40 @@ static int max17042_init_chip(struct max17042_chip *chip)
 	return 0;
 }
 
+static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
+{
+	u16 soc, soc_tr;
+
+	/* program interrupt thesholds such that we should
+	 * get interrupt for every 'off' perc change in the soc
+	 */
+	soc = max17042_read_reg(chip->client, MAX17042_RepSOC) >> 8;
+	soc_tr = (soc + off) << 8;
+	soc_tr |= (soc - off);
+	max17042_write_reg(chip->client, MAX17042_SALRT_Th, soc_tr);
+}
+
+static irqreturn_t max17042_intr_handler(int id, void *dev)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t max17042_thread_handler(int id, void *dev)
+{
+	struct max17042_chip *chip = dev;
+	u16 val;
+
+	val = max17042_read_reg(chip->client, MAX17042_STATUS);
+	if ((val & STATUS_INTR_SOC_BIT) ||
+		(val & STATUS_INTR_LOW_SOC_BIT)) {
+		printk(KERN_ERR "SOC threshold INTR\n");
+		dev_info(&chip->client->dev, "SOC threshold INTR\n");
+		max17042_set_soc_threshold(chip, 1);
+	}
+
+	power_supply_changed(&chip->battery);
+	return IRQ_HANDLED;
+}
 
 static void max17042_init_worker(struct work_struct *work)
 {
@@ -584,6 +624,20 @@ static int __devinit max17042_probe(struct i2c_client *client,
 				MAX17042_DEFAULT_SNS_RESISTOR;
 	}
 
+	if (client->irq) {
+		ret = request_threaded_irq(client->irq, max17042_intr_handler,
+						max17042_thread_handler,
+						0, chip->battery.name, chip);
+		if (!ret) {
+			reg =  max17042_read_reg(client, MAX17042_CONFIG);
+			reg |= CONFIG_ALRT_BIT_ENBL;
+			max17042_write_reg(client, MAX17042_CONFIG, reg);
+			max17042_set_soc_threshold(chip, 1);
+		} else
+			dev_err(&client->dev, "%s(): cannot get IRQ\n",
+				__func__);
+	}
+
 	reg = max17042_read_reg(chip->client, MAX17042_STATUS);
 
 	if (reg & STATUS_POR_BIT) {
-- 
1.7.7.3

