Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2FMI2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:28:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40118 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2FMI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:49 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-08-4fd84f40912e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim01@gmail.com
Subject: [PATCH 5/5] regulator: Support AP watchdog reset operation for s5m8767a
Date: Wed, 13 Jun 2012 17:28:47 +0900
Message-id: <042301cd493e$8d95d7e0$a8c187a0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JPo1uIP2e6nyTSZ6oGo6nBAZ24w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAV0H/xv+BmuPcllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M+Qu/sxZcsqk4c34dawPjKYMuRk4OCQETiYXv/rBA2GISF+6t
	Z+ti5OIQEljEKPHkWRczhDOXSeLUxJlgVWwCGhIrd79lA7FFBMIkZs5aCRZnFvCSuNHcxghi
	CwsESOy7v5QVxGYRUJX4vn8tWD2vgKHE1PZZLBC2oMSPyfegerUk1u88zgRhy0tsXvMWaDEH
	0EXqEo/+6kKs0pPYsa6FHaJERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnBgPpPewbiqweIQowAHoxIPb5DbDX8h1sSy4srcQ4wSHMxKIrzF
	W6/7C/GmJFZWpRblxxeV5qQWH2KU5mBREudtsr7gLySQnliSmp2aWpBaBJNl4uCUamBk1Ty5
	J7Voda9flPe0GI7DBZatR04t+B23dq58K2urwx2rD7mxTMkT+JbtOvR8oXzzaTklYS6tjzOe
	Tj0sIXt1otQcec1JfJGh9v4zBJTu1GxrTN7AHsQRXG7v77fPaN5umX/aJ68YqHaIKPu8dXqw
	f6e+lqCGqHxWV9Pdn1e+8p29V9STEK7EUpyRaKjFXFScCABMLJwGSAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After AP watchdog reset, S5M8767A should be reset too.
If AP is set on lowest voltage, AP can't execute boot sequence.
This patch support watchdog reset of s5m8767.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c          |  137 +++++++++++++++++++++++-----------
 include/linux/mfd/s5m87xx/s5m-core.h |    5 +
 2 files changed, 98 insertions(+), 44 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 770e4df..533bde6 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -41,6 +41,7 @@ struct s5m8767_info {
 	u8 buck3_vol[8];
 	u8 buck4_vol[8];
 	int buck_gpios[3];
+	int buck_ds[3];
 	int buck_gpioindex;
 };
 
@@ -283,17 +284,17 @@ static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 		reg = S5M8767_REG_BUCK1CTRL2;
 		break;
 	case S5M8767_BUCK2:
-		reg = S5M8767_REG_BUCK2DVS1;
+		reg = S5M8767_REG_BUCK2DVS2;
 		if (s5m8767->buck2_gpiodvs)
 			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK3:
-		reg = S5M8767_REG_BUCK3DVS1;
+		reg = S5M8767_REG_BUCK3DVS2;
 		if (s5m8767->buck3_gpiodvs)
 			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK4:
-		reg = S5M8767_REG_BUCK4DVS1;
+		reg = S5M8767_REG_BUCK4DVS2;
 		if (s5m8767->buck4_gpiodvs)
 			reg += s5m8767->buck_gpioindex;
 		break;
@@ -512,7 +513,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
-	int i, ret, size;
+	int i, ret, size, buck_init;
 
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "Platform data not supplied\n");
@@ -563,12 +564,37 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	s5m8767->buck_gpios[0] = pdata->buck_gpios[0];
 	s5m8767->buck_gpios[1] = pdata->buck_gpios[1];
 	s5m8767->buck_gpios[2] = pdata->buck_gpios[2];
+	s5m8767->buck_ds[0] = pdata->buck_ds[0];
+	s5m8767->buck_ds[1] = pdata->buck_ds[1];
+	s5m8767->buck_ds[2] = pdata->buck_ds[2];
+
 	s5m8767->ramp_delay = pdata->buck_ramp_delay;
 	s5m8767->buck2_ramp = pdata->buck2_ramp_enable;
 	s5m8767->buck3_ramp = pdata->buck3_ramp_enable;
 	s5m8767->buck4_ramp = pdata->buck4_ramp_enable;
 	s5m8767->opmode = pdata->opmode;
 
+	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
+						pdata->buck2_init,
+						pdata->buck2_init +
+						buck_voltage_val2.step);
+
+	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
+
+	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
+						pdata->buck3_init,
+						pdata->buck3_init +
+						buck_voltage_val2.step);
+
+	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
+
+	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
+						pdata->buck4_init,
+						pdata->buck4_init +
+						buck_voltage_val2.step);
+
+	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
+
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
 			s5m8767->buck2_vol[i] =
@@ -598,48 +624,71 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
-		pdata->buck4_gpiodvs) {
-		if (gpio_is_valid(pdata->buck_gpios[0]) &&
-			gpio_is_valid(pdata->buck_gpios[1]) &&
-			gpio_is_valid(pdata->buck_gpios[2])) {
-			ret = gpio_request(pdata->buck_gpios[0],
-						"S5M8767 SET1");
-			if (ret == -EBUSY)
-				dev_warn(&pdev->dev, "Duplicated gpio request for SET1\n");
-
-			ret = gpio_request(pdata->buck_gpios[1],
-					   "S5M8767 SET2");
-			if (ret == -EBUSY)
-				dev_warn(&pdev->dev, "Duplicated gpio request for SET2\n");
-
-			ret = gpio_request(pdata->buck_gpios[2],
-					   "S5M8767 SET3");
-			if (ret == -EBUSY)
-				dev_warn(&pdev->dev, "Duplicated gpio request for SET3\n");
-			/* SET1 GPIO */
-			gpio_direction_output(pdata->buck_gpios[0],
-					(s5m8767->buck_gpioindex >> 2) & 0x1);
-			/* SET2 GPIO */
-			gpio_direction_output(pdata->buck_gpios[1],
-					(s5m8767->buck_gpioindex >> 1) & 0x1);
-			/* SET3 GPIO */
-			gpio_direction_output(pdata->buck_gpios[2],
-					(s5m8767->buck_gpioindex >> 0) & 0x1);
-			ret = 0;
-		} else {
-			dev_err(&pdev->dev, "GPIO NOT VALID\n");
-			ret = -EINVAL;
-			return ret;
-		}
+	if (gpio_is_valid(pdata->buck_gpios[0]) &&
+		gpio_is_valid(pdata->buck_gpios[1]) &&
+		gpio_is_valid(pdata->buck_gpios[2])) {
+		ret = gpio_request(pdata->buck_gpios[0], "S5M8767 SET1");
+		if (ret == -EBUSY)
+			dev_warn(&pdev->dev, "Duplicated gpio request"
+				" for SET1\n");
+
+		ret = gpio_request(pdata->buck_gpios[1], "S5M8767 SET2");
+		if (ret == -EBUSY)
+			dev_warn(&pdev->dev, "Duplicated gpio request"
+				" for SET2\n");
+
+		ret = gpio_request(pdata->buck_gpios[2], "S5M8767 SET3");
+		if (ret == -EBUSY)
+			dev_warn(&pdev->dev, "Duplicated gpio request"
+					" for SET3\n");
+		/* SET1 GPIO */
+		gpio_direction_output(pdata->buck_gpios[0],
+				(s5m8767->buck_gpioindex >> 2) & 0x1);
+		/* SET2 GPIO */
+		gpio_direction_output(pdata->buck_gpios[1],
+				(s5m8767->buck_gpioindex >> 1) & 0x1);
+		/* SET3 GPIO */
+		gpio_direction_output(pdata->buck_gpios[2],
+				(s5m8767->buck_gpioindex >> 0) & 0x1);
+		ret = 0;
+
+	} else {
+		dev_err(&pdev->dev, "GPIO NOT VALID\n");
+		ret = -EINVAL;
+		return ret;
 	}
 
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
-			(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
-			(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
-			(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
+	ret = gpio_request(pdata->buck_ds[0], "S5M8767 DS2");
+	if (ret == -EBUSY)
+		dev_warn(&pdev->dev, "Duplicated gpio request for DS2\n");
+
+	ret = gpio_request(pdata->buck_ds[1], "S5M8767 DS3");
+	if (ret == -EBUSY)
+		dev_warn(&pdev->dev, "Duplicated gpio request for DS3\n");
+
+	ret = gpio_request(pdata->buck_ds[2], "S5M8767 DS4");
+	if (ret == -EBUSY)
+		dev_warn(&pdev->dev, "Duplicated gpio request for DS4\n");
+
+	/* DS2 GPIO */
+	gpio_direction_output(pdata->buck_ds[0], 0x0);
+	/* DS3 GPIO */
+	gpio_direction_output(pdata->buck_ds[1], 0x0);
+	/* DS4 GPIO */
+	gpio_direction_output(pdata->buck_ds[2], 0x0);
+
+	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
+	   pdata->buck4_gpiodvs) {
+		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
+				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1),
+				1 << 1);
+		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
+				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1),
+				1 << 1);
+		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
+				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1),
+				1 << 1);
+	}
 
 	/* Initialize GPIO DVS registers */
 	for (i = 0; i < 8; i++) {
diff --git a/include/linux/mfd/s5m87xx/s5m-core.h b/include/linux/mfd/s5m87xx/s5m-core.h
index 21603b4..0b2e0ed 100644
--- a/include/linux/mfd/s5m87xx/s5m-core.h
+++ b/include/linux/mfd/s5m87xx/s5m-core.h
@@ -347,6 +347,7 @@ struct s5m_platform_data {
 	bool				buck_voltage_lock;
 
 	int				buck_gpios[3];
+	int				buck_ds[3];
 	int				buck2_voltage[8];
 	bool				buck2_gpiodvs;
 	int				buck3_voltage[8];
@@ -369,6 +370,10 @@ struct s5m_platform_data {
 	bool                            buck2_ramp_enable;
 	bool                            buck3_ramp_enable;
 	bool                            buck4_ramp_enable;
+
+	int				buck2_init;
+	int				buck3_init;
+	int				buck4_init;
 };
 
 #endif /*  __LINUX_MFD_S5M_CORE_H */
-- 
1.7.1


