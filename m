Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2LLJHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:07:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33319 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab2LLJFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:05:13 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v4 5/7] pwm: Add devm_of_pwm_get() as exported API for users
Date: Wed, 12 Dec 2012 10:04:50 +0100
Message-ID: <1355303092-15523-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
References: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booted with DT users can use devm version of of_pwm_get() to benefit
from automatic resource release.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/pwm/core.c  | 30 ++++++++++++++++++++++++++++++
 include/linux/pwm.h |  9 +++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 3cb741d..4a13da4 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -708,6 +708,36 @@ struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id)
 }
 EXPORT_SYMBOL_GPL(devm_pwm_get);
 
+/**
+ * devm_of_pwm_get() - resource managed of_pwm_get()
+ * @dev: device for PWM consumer
+ * @np: device node to get the PWM from
+ * @con_id: consumer name
+ *
+ * This function performs like of_pwm_get() but the acquired PWM device will
+ * automatically be released on driver detach.
+ */
+struct pwm_device *devm_of_pwm_get(struct device *dev, struct device_node *np,
+				   const char *con_id)
+{
+	struct pwm_device **ptr, *pwm;
+
+	ptr = devres_alloc(devm_pwm_release, sizeof(**ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwm = of_pwm_get(np, con_id);
+	if (!IS_ERR(pwm)) {
+		*ptr = pwm;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return pwm;
+}
+EXPORT_SYMBOL_GPL(devm_of_pwm_get);
+
 static int devm_pwm_match(struct device *dev, void *res, void *data)
 {
 	struct pwm_device **p = res;
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 76a1959..70655a2 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -179,6 +179,8 @@ struct pwm_device *of_pwm_get(struct device_node *np, const char *con_id);
 void pwm_put(struct pwm_device *pwm);
 
 struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id);
+struct pwm_device *devm_of_pwm_get(struct device *dev, struct device_node *np,
+				   const char *con_id);
 void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
 #else
 static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
@@ -230,6 +232,13 @@ static inline struct pwm_device *devm_pwm_get(struct device *dev,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct pwm_device *devm_of_pwm_get(struct device *dev,
+						 struct device_node *np,
+						 const char *con_id)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
 {
 }
-- 
1.8.0

