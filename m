Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2FMI22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:28:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39822 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2FMI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:20 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-fb-4fd84f221744
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: [PATCH 4/5] regulator: Replace set_voltage with set_voltage_sel
Date: Wed, 13 Jun 2012 17:28:18 +0900
Message-id: <042201cd493e$7c459f70$74d0de50$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JPnwWE0pOKXAuR/+6h6AjxYsGcw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAV0l/xv+Bru2W1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ML9dushXskaq4eHkjWwPjedEuRg4OCQETiQWf3LoYOYFMMYkL
	99azdTFycQgJLGKUWH5rIpQzl0ni7P/pTCBVbAIaEit3v2UDsUUEwiRmzlrJAmIzCxhLnFj4
	nh3EFhbwkHh/9A8riM0ioCqx5dE6ZhCbV8BQ4vr3bWwQtqDEj8n3oHq1JNbvPM4EYctLbF7z
	lhniOHWJR391IVbpScxtXM0KUSIise/FO8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOCyfSe1gXNlgcYhRgINRiYe3wOqGvxBrYllxZe4hRgkOZiUR
	3uKt1/2FeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZZX/AXEkhPLEnNTk0tSC2CyTJxcEo1MApw
	9633lBV5v/ZW6eqHPfPVZp3WO3Pz/Z/HHiuY7qhNSp5sfWN+tOtMnZk8h6aJCE2seWBbtuWE
	4/VFm83Kjk1ZZt+gdDd+itScsD/asmbsmhH79zpU90sacJ1UyPlRbiu+JnxCQY7QnQdxTD1V
	1WGpKvzpyz0tCvTcZ+k1vjzRcH9bnUOKkBJLcUaioRZzUXEiAJ1t0CZHAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To apply delay time for voltage change,
replace s5m8767_set_voltage with s5m8767_set_voltage_sel.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 924968a..770e4df 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -357,32 +357,34 @@ static int s5m8767_convert_voltage_to_sel(
 	return selector;
 }
 
-static inline void s5m8767_set_high(struct s5m8767_info *s5m8767)
+static inline int s5m8767_set_high(struct s5m8767_info *s5m8767)
 {
 	int temp_index = s5m8767->buck_gpioindex;
 
 	gpio_set_value(s5m8767->buck_gpios[0], (temp_index >> 2) & 0x1);
 	gpio_set_value(s5m8767->buck_gpios[1], (temp_index >> 1) & 0x1);
 	gpio_set_value(s5m8767->buck_gpios[2], temp_index & 0x1);
+
+	return 0;
 }
 
-static inline void s5m8767_set_low(struct s5m8767_info *s5m8767)
+static inline int s5m8767_set_low(struct s5m8767_info *s5m8767)
 {
 	int temp_index = s5m8767->buck_gpioindex;
 
 	gpio_set_value(s5m8767->buck_gpios[2], temp_index & 0x1);
 	gpio_set_value(s5m8767->buck_gpios[1], (temp_index >> 1) & 0x1);
 	gpio_set_value(s5m8767->buck_gpios[0], (temp_index >> 2) & 0x1);
+
+	return 0;
 }
 
-static int s5m8767_set_voltage(struct regulator_dev *rdev,
-				int min_uV, int max_uV, unsigned *selector)
+static int s5m8767_set_voltage_sel(struct regulator_dev *rdev,
+				   unsigned selector)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	const struct s5m_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
-	int sel, reg, mask, ret = 0, old_index, index = 0;
-	u8 val;
+	int reg, mask, ret = 0, old_index, index = 0;
 	u8 *buck234_vol = NULL;
 
 	switch (reg_id) {
@@ -407,15 +409,9 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	desc = reg_voltage_map[reg_id];
-
-	sel = s5m8767_convert_voltage_to_sel(desc, min_uV, max_uV);
-	if (sel < 0)
-		return sel;
-
 	/* buck234_vol != NULL means to control buck234 voltage via DVS GPIO */
 	if (buck234_vol) {
-		while (*buck234_vol != sel) {
+		while (*buck234_vol != selector) {
 			buck234_vol++;
 			index++;
 		}
@@ -423,22 +419,16 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 		s5m8767->buck_gpioindex = index;
 
 		if (index > old_index)
-			s5m8767_set_high(s5m8767);
+			return s5m8767_set_high(s5m8767);
 		else
-			s5m8767_set_low(s5m8767);
+			return s5m8767_set_low(s5m8767);
 	} else {
 		ret = s5m8767_get_voltage_register(rdev, &reg);
 		if (ret)
 			return ret;
 
-		s5m_reg_read(s5m8767->iodev, reg, &val);
-		val = (val & ~mask) | sel;
-
-		ret = s5m_reg_write(s5m8767->iodev, reg, val);
+		return s5m_reg_update(s5m8767->iodev, reg, selector, mask);
 	}
-
-	*selector = sel;
-	return ret;
 }
 
 static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
@@ -463,7 +453,7 @@ static struct regulator_ops s5m8767_ops = {
 	.enable			= s5m8767_reg_enable,
 	.disable		= s5m8767_reg_disable,
 	.get_voltage_sel	= s5m8767_get_voltage_sel,
-	.set_voltage		= s5m8767_set_voltage,
+	.set_voltage_sel	= s5m8767_set_voltage_sel,
 	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
 };
 
-- 
1.7.1


