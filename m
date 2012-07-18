Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2GRNIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:08:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59669 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2GRNIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:08:49 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <nsekhar@ti.com>, <avinashphilip@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH] PWM: Add support for configuring polarity of PWM
Date: Wed, 18 Jul 2012 18:24:13 +0530
Message-ID: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duty cycle inversion of PWM wave should achieved through PWM polarity
inversion. Also polarity of PWM wave should configurable from slave
drivers,

Configure polarity
1. PWM_POLARITY_NORMAL  -> duty ns defines ON period of PWM wave
2. PWM_POLARITY_INVERSE -> duty ns defines OFF period of PWM wave.

This patch adds support for configuring PWM polarity in PWM frame work.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Configuring polarity to be done with PWM device disabled, if not
failure reported.

If PWM device is enabled while configuring polarity, disabling and
re_enabling make it complex. Whoever uses this API has to taken
care of the basic rules.

Discussions related to this can found at
http://www.spinics.net/lists/kernel/msg1372110.html

:100644 100644 ecb7690... 24d5495... M	drivers/pwm/core.c
:100644 100644 21d076c... 2e4e960... M	include/linux/pwm.h
 drivers/pwm/core.c  |   32 ++++++++++++++++++++++++++++++++
 include/linux/pwm.h |   15 +++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index ecb7690..24d5495 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -379,6 +379,38 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 EXPORT_SYMBOL_GPL(pwm_config);
 
 /**
+ * pwm_set_polarity() - change PWM device Polarity
+ * @pwm: PWM device
+ * @polarity: Configure polarity of PWM
+ *
+ * Polarity to be configured with PWM device disabled.
+ */
+int pwm_set_polarity(struct pwm_device *pwm, int polarity)
+{
+	int pwm_flags = PWM_POLARITY_NORMAL;
+
+	if (!pwm || !pwm->chip->ops->set_polarity)
+		return -EINVAL;
+
+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
+		dev_err(pwm->chip->dev,
+			"Polarity configuration Failed!, PWM device enabled\n");
+		return -EBUSY;
+	}
+
+	if (polarity == PWM_POLARITY_INVERSE)
+		pwm_flags = PWM_POLARITY_INVERSE;
+
+	if (!pwm_flags)
+		clear_bit(PWMF_POLARITY_INVERSE, &pwm->flags);
+	else
+		set_bit(PWMF_POLARITY_INVERSE, &pwm->flags);
+
+	return pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
+}
+EXPORT_SYMBOL_GPL(pwm_set_polarity);
+
+/**
  * pwm_enable() - start a PWM output toggling
  * @pwm: PWM device
  */
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 21d076c..2e4e960 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -21,6 +21,16 @@ void pwm_free(struct pwm_device *pwm);
  */
 int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
 
+enum {
+	PWM_POLARITY_NORMAL,	/* ON period depends on duty_ns */
+	PWM_POLARITY_INVERSE,	/* OFF period depends on duty_ns */
+};
+
+/*
+ * pwm_set_polarity - set polarity of PWM device
+ */
+int pwm_set_polarity(struct pwm_device *pwm, int polarity);
+
 /*
  * pwm_enable - start a PWM output toggling
  */
@@ -37,6 +47,7 @@ struct pwm_chip;
 enum {
 	PWMF_REQUESTED = 1 << 0,
 	PWMF_ENABLED = 1 << 1,
+	PWMF_POLARITY_INVERSE = 1 << 2,
 };
 
 struct pwm_device {
@@ -66,6 +77,7 @@ static inline unsigned int pwm_get_period(struct pwm_device *pwm)
  * @request: optional hook for requesting a PWM
  * @free: optional hook for freeing a PWM
  * @config: configure duty cycles and period length for this PWM
+ * @set_polarity: configure polarity of PWM
  * @enable: enable PWM output toggling
  * @disable: disable PWM output toggling
  * @dbg_show: optional routine to show contents in debugfs
@@ -79,6 +91,9 @@ struct pwm_ops {
 	int			(*config)(struct pwm_chip *chip,
 					  struct pwm_device *pwm,
 					  int duty_ns, int period_ns);
+	int			(*set_polarity)(struct pwm_chip *chip,
+					  struct pwm_device *pwm,
+					  int polarity);
 	int			(*enable)(struct pwm_chip *chip,
 					  struct pwm_device *pwm);
 	void			(*disable)(struct pwm_chip *chip,
-- 
1.7.1

