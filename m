Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab2IFFck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:32:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2IFFcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:32:39 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH v2] pwm: pwm-tiehrpwm: Fix conflicting channel period setting
Date: Thu, 6 Sep 2012 10:44:25 +0530
Message-ID: <1346908465-11628-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHRPWM hardware supports 2 independent PWM channels. However the device
uses only one register to handle period setting for both channels. So
both channels should be configured for same period (in nsec).

Fix the same by returning error for conflicting period values.

However, allow
1. Configuration of period settings if not conflicting with other
channels
2. Re-configuring of period settings if no other channels being
configured

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 c3756d1... b1996bc... M	drivers/pwm/pwm-tiehrpwm.c
 drivers/pwm/pwm-tiehrpwm.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index c3756d1..b1996bc 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -104,6 +104,7 @@ struct ehrpwm_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
+	unsigned long period_cycles[NUM_PWM_CHANNEL];
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -210,6 +211,7 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long long c;
 	unsigned long period_cycles, duty_cycles;
 	unsigned short ps_divval, tb_divval;
+	int i;
 
 	if (period_ns < 0 || duty_ns < 0 || period_ns > NSEC_PER_SEC)
 		return -ERANGE;
@@ -229,6 +231,28 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		duty_cycles = (unsigned long)c;
 	}
 
+	/*
+	 * Period values should be same for multiple PWM channels as IP uses
+	 * same period register for multiple channels.
+	 */
+	for (i = 0; i < NUM_PWM_CHANNEL; i++) {
+		if (pc->period_cycles[i] &&
+				(pc->period_cycles[i] != period_cycles)) {
+			/*
+			 * Allow channel to reconfigure period if no other
+			 * channels being configured.
+			 */
+			if (i == pwm->hwpwm)
+				continue;
+
+			dev_err(chip->dev, "Period value conflicts with channel %d\n",
+					i);
+			return -EINVAL;
+		}
+	}
+
+	pc->period_cycles[pwm->hwpwm] = period_cycles;
+
 	/* Configure clock prescaler to support Low frequency PWM wave */
 	if (set_prescale_div(period_cycles/PERIOD_MAX, &ps_divval,
 				&tb_divval)) {
@@ -320,10 +344,15 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
+	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
+
 	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
 		dev_warn(chip->dev, "Removing PWM device without disabling\n");
 		pm_runtime_put_sync(chip->dev);
 	}
+
+	/* set period value to zero on free */
+	pc->period_cycles[pwm->hwpwm] = 0;
 }
 
 static const struct pwm_ops ehrpwm_pwm_ops = {
-- 
1.7.1

