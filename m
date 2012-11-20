Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2KTFO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:14:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56681 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2KTFOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:14:55 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v3 08/10] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Date: Tue, 20 Nov 2012 10:33:49 +0530
Message-ID: <1353387831-31538-9-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
References: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms (like AM33XX) requires clock gating from control module
explicitly for TBCLK. Enabling of this clock required for the
functioning of the time base sub module in EHRPWM module. So adding
optional TBCLK handling.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Changes since v2:
	- Remove DT property for tbclkgating
	- Use devm_clk_get instead of clk_get

Changes since v1:
	- Moved TBCLK enable from probe to .pwm_enable & disable from
	  remove to .pwm_disable

:100644 100644 1cb54aa... 1298f19... M	drivers/pwm/pwm-tiehrpwm.c
 drivers/pwm/pwm-tiehrpwm.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 1cb54aa..1298f19 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -119,6 +119,7 @@ struct ehrpwm_pwm_chip {
 	void __iomem	*mmio_base;
 	unsigned long period_cycles[NUM_PWM_CHANNEL];
 	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
+	struct	clk	*tbclk;
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -339,6 +340,13 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	/* Channels polarity can be configured from action qualifier module */
 	configure_polarity(pc, pwm->hwpwm);
 
+	/*
+	 * Platforms require explicit clock enabling of TBCLK has
+	 * to enable TBCLK explicitly before enabling PWM device
+	 */
+	if (pc->tbclk)
+		clk_enable(pc->tbclk);
+
 	/* Enable time counter for free_run */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_FREE_RUN);
 	return 0;
@@ -367,6 +375,10 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 
+	/* Disabling TBCLK on PWM disable */
+	if (pc->tbclk)
+		clk_disable(pc->tbclk);
+
 	/* Stop Time base counter */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_STOP_NEXT);
 
@@ -457,6 +469,10 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
 		return ret;
 	}
+
+	/* Populate tbclk entry for platforms require explicit tbclk gating */
+	pc->tbclk = devm_clk_get(&pdev->dev, "tbclk");
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-- 
1.7.0.4

