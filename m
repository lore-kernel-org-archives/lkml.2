Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2IFF3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:29:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33292 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2IFF3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:29:03 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH V2 2/2] pwm: pwm-tiehrpwm: Add support for configuring polarity of PWM
Date: Thu, 6 Sep 2012 10:40:03 +0530
Message-ID: <1346908203-10632-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
References: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
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
---
changes since v1:
	- Remove config_chans API. Duty cycle configuration done in .cinfig()
	- Introduce config_polarity API, as don't want to confuse the
	  functionality of .enable()
	- Introduce polarity member as array in private structure to handle
	  both channels.

:100644 100644 b1996bc... db3675f... M	drivers/pwm/pwm-tiehrpwm.c
 drivers/pwm/pwm-tiehrpwm.c |   73 ++++++++++++++++++++++++++++++-------------
 1 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index b1996bc..db3675f 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -81,6 +81,15 @@
 #define AQCTL_ZRO_FRCHIGH	BIT(1)
 #define AQCTL_ZRO_FRCTOGGLE	(BIT(1) | BIT(0))
 
+#define AQCTL_CHANA_POLNORMAL	(AQCTL_CAU_FRCLOW | AQCTL_PRD_FRCHIGH | \
+				AQCTL_ZRO_FRCHIGH)
+#define AQCTL_CHANA_POLINVERSED	(AQCTL_CAU_FRCHIGH | AQCTL_PRD_FRCLOW | \
+				AQCTL_ZRO_FRCLOW)
+#define AQCTL_CHANB_POLNORMAL	(AQCTL_CBU_FRCLOW | AQCTL_PRD_FRCHIGH | \
+				AQCTL_ZRO_FRCHIGH)
+#define AQCTL_CHANB_POLINVERSED	(AQCTL_CBU_FRCHIGH | AQCTL_PRD_FRCLOW | \
+				AQCTL_ZRO_FRCLOW)
+
 #define AQSFRC_RLDCSF_MASK	(BIT(7) | BIT(6))
 #define AQSFRC_RLDCSF_ZRO	0
 #define AQSFRC_RLDCSF_PRD	BIT(6)
@@ -105,6 +114,7 @@ struct ehrpwm_pwm_chip {
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
 	unsigned long period_cycles[NUM_PWM_CHANNEL];
+	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -165,39 +175,37 @@ static int set_prescale_div(unsigned long rqst_prescaler,
 	return 1;
 }
 
-static void configure_chans(struct ehrpwm_pwm_chip *pc, int chan,
-		unsigned long duty_cycles)
+static void configure_polarity(struct ehrpwm_pwm_chip *pc, int chan)
 {
-	int cmp_reg, aqctl_reg;
+	int aqctl_reg;
 	unsigned short aqctl_val, aqctl_mask;
 
 	/*
-	 * Channels can be configured from action qualifier module.
-	 * Channel 0 configured with compare A register and for
-	 * up-counter mode.
-	 * Channel 1 configured with compare B register and for
-	 * up-counter mode.
+	 * Configure PWM output to HIGH/LOW level on counter
+	 * reaches compare register value and LOW/HIGH level
+	 * on counter value reaches period register value and
+	 * zero value on counter
 	 */
 	if (chan == 1) {
 		aqctl_reg = AQCTLB;
-		cmp_reg = CMPB;
-		/* Configure PWM Low from compare B value */
-		aqctl_val = AQCTL_CBU_FRCLOW;
 		aqctl_mask = AQCTL_CBU_MASK;
+
+		if (pc->polarity[chan] == PWM_POLARITY_INVERSED)
+			aqctl_val = AQCTL_CHANB_POLINVERSED;
+		else
+			aqctl_val = AQCTL_CHANB_POLNORMAL;
 	} else {
-		cmp_reg = CMPA;
 		aqctl_reg = AQCTLA;
-		/* Configure PWM Low from compare A value*/
-		aqctl_val = AQCTL_CAU_FRCLOW;
 		aqctl_mask = AQCTL_CAU_MASK;
+
+		if (pc->polarity[chan] == PWM_POLARITY_INVERSED)
+			aqctl_val = AQCTL_CHANA_POLINVERSED;
+		else
+			aqctl_val = AQCTL_CHANA_POLNORMAL;
 	}
 
-	/* Configure PWM High from period value and zero value */
-	aqctl_val |= AQCTL_PRD_FRCHIGH | AQCTL_ZRO_FRCHIGH;
 	aqctl_mask |= AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
-	ehrpwm_modify(pc->mmio_base,  aqctl_reg, aqctl_mask, aqctl_val);
-
-	ehrpwm_write(pc->mmio_base,  cmp_reg, duty_cycles);
+	ehrpwm_modify(pc->mmio_base, aqctl_reg, aqctl_mask, aqctl_val);
 }
 
 /*
@@ -211,7 +219,7 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long long c;
 	unsigned long period_cycles, duty_cycles;
 	unsigned short ps_divval, tb_divval;
-	int i;
+	int i, cmp_reg;
 
 	if (period_ns < 0 || duty_ns < 0 || period_ns > NSEC_PER_SEC)
 		return -ERANGE;
@@ -278,12 +286,29 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_CTRMODE_MASK,
 			TBCTL_CTRMODE_UP);
 
-	/* Configure the channel for duty cycle */
-	configure_chans(pc, pwm->hwpwm, duty_cycles);
+	if (pwm->hwpwm == 1)
+		/* Channel 1 configured with compare B register */
+		cmp_reg = CMPB;
+	else
+		/* Channel 0 configured with compare A register */
+		cmp_reg = CMPA;
+
+	ehrpwm_write(pc->mmio_base, cmp_reg, duty_cycles);
+
 	pm_runtime_put_sync(chip->dev);
 	return 0;
 }
 
+static int ehrpwm_pwm_set_polarity(struct pwm_chip *chip,
+		struct pwm_device *pwm,	enum pwm_polarity polarity)
+{
+	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
+
+	/* Configuration of polarity in hardware delayed, do at enable */
+	pc->polarity[pwm->hwpwm] = polarity;
+	return 0;
+}
+
 static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
@@ -307,6 +332,9 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 
+	/* Channels polarity can be configured from action qualifier module */
+	configure_polarity(pc, pwm->hwpwm);
+
 	/* Enable time counter for free_run */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_FREE_RUN);
 	return 0;
@@ -358,6 +386,7 @@ static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 static const struct pwm_ops ehrpwm_pwm_ops = {
 	.free		= ehrpwm_pwm_free,
 	.config		= ehrpwm_pwm_config,
+	.set_polarity	= ehrpwm_pwm_set_polarity,
 	.enable		= ehrpwm_pwm_enable,
 	.disable	= ehrpwm_pwm_disable,
 	.owner		= THIS_MODULE,
-- 
1.7.1

