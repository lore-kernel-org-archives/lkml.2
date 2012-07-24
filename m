Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2GXOUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:20:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45247 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab2GXOUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:20:08 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <avinashphilip@ti.com>
Subject: [PATCH v2] pwm: Add support for configuring the PWM polarity
Date: Tue, 24 Jul 2012 19:35:32 +0530
Message-ID: <1343138732-12972-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware supports inverting the polarity of the PWM signal. This
commit adds support to the PWM framework to allow users of the PWM API
to configure the polarity. Note that in order to reduce complexity,
changing the polarity of a PWM signal is only allowed while the PWM is
disabled.

A practical example where this can prove useful is to simulate inversion
of the duty cycle. While inversion of polarity and duty cycle are not
exactly the same, the differences for most use-cases are negligible.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
changes in  V2:
	- Updates commit message
	- Provides proper comments
	- Removes usage of polarity variable.
	- Removes encoding of polarity in flags

Configuring polarity to be done with PWM device disabled, if not failure
reported.

If PWM device is enabled while configuring polarity, disabling and
re_enabling make it complex. Whoever uses this API has to taken care of
the basic rules.

Discussions related to this can found at
http://www.spinics.net/lists/kernel/msg1372110.html

:100644 100644 ecb7690... f0a1db3... M	drivers/pwm/core.c
:100644 100644 21d076c... 354764c... M	include/linux/pwm.h
 drivers/pwm/core.c  |   22 ++++++++++++++++++++++
 include/linux/pwm.h |   23 +++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index ecb7690..f0a1db3 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -379,6 +379,28 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 EXPORT_SYMBOL_GPL(pwm_config);
 
 /**
+ * pwm_set_polarity() - configure the polarity of a PWM signal
+ * @pwm: PWM device
+ * @polarity: new polarity of the PWM signal
+ *
+ * Note that the polarity cannot be configured while the PWM device is enabled
+ */
+int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity)
+{
+	if (!pwm || !pwm->chip->ops)
+		return -EINVAL;
+
+	if (!pwm->chip->ops->set_polarity)
+		return -ENOSYS;
+
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		return -EBUSY;
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
index 21d076c..354764c 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -34,6 +34,20 @@ void pwm_disable(struct pwm_device *pwm);
 #ifdef CONFIG_PWM
 struct pwm_chip;
 
+/**
+ * enum pwm_polarity - polarity of a PWM signal
+ * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
+ * cycle, followed by a low signal for the remainder of the pulse
+ * period
+ * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
+ * cycle, followed by a high signal for the remainder of the pulse
+ * period
+ */
+enum pwm_polarity {
+	PWM_POLARITY_NORMAL,
+	PWM_POLARITY_INVERSED,
+};
+
 enum {
 	PWMF_REQUESTED = 1 << 0,
 	PWMF_ENABLED = 1 << 1,
@@ -61,11 +75,17 @@ static inline unsigned int pwm_get_period(struct pwm_device *pwm)
 	return pwm ? pwm->period : 0;
 }
 
+/*
+ * pwm_set_polarity - configure the polarity of a PWM signal
+ */
+int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity);
+
 /**
  * struct pwm_ops - PWM controller operations
  * @request: optional hook for requesting a PWM
  * @free: optional hook for freeing a PWM
  * @config: configure duty cycles and period length for this PWM
+ * @set_polarity: configure the polarity of this PWM
  * @enable: enable PWM output toggling
  * @disable: disable PWM output toggling
  * @dbg_show: optional routine to show contents in debugfs
@@ -79,6 +99,9 @@ struct pwm_ops {
 	int			(*config)(struct pwm_chip *chip,
 					  struct pwm_device *pwm,
 					  int duty_ns, int period_ns);
+	int			(*set_polarity)(struct pwm_chip *chip,
+					  struct pwm_device *pwm,
+					  enum pwm_polarity polarity);
 	int			(*enable)(struct pwm_chip *chip,
 					  struct pwm_device *pwm);
 	void			(*disable)(struct pwm_chip *chip,
-- 
1.7.1

