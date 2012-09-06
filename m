Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2IFF27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:28:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51931 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2IFF26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:28:58 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH V2 1/2] pwm: pwm-tiecap: Add support for configuring polarity of PWM
Date: Thu, 6 Sep 2012 10:40:02 +0530
Message-ID: <1346908203-10632-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
References: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ECAP APWM hardware supports polarity configuration of PWM output.
This commit adds support for polarity configuration of ECAP APWM.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 4b66889... a3d21e7... M	drivers/pwm/pwm-tiecap.c
 drivers/pwm/pwm-tiecap.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 4b66889..a3d21e7 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -32,6 +32,7 @@
 #define CAP3			0x10
 #define CAP4			0x14
 #define ECCTL2			0x2A
+#define ECCTL2_APWM_POL_LOW	BIT(10)
 #define ECCTL2_APWM_MODE	BIT(9)
 #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
 #define ECCTL2_TSCTR_FREERUN	BIT(4)
@@ -111,6 +112,26 @@ static int ecap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
+static int ecap_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+		enum pwm_polarity polarity)
+{
+	struct ecap_pwm_chip *pc = to_ecap_pwm_chip(chip);
+	unsigned short reg_val;
+
+	pm_runtime_get_sync(pc->chip.dev);
+	reg_val = readw(pc->mmio_base + ECCTL2);
+	if (polarity == PWM_POLARITY_INVERSED)
+		/* Duty cycle defines LOW period of PWM */
+		reg_val |= ECCTL2_APWM_POL_LOW;
+	else
+		/* Duty cycle defines HIGH period of PWM */
+		reg_val &= ~ECCTL2_APWM_POL_LOW;
+
+	writew(reg_val, pc->mmio_base + ECCTL2);
+	pm_runtime_put_sync(pc->chip.dev);
+	return 0;
+}
+
 static int ecap_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct ecap_pwm_chip *pc = to_ecap_pwm_chip(chip);
@@ -157,6 +178,7 @@ static void ecap_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 static const struct pwm_ops ecap_pwm_ops = {
 	.free		= ecap_pwm_free,
 	.config		= ecap_pwm_config,
+	.set_polarity	= ecap_pwm_set_polarity,
 	.enable		= ecap_pwm_enable,
 	.disable	= ecap_pwm_disable,
 	.owner		= THIS_MODULE,
-- 
1.7.1

