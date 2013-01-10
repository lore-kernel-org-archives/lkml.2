Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3AJNE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:04:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43154 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab3AJNE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:04:57 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2] pwm: pwm-tiehrpwm: Update the clock handling of pwm-tiehrpwm driver
Date: Thu, 10 Jan 2013 18:35:26 +0530
Message-ID: <1357823126-19333-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip, Avinash" <avinashphilip@ti.com>

The clock framework has changed and it's now better to invoke
clock_prepare_enable() and clk_disable_unprepare() rather than the
legacy clk_enable() and clk_disable() calls. This patch converts the
pwm-tiehrpwm driver to the new framework.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes Since v1:
	- Check the return value of TBCLK enable in .pwm_enable()

In 3.8-rc1, common clock frame work support added to AM335x.

 drivers/pwm/pwm-tiehrpwm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 72a6dd4..4fcafbf 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -318,6 +318,7 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
 	unsigned short aqcsfrc_val, aqcsfrc_mask;
+	int ret;
 
 	/* Leave clock enabled on enabling PWM */
 	pm_runtime_get_sync(chip->dev);
@@ -341,7 +342,12 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	configure_polarity(pc, pwm->hwpwm);
 
 	/* Enable TBCLK before enabling PWM device */
-	clk_enable(pc->tbclk);
+	ret = clk_prepare_enable(pc->tbclk);
+	if (ret) {
+		pr_err("Failed to enable TBCLK for %s\n",
+				dev_name(pc->chip.dev));
+		return ret;
+	}
 
 	/* Enable time counter for free_run */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_FREE_RUN);
@@ -372,7 +378,7 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 
 	/* Disabling TBCLK on PWM disable */
-	clk_disable(pc->tbclk);
+	clk_disable_unprepare(pc->tbclk);
 
 	/* Stop Time base counter */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_STOP_NEXT);
-- 
1.7.9.5

