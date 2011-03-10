Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1CJNoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:44:09 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45151 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab1CJNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:44:08 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] regulator: added register initialization for ab8500 regulators
Date: Thu, 10 Mar 2011 14:43:51 +0100
Message-ID: <1299764631-2570-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The regulators can come up in a number of undefined
states, depending on boot path, firmware revisions and
things like kexec():ing into a new kernel. Provide a
platform initialization vector so that we have a known
state when we have booted the kernel.

Initialization added for regulators Vana, VextSupply1,
VextSupply2, VextSupply3, Vaux1, Vaux2, Vaux3, VTVout,
Vintcore12, Vaudio, Vdmic, Vamic1, Vamic2, VrefDDR.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Reviewed-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 +
 arch/arm/mach-ux500/board-mop500.c            |    1 +
 drivers/regulator/ab8500.c                    |  223 ++++++++++++++++++++++++-
 include/linux/mfd/ab8500.h                    |    6 +
 include/linux/regulator/ab8500.h              |   50 ++++++-
 5 files changed, 279 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 2675fae..f979b89 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -14,6 +14,8 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 
+extern struct ab8500_regulator_reg_init
+ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS];
 extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
 
 #endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a393f57..8e3a688 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -19,6 +19,7 @@
 #include <linux/amba/pl022.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
+#include <linux/regulator/ab8500.h>
 #include <linux/mfd/tc3589x.h>
 
 #include <asm/mach-types.h>
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 4e11980..902d715 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -536,6 +536,186 @@ static struct ab8500_regulator_info
 
 };
 
+struct ab8500_reg_init {
+	u8 bank;
+	u8 addr;
+	u8 mask;
+};
+
+#define REG_INIT(_id, _bank, _addr, _mask)	\
+	[_id] = {				\
+		.bank = _bank,			\
+		.addr = _addr,			\
+		.mask = _mask,			\
+	}
+
+static struct ab8500_reg_init ab8500_reg_init[] = {
+	/*
+	 * 0x30, VanaRequestCtrl
+	 * 0x0C, VpllRequestCtrl
+	 * 0xc0, VextSupply1RequestCtrl
+	 */
+	REG_INIT(AB8500_REGUREQUESTCTRL2,	0x03, 0x04, 0xfc),
+	/*
+	 * 0x03, VextSupply2RequestCtrl
+	 * 0x0c, VextSupply3RequestCtrl
+	 * 0x30, Vaux1RequestCtrl
+	 * 0xc0, Vaux2RequestCtrl
+	 */
+	REG_INIT(AB8500_REGUREQUESTCTRL3,	0x03, 0x05, 0xff),
+	/*
+	 * 0x03, Vaux3RequestCtrl
+	 * 0x04, SwHPReq
+	 */
+	REG_INIT(AB8500_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
+	/*
+	 * 0x08, VanaSysClkReq1HPValid
+	 * 0x20, Vaux1SysClkReq1HPValid
+	 * 0x40, Vaux2SysClkReq1HPValid
+	 * 0x80, Vaux3SysClkReq1HPValid
+	 */
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xe8),
+	/*
+	 * 0x10, VextSupply1SysClkReq1HPValid
+	 * 0x20, VextSupply2SysClkReq1HPValid
+	 * 0x40, VextSupply3SysClkReq1HPValid
+	 */
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x70),
+	/*
+	 * 0x08, VanaHwHPReq1Valid
+	 * 0x20, Vaux1HwHPReq1Valid
+	 * 0x40, Vaux2HwHPReq1Valid
+	 * 0x80, Vaux3HwHPReq1Valid
+	 */
+	REG_INIT(AB8500_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xe8),
+	/*
+	 * 0x01, VextSupply1HwHPReq1Valid
+	 * 0x02, VextSupply2HwHPReq1Valid
+	 * 0x04, VextSupply3HwHPReq1Valid
+	 */
+	REG_INIT(AB8500_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x07),
+	/*
+	 * 0x08, VanaHwHPReq2Valid
+	 * 0x20, Vaux1HwHPReq2Valid
+	 * 0x40, Vaux2HwHPReq2Valid
+	 * 0x80, Vaux3HwHPReq2Valid
+	 */
+	REG_INIT(AB8500_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xe8),
+	/*
+	 * 0x01, VextSupply1HwHPReq2Valid
+	 * 0x02, VextSupply2HwHPReq2Valid
+	 * 0x04, VextSupply3HwHPReq2Valid
+	 */
+	REG_INIT(AB8500_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x07),
+	/*
+	 * 0x20, VanaSwHPReqValid
+	 * 0x80, Vaux1SwHPReqValid
+	 */
+	REG_INIT(AB8500_REGUSWHPREQVALID1,	0x03, 0x0d, 0xa0),
+	/*
+	 * 0x01, Vaux2SwHPReqValid
+	 * 0x02, Vaux3SwHPReqValid
+	 * 0x04, VextSupply1SwHPReqValid
+	 * 0x08, VextSupply2SwHPReqValid
+	 * 0x10, VextSupply3SwHPReqValid
+	 */
+	REG_INIT(AB8500_REGUSWHPREQVALID2,	0x03, 0x0e, 0x1f),
+	/*
+	 * 0x02, SysClkReq2Valid1
+	 * ...
+	 * 0x80, SysClkReq8Valid1
+	 */
+	REG_INIT(AB8500_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xfe),
+	/*
+	 * 0x02, SysClkReq2Valid2
+	 * ...
+	 * 0x80, SysClkReq8Valid2
+	 */
+	REG_INIT(AB8500_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xfe),
+	/*
+	 * 0x02, VTVoutEna
+	 * 0x04, Vintcore12Ena
+	 * 0x38, Vintcore12Sel
+	 * 0x40, Vintcore12LP
+	 * 0x80, VTVoutLP
+	 */
+	REG_INIT(AB8500_REGUMISC1,		0x03, 0x80, 0xfe),
+	/*
+	 * 0x02, VaudioEna
+	 * 0x04, VdmicEna
+	 * 0x08, Vamic1Ena
+	 * 0x10, Vamic2Ena
+	 */
+	REG_INIT(AB8500_VAUDIOSUPPLY,		0x03, 0x83, 0x1e),
+	/*
+	 * 0x01, Vamic1_dzout
+	 * 0x02, Vamic2_dzout
+	 */
+	REG_INIT(AB8500_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
+	/*
+	 * 0x0c, VanaRegu
+	 * 0x03, VpllRegu
+	 */
+	REG_INIT(AB8500_VPLLVANAREGU,		0x04, 0x06, 0x0f),
+	/*
+	 * 0x01, VrefDDREna
+	 * 0x02, VrefDDRSleepMode
+	 */
+	REG_INIT(AB8500_VREFDDR,		0x04, 0x07, 0x03),
+	/*
+	 * 0x03, VextSupply1Regu
+	 * 0x0c, VextSupply2Regu
+	 * 0x30, VextSupply3Regu
+	 * 0x40, ExtSupply2Bypass
+	 * 0x80, ExtSupply3Bypass
+	 */
+	REG_INIT(AB8500_EXTSUPPLYREGU,		0x04, 0x08, 0xff),
+	/*
+	 * 0x03, Vaux1Regu
+	 * 0x0c, Vaux2Regu
+	 */
+	REG_INIT(AB8500_VAUX12REGU,		0x04, 0x09, 0x0f),
+	/*
+	 * 0x03, Vaux3Regu
+	 */
+	REG_INIT(AB8500_VRF1VAUX3REGU,		0x04, 0x0a, 0x03),
+	/*
+	 * 0x3f, Vsmps1Sel1
+	 */
+	REG_INIT(AB8500_VSMPS1SEL1,		0x04, 0x13, 0x3f),
+	/*
+	 * 0x0f, Vaux1Sel
+	 */
+	REG_INIT(AB8500_VAUX1SEL,		0x04, 0x1f, 0x0f),
+	/*
+	 * 0x0f, Vaux2Sel
+	 */
+	REG_INIT(AB8500_VAUX2SEL,		0x04, 0x20, 0x0f),
+	/*
+	 * 0x07, Vaux3Sel
+	 */
+	REG_INIT(AB8500_VRF1VAUX3SEL,		0x04, 0x21, 0x07),
+	/*
+	 * 0x01, VextSupply12LP
+	 */
+	REG_INIT(AB8500_REGUCTRL2SPARE,		0x04, 0x22, 0x01),
+	/*
+	 * 0x04, Vaux1Disch
+	 * 0x08, Vaux2Disch
+	 * 0x10, Vaux3Disch
+	 * 0x20, Vintcore12Disch
+	 * 0x40, VTVoutDisch
+	 * 0x80, VaudioDisch
+	 */
+	REG_INIT(AB8500_REGUCTRLDISCH,		0x04, 0x43, 0xfc),
+	/*
+	 * 0x02, VanaDisch
+	 * 0x04, VdmicPullDownEna
+	 * 0x10, VdmicDisch
+	 */
+	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
+};
+
 static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
@@ -554,10 +734,51 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 
 	/* make sure the platform data has the correct size */
 	if (pdata->num_regulator != ARRAY_SIZE(ab8500_regulator_info)) {
-		dev_err(&pdev->dev, "platform configuration error\n");
+		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
 		return -EINVAL;
 	}
 
+	/* initialize registers */
+	for (i = 0; i < pdata->num_regulator_reg_init; i++) {
+		int id;
+		u8 value;
+
+		id = pdata->regulator_reg_init[i].id;
+		value = pdata->regulator_reg_init[i].value;
+
+		/* check for configuration errors */
+		if (id >= AB8500_NUM_REGULATOR_REGISTERS) {
+			dev_err(&pdev->dev,
+				"Configuration error: id outside range.\n");
+			return -EINVAL;
+		}
+		if (value & ~ab8500_reg_init[id].mask) {
+			dev_err(&pdev->dev,
+				"Configuration error: value outside mask.\n");
+			return -EINVAL;
+		}
+
+		/* initialize register */
+		err = abx500_mask_and_set_register_interruptible(&pdev->dev,
+			ab8500_reg_init[id].bank,
+			ab8500_reg_init[id].addr,
+			ab8500_reg_init[id].mask,
+			value);
+		if (err < 0) {
+			dev_err(&pdev->dev,
+				"Failed to initialize 0x%02x, 0x%02x.\n",
+				ab8500_reg_init[id].bank,
+				ab8500_reg_init[id].addr);
+			return err;
+		}
+		dev_vdbg(&pdev->dev,
+			"  init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+			ab8500_reg_init[id].bank,
+			ab8500_reg_init[id].addr,
+			ab8500_reg_init[id].mask,
+			value);
+	}
+
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		struct ab8500_regulator_info *info = NULL;
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index 37f56b7..b837658 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -139,17 +139,23 @@ struct ab8500 {
 	u8 oldmask[AB8500_NUM_IRQ_REGS];
 };
 
+struct regulator_reg_init;
 struct regulator_init_data;
 
 /**
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
  * @init: board-specific initialization after detection of ab8500
+ * @num_regulator_reg_init: number of regulator init registers
+ * @regulator_reg_init: regulator init registers
+ * @num_regulator: number of regulators
  * @regulator: machine-specific constraints for regulators
  */
 struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
+	int num_regulator_reg_init;
+	struct ab8500_regulator_reg_init *regulator_reg_init;
 	int num_regulator;
 	struct regulator_init_data *regulator;
 };
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index d4eacde..76579f9 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -3,8 +3,8 @@
  *
  * License Terms: GNU General Public License v2
  *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
- *
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
  */
 
 #ifndef __LINUX_MFD_AB8500_REGULATOR_H
@@ -25,4 +25,50 @@ enum ab8500_regulator_id {
 	AB8500_LDO_ANA,
 	AB8500_NUM_REGULATORS,
 };
+
+/* AB8500 register initialization */
+struct ab8500_regulator_reg_init {
+	int id;
+	u8 value;
+};
+
+#define INIT_REGULATOR_REGISTER(_id, _value)	\
+	{					\
+		.id = _id,			\
+		.value = _value,		\
+	}
+
+/* AB8500 registers */
+enum ab8500_regulator_reg {
+	AB8500_REGUREQUESTCTRL2,
+	AB8500_REGUREQUESTCTRL3,
+	AB8500_REGUREQUESTCTRL4,
+	AB8500_REGUSYSCLKREQ1HPVALID1,
+	AB8500_REGUSYSCLKREQ1HPVALID2,
+	AB8500_REGUHWHPREQ1VALID1,
+	AB8500_REGUHWHPREQ1VALID2,
+	AB8500_REGUHWHPREQ2VALID1,
+	AB8500_REGUHWHPREQ2VALID2,
+	AB8500_REGUSWHPREQVALID1,
+	AB8500_REGUSWHPREQVALID2,
+	AB8500_REGUSYSCLKREQVALID1,
+	AB8500_REGUSYSCLKREQVALID2,
+	AB8500_REGUMISC1,
+	AB8500_VAUDIOSUPPLY,
+	AB8500_REGUCTRL1VAMIC,
+	AB8500_VPLLVANAREGU,
+	AB8500_VREFDDR,
+	AB8500_EXTSUPPLYREGU,
+	AB8500_VAUX12REGU,
+	AB8500_VRF1VAUX3REGU,
+	AB8500_VAUX1SEL,
+	AB8500_VAUX2SEL,
+	AB8500_VRF1VAUX3SEL,
+	AB8500_REGUCTRL2SPARE,
+	AB8500_REGUCTRLDISCH,
+	AB8500_REGUCTRLDISCH2,
+	AB8500_VSMPS1SEL1,
+	AB8500_NUM_REGULATOR_REGISTERS,
+};
+
 #endif
-- 
1.7.3.2

