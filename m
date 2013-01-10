Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3AJNDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:03:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38860 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab3AJNDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:03:17 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 2/2] pwm: pwm-tiecap: Low power sleep support
Date: Thu, 10 Jan 2013 18:33:44 +0530
Message-ID: <1357823024-17585-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
References: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In low power modes of AM33XX platforms, peripherals power is cut off.
This patch supports low power sleep transition support for ECAP driver.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 drivers/pwm/pwm-tiecap.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 5cf016d..9dde1fe 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -41,10 +41,17 @@
 #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
 #define ECCTL2_TSCTR_FREERUN	BIT(4)
 
+struct ecap_regs {
+	u32	cap3;
+	u32	cap4;
+	u16	ecctl2;
+};
+
 struct ecap_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
+	struct ecap_regs ctx;
 };
 
 static inline struct ecap_pwm_chip *to_ecap_pwm_chip(struct pwm_chip *chip)
@@ -288,11 +295,48 @@ static int ecap_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
+void ecap_pwm_save_reg(struct ecap_pwm_chip *pc)
+{
+	pm_runtime_get_sync(pc->chip.dev);
+	pc->ctx.ecctl2 = readw(pc->mmio_base + ECCTL2);
+	pc->ctx.cap4 = readl(pc->mmio_base + CAP4);
+	pc->ctx.cap3 = readl(pc->mmio_base + CAP3);
+	pm_runtime_put_sync(pc->chip.dev);
+}
+
+void ecap_pwm_restore_reg(struct ecap_pwm_chip *pc)
+{
+	writel(pc->ctx.cap3, pc->mmio_base + CAP3);
+	writel(pc->ctx.cap4, pc->mmio_base + CAP4);
+	writew(pc->ctx.ecctl2, pc->mmio_base + ECCTL2);
+}
+
+static int ecap_pwm_suspend(struct device *dev)
+{
+	struct ecap_pwm_chip *pc = dev_get_drvdata(dev);
+
+	ecap_pwm_save_reg(pc);
+	pm_runtime_put_sync(dev);
+	return 0;
+}
+
+static int ecap_pwm_resume(struct device *dev)
+{
+	struct ecap_pwm_chip *pc = dev_get_drvdata(dev);
+
+	pm_runtime_get_sync(dev);
+	ecap_pwm_restore_reg(pc);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ecap_pwm_pm_ops, ecap_pwm_suspend, ecap_pwm_resume);
+
 static struct platform_driver ecap_pwm_driver = {
 	.driver = {
 		.name	= "ecap",
 		.owner	= THIS_MODULE,
 		.of_match_table = ecap_of_match,
+		.pm	= &ecap_pwm_pm_ops,
 	},
 	.probe = ecap_pwm_probe,
 	.remove = ecap_pwm_remove,
-- 
1.7.9.5

