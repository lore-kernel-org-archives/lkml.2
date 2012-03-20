Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2CUFjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:39:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:43818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab2CUFjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="123253187"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: Clean up interrupt handling
Date: Wed, 21 Mar 2012 03:03:16 +0530
Message-Id: <1332279196-17991-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max17042 driver has dummy hardIRQ function which
does nothing but waking the threaded handler.

This patch removes the hardIRQ function and also
modifies the interrupt type to falling edge. While
we are there, change the macros to comply with the
Data sheet.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index e36763a..abf3400 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -47,8 +47,8 @@
 
 /* Interrupt mask bits */
 #define CONFIG_ALRT_BIT_ENBL	(1 << 2)
-#define STATUS_INTR_SOC_BIT	(1 << 14)
-#define STATUS_INTR_LOW_SOC_BIT	(1 << 10)
+#define STATUS_INTR_SOCMIN_BIT	(1 << 10)
+#define STATUS_INTR_SOCMAX_BIT	(1 << 14)
 
 #define VFSOC0_LOCK		0x0000
 #define VFSOC0_UNLOCK		0x0080
@@ -572,19 +572,14 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
 	max17042_write_reg(chip->client, MAX17042_SALRT_Th, soc_tr);
 }
 
-static irqreturn_t max17042_intr_handler(int id, void *dev)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 static irqreturn_t max17042_thread_handler(int id, void *dev)
 {
 	struct max17042_chip *chip = dev;
 	u16 val;
 
 	val = max17042_read_reg(chip->client, MAX17042_STATUS);
-	if ((val & STATUS_INTR_SOC_BIT) ||
-		(val & STATUS_INTR_LOW_SOC_BIT)) {
+	if ((val & STATUS_INTR_SOCMIN_BIT) ||
+		(val & STATUS_INTR_SOCMAX_BIT)) {
 		dev_info(&chip->client->dev, "SOC threshold INTR\n");
 		max17042_set_soc_threshold(chip, 1);
 	}
@@ -692,9 +687,10 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	}
 
 	if (client->irq) {
-		ret = request_threaded_irq(client->irq, max17042_intr_handler,
+		ret = request_threaded_irq(client->irq, NULL,
 						max17042_thread_handler,
-						0, chip->battery.name, chip);
+						IRQF_TRIGGER_FALLING,
+						chip->battery.name, chip);
 		if (!ret) {
 			reg =  max17042_read_reg(client, MAX17042_CONFIG);
 			reg |= CONFIG_ALRT_BIT_ENBL;
-- 
1.7.0.4

