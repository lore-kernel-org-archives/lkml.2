Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2GKB2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:28:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55551 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab2GKB2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:28:06 -0400
Message-ID: <1341970074.11561.1.camel@phoenix>
Subject: [PATCH] mfd: Fix checking return value of regmap_read()
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 09:27:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of regmap_read() rather than the read value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/88pm800.c |   16 +++++++++-------
 drivers/mfd/88pm805.c |    5 +++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index ec7d9b8..b67a301 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -419,22 +419,24 @@ static int __devinit device_800_init(struct pm80x_chip *chip,
 				     struct pm80x_platform_data *pdata)
 {
 	int ret, pmic_id;
+	unsigned int val;
 
-	regmap_read(chip->regmap, PM800_CHIP_ID, &ret);
+	ret = regmap_read(chip->regmap, PM800_CHIP_ID, &val);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
 		goto out;
 	}
 
-	pmic_id = ret & PM80X_VERSION_MASK;
+	pmic_id = val & PM80X_VERSION_MASK;
 
 	if ((pmic_id >= PM800_CHIP_A0) && (pmic_id <= PM800_CHIP_END)) {
-		chip->version = ret;
+		chip->version = val;
 		dev_info(chip->dev,
-			 "88PM80x:Marvell 88PM800 (ID:0x%x) detected\n", ret);
+			 "88PM80x:Marvell 88PM800 (ID:0x%x) detected\n", val);
 	} else {
 		dev_err(chip->dev,
-			"Failed to detect Marvell 88PM800:ChipID[0x%x]\n", ret);
+			"Failed to detect Marvell 88PM800:ChipID[0x%x]\n", val);
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -442,12 +444,12 @@ static int __devinit device_800_init(struct pm80x_chip *chip,
 	 * alarm wake up bit will be clear in device_irq_init(),
 	 * read before that
 	 */
-	regmap_read(chip->regmap, PM800_RTC_CONTROL, &ret);
+	ret = regmap_read(chip->regmap, PM800_RTC_CONTROL, &val);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to read RTC register: %d\n", ret);
 		goto out;
 	}
-	if (ret & PM800_ALARM_WAKEUP) {
+	if (val & PM800_ALARM_WAKEUP) {
 		if (pdata && pdata->rtc)
 			pdata->rtc->rtc_wakeup = 1;
 	}
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index d59ca6b..6146583 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -192,6 +192,7 @@ static struct regmap_irq_chip pm805_irq_chip = {
 static int __devinit device_805_init(struct pm80x_chip *chip)
 {
 	int ret = 0;
+	unsigned int val;
 	struct regmap *map = chip->regmap;
 
 	if (!map) {
@@ -199,12 +200,12 @@ static int __devinit device_805_init(struct pm80x_chip *chip)
 		return -EINVAL;
 	}
 
-	regmap_read(map, PM805_CHIP_ID, &ret);
+	ret = regmap_read(map, PM805_CHIP_ID, &val);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
 		goto out_irq_init;
 	}
-	chip->version = ret;
+	chip->version = val;
 
 	chip->regmap_irq_chip = &pm805_irq_chip;
 
-- 
1.7.9.5



