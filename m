Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2GKMH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:07:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34063 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2GKMHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:07:55 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-2d-4ffd6c9aa852
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH V3 4/7] mfd: s2mps11: Add samsung s2mps11 mfd support
Date: Wed, 11 Jul 2012 21:07:55 +0900
Message-id: <012c01cd5f5d$cde449a0$69acdce0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fXc3Kt0zl3pZbT8ulXEf5o6RKCw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd1ZOX/9DU5PlLW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm2YsYC04YVbxtv0lawPjH50uRk4OCQETicvtX5ggbDGJC/fW
	s3UxcnEICSxilHi29ysrhDOXSWL2/h+sIFVsAhoSK3e/ZQOxRQR8JX5P2wzUzcHBLBAssfW0
	HkhYWMBV4vvreSwgNouAqsTaV01gNq+AocTfM0+hbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nL
	DDJSQkBd4tFfXYhNehJv/yyDKhGR2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRHJbPpHYwrmywOMQowMGoxMNbFfzXX4g1say4MvcQowQHs5II
	b40PUIg3JbGyKrUoP76oNCe1+BCjNAeLkjivsfdXfyGB9MSS1OzU1ILUIpgsEwenVAOjybPJ
	PwyDWW6sjbovqj1dbP/KhZ+Tk7dd85mxbJdFqNrqxapeSRZdzFfnbDpikLniyYZg/k0qSvr2
	/zNCgud6OtR3d31YMeXHYmF1l2WntqbLru56axemn+J+a15fymXZrdVC82rX11icCbw1OfS3
	ueHmlUuCJGwiOoLDvxzpDGXfdn699n1vJZbijERDLeai4kQABbKkt0cCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S2MPS11 mfd driver.
The S2MPS11 can support regulators and RTC.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/sec-core.c              |   10 ++
 include/linux/mfd/samsung/core.h    |   10 ++
 include/linux/mfd/samsung/s2mps11.h |  196 +++++++++++++++++++++++++++++++++++
 3 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps11.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 3a9a467..2988efd 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -54,6 +54,12 @@ static struct mfd_cell s5m8767_devs[] = {
 	},
 };
 
+static struct mfd_cell s2mps11_devs[] = {
+	{
+		.name = "s2mps11-pmic",
+	},
+};
+
 int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 {
 	return regmap_read(sec_pmic->regmap, reg, dest);
@@ -145,6 +151,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
 					ARRAY_SIZE(s5m8767_devs), NULL, 0);
 		break;
+	case S2MPS11X:
+		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
+					ARRAY_SIZE(s2mps11_devs), NULL, 0);
+		break;
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 97cf642..b0f6beb 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -20,6 +20,7 @@ enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
 	S5M8767X,
+	S2MPS11X,
 };
 
 /**
@@ -98,9 +99,18 @@ struct sec_platform_data {
 	int				buck4_default_idx;
 
 	int                             buck_ramp_delay;
+
+	int				buck2_ramp_delay;
+	int				buck34_ramp_delay;
+	int				buck5_ramp_delay;
+	int				buck16_ramp_delay;
+	int				buck7810_ramp_delay;
+	int				buck9_ramp_delay;
+
 	bool                            buck2_ramp_enable;
 	bool                            buck3_ramp_enable;
 	bool                            buck4_ramp_enable;
+	bool				buck6_ramp_enable;
 
 	int				buck2_init;
 	int				buck3_init;
diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
new file mode 100644
index 0000000..b900a60
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mps11.h
@@ -0,0 +1,196 @@
+/*
+ * s2mps11.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPS11_H
+#define __LINUX_MFD_S2MPS11_H
+
+/* S2MPS11 registers */
+enum s2mps11_reg {
+	S2MPS11_REG_ID,
+	S2MPS11_REG_INT1,
+	S2MPS11_REG_INT2,
+	S2MPS11_REG_INT3,
+	S2MPS11_REG_INT1M,
+	S2MPS11_REG_INT2M,
+	S2MPS11_REG_INT3M,
+	S2MPS11_REG_ST1,
+	S2MPS11_REG_ST2,
+	S2MPS11_REG_OFFSRC,
+	S2MPS11_REG_PWRONSRC,
+	S2MPS11_REG_RTC_CTRL,
+	S2MPS11_REG_CTRL1,
+	S2MPS11_REG_ETC_TEST,
+	S2MPS11_REG_RSVD3,
+	S2MPS11_REG_BU_CHG,
+	S2MPS11_REG_RAMP,
+	S2MPS11_REG_RAMP_BUCK,
+	S2MPS11_REG_LDO1_8,
+	S2MPS11_REG_LDO9_16,
+	S2MPS11_REG_LDO17_24,
+	S2MPS11_REG_LDO25_32,
+	S2MPS11_REG_LDO33_38,
+	S2MPS11_REG_LDO1_8_1,
+	S2MPS11_REG_LDO9_16_1,
+	S2MPS11_REG_LDO17_24_1,
+	S2MPS11_REG_LDO25_32_1,
+	S2MPS11_REG_LDO33_38_1,
+	S2MPS11_REG_OTP_ADRL,
+	S2MPS11_REG_OTP_ADRH,
+	S2MPS11_REG_OTP_DATA,
+	S2MPS11_REG_MON1SEL,
+	S2MPS11_REG_MON2SEL,
+	S2MPS11_REG_LEE,
+	S2MPS11_REG_RSVD_NO,
+	S2MPS11_REG_UVLO,
+	S2MPS11_REG_LEE_NO,
+	S2MPS11_REG_B1CTRL1,
+	S2MPS11_REG_B1CTRL2,
+	S2MPS11_REG_B2CTRL1,
+	S2MPS11_REG_B2CTRL2,
+	S2MPS11_REG_B3CTRL1,
+	S2MPS11_REG_B3CTRL2,
+	S2MPS11_REG_B4CTRL1,
+	S2MPS11_REG_B4CTRL2,
+	S2MPS11_REG_B5CTRL1,
+	S2MPS11_REG_BUCK5_SW,
+	S2MPS11_REG_B5CTRL2,
+	S2MPS11_REG_B5CTRL3,
+	S2MPS11_REG_B5CTRL4,
+	S2MPS11_REG_B5CTRL5,
+	S2MPS11_REG_B6CTRL1,
+	S2MPS11_REG_B6CTRL2,
+	S2MPS11_REG_B7CTRL1,
+	S2MPS11_REG_B7CTRL2,
+	S2MPS11_REG_B8CTRL1,
+	S2MPS11_REG_B8CTRL2,
+	S2MPS11_REG_B9CTRL1,
+	S2MPS11_REG_B9CTRL2,
+	S2MPS11_REG_B10CTRL1,
+	S2MPS11_REG_B10CTRL2,
+	S2MPS11_REG_L1CTRL,
+	S2MPS11_REG_L2CTRL,
+	S2MPS11_REG_L3CTRL,
+	S2MPS11_REG_L4CTRL,
+	S2MPS11_REG_L5CTRL,
+	S2MPS11_REG_L6CTRL,
+	S2MPS11_REG_L7CTRL,
+	S2MPS11_REG_L8CTRL,
+	S2MPS11_REG_L9CTRL,
+	S2MPS11_REG_L10CTRL,
+	S2MPS11_REG_L11CTRL,
+	S2MPS11_REG_L12CTRL,
+	S2MPS11_REG_L13CTRL,
+	S2MPS11_REG_L14CTRL,
+	S2MPS11_REG_L15CTRL,
+	S2MPS11_REG_L16CTRL,
+	S2MPS11_REG_L17CTRL,
+	S2MPS11_REG_L18CTRL,
+	S2MPS11_REG_L19CTRL,
+	S2MPS11_REG_L20CTRL,
+	S2MPS11_REG_L21CTRL,
+	S2MPS11_REG_L22CTRL,
+	S2MPS11_REG_L23CTRL,
+	S2MPS11_REG_L24CTRL,
+	S2MPS11_REG_L25CTRL,
+	S2MPS11_REG_L26CTRL,
+	S2MPS11_REG_L27CTRL,
+	S2MPS11_REG_L28CTRL,
+	S2MPS11_REG_L29CTRL,
+	S2MPS11_REG_L30CTRL,
+	S2MPS11_REG_L31CTRL,
+	S2MPS11_REG_L32CTRL,
+	S2MPS11_REG_L33CTRL,
+	S2MPS11_REG_L34CTRL,
+	S2MPS11_REG_L35CTRL,
+	S2MPS11_REG_L36CTRL,
+	S2MPS11_REG_L37CTRL,
+	S2MPS11_REG_L38CTRL,
+};
+
+/* S2MPS11 regulator ids */
+enum s2mps11_regulators {
+	S2MPS11_LDO1,
+	S2MPS11_LDO2,
+	S2MPS11_LDO3,
+	S2MPS11_LDO4,
+	S2MPS11_LDO5,
+	S2MPS11_LDO6,
+	S2MPS11_LDO7,
+	S2MPS11_LDO8,
+	S2MPS11_LDO9,
+	S2MPS11_LDO10,
+	S2MPS11_LDO11,
+	S2MPS11_LDO12,
+	S2MPS11_LDO13,
+	S2MPS11_LDO14,
+	S2MPS11_LDO15,
+	S2MPS11_LDO16,
+	S2MPS11_LDO17,
+	S2MPS11_LDO18,
+	S2MPS11_LDO19,
+	S2MPS11_LDO20,
+	S2MPS11_LDO21,
+	S2MPS11_LDO22,
+	S2MPS11_LDO23,
+	S2MPS11_LDO24,
+	S2MPS11_LDO25,
+	S2MPS11_LDO26,
+	S2MPS11_LDO27,
+	S2MPS11_LDO28,
+	S2MPS11_LDO29,
+	S2MPS11_LDO30,
+	S2MPS11_LDO31,
+	S2MPS11_LDO32,
+	S2MPS11_LDO33,
+	S2MPS11_LDO34,
+	S2MPS11_LDO35,
+	S2MPS11_LDO36,
+	S2MPS11_LDO37,
+	S2MPS11_LDO38,
+	S2MPS11_BUCK1,
+	S2MPS11_BUCK2,
+	S2MPS11_BUCK3,
+	S2MPS11_BUCK4,
+	S2MPS11_BUCK5,
+	S2MPS11_BUCK6,
+	S2MPS11_BUCK7,
+	S2MPS11_BUCK8,
+	S2MPS11_BUCK9,
+	S2MPS11_BUCK10,
+	S2MPS11_AP_EN32KHZ,
+	S2MPS11_CP_EN32KHZ,
+	S2MPS11_BT_EN32KHZ,
+
+	S2MPS11_REG_MAX,
+};
+
+#define S2MPS11_BUCK_MIN1	600000
+#define S2MPS11_BUCK_MIN2	750000
+#define S2MPS11_BUCK_MIN3	3000000
+#define S2MPS11_LDO_MIN	800000
+#define S2MPS11_BUCK_STEP1	6250
+#define S2MPS11_BUCK_STEP2	12500
+#define S2MPS11_BUCK_STEP3	25000
+#define S2MPS11_LDO_STEP1	50000
+#define S2MPS11_LDO_STEP2	25000
+#define S2MPS11_LDO_VSEL_MASK	0x3F
+#define S2MPS11_BUCK_VSEL_MASK	0xFF
+#define S2MPS11_ENABLE_MASK	(0x03 << S2MPS11_ENABLE_SHIFT)
+#define S2MPS11_ENABLE_SHIFT	0x06
+#define S2MPS11_LDO_N_VOLTAGES	(S2MPS11_LDO_VSEL_MASK + 1)
+#define S2MPS11_BUCK_N_VOLTAGES (S2MPS11_BUCK_VSEL_MASK + 1)
+
+#define S2MPS11_PMIC_EN_SHIFT	6
+#define S2MPS11_REGULATOR_MAX (S2MPS11_REG_MAX - 3)
+
+#endif /*  __LINUX_MFD_S2MPS11_H */
-- 
1.7.1


