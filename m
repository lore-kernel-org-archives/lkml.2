Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2KEJaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:30:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48224 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab2KEJaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:30:19 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 6/8] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Date: Mon, 5 Nov 2012 14:42:27 +0530
Message-ID: <1352106749-9437-7-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms (like AM33XX) requires clock gating from control module
explicitly. So adding optional TBCLK handling if DT node populated with
tbclkgating. This helps the driver can coexist for Davinci platforms.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 1e63652... cf69da3... M	drivers/pwm/pwm-tiehrpwm.c
 drivers/pwm/pwm-tiehrpwm.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 1e63652..cf69da3 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -123,6 +123,7 @@ struct ehrpwm_pwm_chip {
 	void __iomem	*mmio_base;
 	unsigned long period_cycles[NUM_PWM_CHANNEL];
 	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
+	struct	clk	*tbclk;
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -461,6 +462,20 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
 		return ret;
 	}
+
+	/* Some platforms require explicit tbclk gating */
+	if (of_property_read_bool(pdev->dev.of_node, "tbclkgating")) {
+		pc->tbclk = clk_get(&pdev->dev, "tbclk");
+		if (IS_ERR(pc->tbclk)) {
+			dev_err(&pdev->dev, "Could not get EHRPWM TBCLK\n");
+			return PTR_ERR(pc->tbclk);
+		}
+	}
+
+	/* Enable tbclk & leave */
+	if (pc->tbclk)
+		clk_enable(pc->tbclk);
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 	pwmss_submodule_state_change(pdev->dev.parent, EPWMCLK_EN_SHIFT, true);
@@ -478,6 +493,8 @@ static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 	pwmss_submodule_state_change(pdev->dev.parent, EPWMCLK_EN_SHIFT, false);
 	pm_runtime_put_sync(&pdev->dev);
 
+	if (pc->tbclk)
+		clk_disable(pc->tbclk);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return pwmchip_remove(&pc->chip);
-- 
1.7.0.4

