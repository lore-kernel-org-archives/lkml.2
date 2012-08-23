Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab2HWHRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:17:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab2HWHRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:17:20 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 2/2] pwm: pwm-tiehrpwm: Add support for configuring polarity of PWM
Date: Thu, 23 Aug 2012 12:30:51 +0530
Message-ID: <1345705251-10942-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1345705251-10942-1-git-send-email-avinashphilip@ti.com>
References: <1345705251-10942-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHRPWM hardware supports polarity configuration of PWM output. However
configuration of polarity done in hardware only in .enable() to ensure
PWM output present only after enabling PWM. This commit adds support for
polarity configuration for EHRPWM.
When being here, remove configuring of polarity during .config() and do
it explicitly from .set_polarity().

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>

:100644 100644 c3756d1... 99e5247... M	drivers/pwm/pwm-tiehrpwm.c

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index c3756d1..99e5247 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -81,6 +81,15 @@
 #define AQCTL_ZRO_FRCHIGH	BIT(1)
 #define AQCTL_ZRO_FRCTOGGLE	(BIT(1) | BIT(0))
 
+#define AQCTL_CHANA_POLNORMAL	(AQCTL_CAU_FRCHIGH | AQCTL_PRD_FRCLOW | \
+				AQCTL_ZRO_FRCLOW)
+#define AQCTL_CHANA_POLINVERSED	(AQCTL_CAU_FRCLOW | AQCTL_PRD_FRCHIGH | \
+				AQCTL_ZRO_FRCHIGH)
+#define AQCTL_CHANB_POLNORMAL	(AQCTL_CBU_FRCHIGH | AQCTL_PRD_FRCLOW | \
+				AQCTL_ZRO_FRCLOW)
+#define AQCTL_CHANB_POLINVERSED	(AQCTL_CBU_FRCLOW | AQCTL_PRD_FRCHIGH | \
+				AQCTL_ZRO_FRCHIGH)
+
 #define AQSFRC_RLDCSF_MASK	(BIT(7) | BIT(6))
 #define AQSFRC_RLDCSF_ZRO	0
 #define AQSFRC_RLDCSF_PRD	BIT(6)
@@ -100,10 +109,17 @@
 
 #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
 
+enum config {
+	config_dutycycle,
+	config_polarity,
+};
+
 struct ehrpwm_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
+	unsigned long duty_cycles;
+	enum pwm_polarity polarity;
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -165,38 +181,50 @@ static int set_prescale_div(unsigned long rqst_prescaler,
 }
 
 static void configure_chans(struct ehrpwm_pwm_chip *pc, int chan,
-		unsigned long duty_cycles)
+		enum config config)
 {
-	int cmp_reg, aqctl_reg;
-	unsigned short aqctl_val, aqctl_mask;
+	if (config == config_dutycycle) {
+		int cmp_reg;
+
+		if (chan == 1)
+			/* Channel 1 configured with compare B register */
+			cmp_reg = CMPB;
+		else
+			/* Channel 0 configured with compare A register */
+			cmp_reg = CMPA;
+
+		ehrpwm_write(pc->mmio_base, cmp_reg, pc->duty_cycles);
+	} else if (config == config_polarity) {
+		int aqctl_reg;
+		unsigned short aqctl_val, aqctl_mask;
+
+		/*
+		 * Configure PWM output to HIGH/LOW level on counter
+		 * reaches compare register value and LOW/HIGH level
+		 * on counter value reaches period register value and
+		 * zero value on counter
+		 */
+		if (chan == 1) {
+			aqctl_reg = AQCTLB;
+			aqctl_mask = AQCTL_CBU_MASK;
+
+			if (pc->polarity == PWM_POLARITY_INVERSED)
+				aqctl_val = AQCTL_CHANB_POLINVERSED;
+			else
+				aqctl_val = AQCTL_CHANB_POLNORMAL;
+		} else {
+			aqctl_reg = AQCTLA;
+			aqctl_mask = AQCTL_CAU_MASK;
+
+			if (pc->polarity == PWM_POLARITY_INVERSED)
+				aqctl_val = AQCTL_CHANA_POLINVERSED;
+			else
+				aqctl_val = AQCTL_CHANA_POLNORMAL;
+		}
 
-	/*
-	 * Channels can be configured from action qualifier module.
-	 * Channel 0 configured with compare A register and for
-	 * up-counter mode.
-	 * Channel 1 configured with compare B register and for
-	 * up-counter mode.
-	 */
-	if (chan == 1) {
-		aqctl_reg = AQCTLB;
-		cmp_reg = CMPB;
-		/* Configure PWM Low from compare B value */
-		aqctl_val = AQCTL_CBU_FRCLOW;
-		aqctl_mask = AQCTL_CBU_MASK;
-	} else {
-		cmp_reg = CMPA;
-		aqctl_reg = AQCTLA;
-		/* Configure PWM Low from compare A value*/
-		aqctl_val = AQCTL_CAU_FRCLOW;
-		aqctl_mask = AQCTL_CAU_MASK;
+		aqctl_mask |= AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
+		ehrpwm_modify(pc->mmio_base, aqctl_reg, aqctl_mask, aqctl_val);
 	}
-
-	/* Configure PWM High from period value and zero value */
-	aqctl_val |= AQCTL_PRD_FRCHIGH | AQCTL_ZRO_FRCHIGH;
-	aqctl_mask |= AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
-	ehrpwm_modify(pc->mmio_base,  aqctl_reg, aqctl_mask, aqctl_val);
-
-	ehrpwm_write(pc->mmio_base,  cmp_reg, duty_cycles);
 }
 
 /*
@@ -254,12 +282,24 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_CTRMODE_MASK,
 			TBCTL_CTRMODE_UP);
 
+	pc->duty_cycles = duty_cycles;
 	/* Configure the channel for duty cycle */
-	configure_chans(pc, pwm->hwpwm, duty_cycles);
+	configure_chans(pc, pwm->hwpwm, config_dutycycle);
+
 	pm_runtime_put_sync(chip->dev);
 	return 0;
 }
 
+static int ehrpwm_pwm_set_polarity(struct pwm_chip *chip,
+		struct pwm_device *pwm,	enum pwm_polarity polarity)
+{
+	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
+
+	/* Configuration of polarity in hardware delayed done at enable */
+	pc->polarity = polarity;
+	return 0;
+}
+
 static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
@@ -283,6 +323,9 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 
+	/* Channels Polarity can be configured from action qualifier module */
+	configure_chans(pc, pwm->hwpwm, config_polarity);
+
 	/* Enable time counter for free_run */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_FREE_RUN);
 	return 0;
@@ -329,6 +372,7 @@ static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 static const struct pwm_ops ehrpwm_pwm_ops = {
 	.free		= ehrpwm_pwm_free,
 	.config		= ehrpwm_pwm_config,
+	.set_polarity	= ehrpwm_pwm_set_polarity,
 	.enable		= ehrpwm_pwm_enable,
 	.disable	= ehrpwm_pwm_disable,
 	.owner		= THIS_MODULE,
-- 
1.7.1

