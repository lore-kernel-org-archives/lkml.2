Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2JAGfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:35:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2JAGfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:35:13 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Sachin Kamat <sachin.kamat@linaro.org>,
        Axel Lin <axel.lin@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>
Subject: [PATCH] pwm: Check for negative duty-cycle and period
Date: Mon,  1 Oct 2012 08:34:54 +0200
Message-Id: <1349073294-14947-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12.2
X-Provags-ID: V02:K0:OVoWAoD3K4xVpUp4FwXgYaNC9wfBDM65/WiwnG2k9fN
 6xfkp/kdMaTLkQPBZybNDRO4hoSaROyqLEMheDYA/7vOJt0Da8
 rtIR3Fa31ELWYQTwxLwVVR30jg0Zdcm3eTW+hnjn4b0n+ceycK
 ncSDgRcmCf8cy6CYdAsKhRdWhPAigPL47RkuciqgAKHzTjKG0H
 atG4LGE5OM8lkeZA5kDqtMjPOPIZB8eX7ylHRwawLqPiz79+O+
 r8a7lRpUSLtQaqy9WcpBbqIEUWKMh8A3N7fZJ8iROQaVJOWekS
 F2NuR/K/qZEmw9AhCbcKCP4Me0Ie2DKS/k7EnjfbrWVTgDmTCk
 YWuuYXJFASzzEdjaApOwXu7yWf3vCpvcXKMSfJM7gDg/zNdHI2
 o5wOJp8Xa1IxyMkOeY3TgK06lfkUdgIPx8U8gz8uj72nnK8AnQ
 Inwf7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the duty-cycle and period passed in are not negative. This
should eventually be made implicit by making them unsigned. While at
it, the drivers' .config() implementations can have the equivalent
checks removed.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: "Philip, Avinash" <avinashphilip@ti.com>
Cc: Vaibhav Bedia <vaibhav.bedia@ti.com>
---
 drivers/pwm/core.c         | 2 +-
 drivers/pwm/pwm-bfin.c     | 3 ---
 drivers/pwm/pwm-pxa.c      | 3 ---
 drivers/pwm/pwm-samsung.c  | 3 ---
 drivers/pwm/pwm-tiecap.c   | 2 +-
 drivers/pwm/pwm-tiehrpwm.c | 2 +-
 6 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 92b1782..f5acdaa 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(pwm_free);
  */
 int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
-	if (!pwm || period_ns == 0 || duty_ns > period_ns)
+	if (!pwm || duty_ns < 0 || period_ns <= 0 || duty_ns > period_ns)
 		return -EINVAL;
 
 	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
diff --git a/drivers/pwm/pwm-bfin.c b/drivers/pwm/pwm-bfin.c
index d53c4e7..5da8e18 100644
--- a/drivers/pwm/pwm-bfin.c
+++ b/drivers/pwm/pwm-bfin.c
@@ -69,9 +69,6 @@ static int bfin_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long period, duty;
 	unsigned long long val;
 
-	if (duty_ns < 0 || duty_ns > period_ns)
-		return -EINVAL;
-
 	val = (unsigned long long)get_sclk() * period_ns;
 	do_div(val, NSEC_PER_SEC);
 	period = val;
diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index bd5867a..260c3a8 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -70,9 +70,6 @@ static int pxa_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long offset;
 	int rc;
 
-	if (period_ns == 0 || duty_ns > period_ns)
-		return -EINVAL;
-
 	offset = pwm->hwpwm ? 0x10 : 0;
 
 	c = clk_get_rate(pc->clk);
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index e5187c0..023a3be 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -126,9 +126,6 @@ static int s3c_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (period_ns > NS_IN_HZ || duty_ns > NS_IN_HZ)
 		return -ERANGE;
 
-	if (duty_ns > period_ns)
-		return -EINVAL;
-
 	if (period_ns == s3c->period_ns &&
 	    duty_ns == s3c->duty_ns)
 		return 0;
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 081471f..d6d4cf0 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -60,7 +60,7 @@ static int ecap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long period_cycles, duty_cycles;
 	unsigned int reg_val;
 
-	if (period_ns < 0 || duty_ns < 0 || period_ns > NSEC_PER_SEC)
+	if (period_ns > NSEC_PER_SEC)
 		return -ERANGE;
 
 	c = pc->clk_rate;
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index caf00fe..d3c1dff 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -221,7 +221,7 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned short ps_divval, tb_divval;
 	int i, cmp_reg;
 
-	if (period_ns < 0 || duty_ns < 0 || period_ns > NSEC_PER_SEC)
+	if (period_ns > NSEC_PER_SEC)
 		return -ERANGE;
 
 	c = pc->clk_rate;
-- 
1.7.12.2

