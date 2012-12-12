Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2LLJGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:06:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33322 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2LLJFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:05:17 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v4 4/7] pwm: core: Rename of_pwm_request() to of_pwm_get() and export it
Date: Wed, 12 Dec 2012 10:04:49 +0100
Message-ID: <1355303092-15523-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
References: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow client driver to use of_pwm_get() to get the PWM they need. This
is needed for drivers which handle more than one PWM separately, like
leds-pwm driver, which have:

pwmleds {
	compatible = "pwm-leds";
	kpad {
		label = "omap4::keypad";
		pwms = <&twl_pwm 0 7812500>;
		max-brightness = <127>;
	};

	charging {
		label = "omap4:green:chrg";
		pwms = <&twl_pwmled 0 7812500>;
		max-brightness = <255>;
	};
};

in the dts files.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/pwm/core.c  | 8 ++++----
 include/linux/pwm.h | 7 +++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 903138b..3cb741d 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -471,7 +471,7 @@ static struct pwm_chip *of_node_to_pwmchip(struct device_node *np)
 }
 
 /**
- * of_pwm_request() - request a PWM via the PWM framework
+ * of_pwm_get() - request a PWM via the PWM framework
  * @np: device node to get the PWM from
  * @con_id: consumer name
  *
@@ -486,8 +486,7 @@ static struct pwm_chip *of_node_to_pwmchip(struct device_node *np)
  * becomes mandatory for devices that look up the PWM device via the con_id
  * parameter.
  */
-static struct pwm_device *of_pwm_request(struct device_node *np,
-					 const char *con_id)
+struct pwm_device *of_pwm_get(struct device_node *np, const char *con_id)
 {
 	struct pwm_device *pwm = NULL;
 	struct of_phandle_args args;
@@ -545,6 +544,7 @@ put:
 
 	return pwm;
 }
+EXPORT_SYMBOL_GPL(of_pwm_get);
 
 /**
  * pwm_add_table() - register PWM device consumers
@@ -587,7 +587,7 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 
 	/* look up via DT first */
 	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
-		return of_pwm_request(dev->of_node, con_id);
+		return of_pwm_get(dev->of_node, con_id);
 
 	/*
 	 * We look up the provider in the static table typically provided by
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index cc908a5..76a1959 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -175,6 +175,7 @@ struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
 		const struct of_phandle_args *args);
 
 struct pwm_device *pwm_get(struct device *dev, const char *con_id);
+struct pwm_device *of_pwm_get(struct device_node *np, const char *con_id);
 void pwm_put(struct pwm_device *pwm);
 
 struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id);
@@ -213,6 +214,12 @@ static inline struct pwm_device *pwm_get(struct device *dev,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct pwm_device *of_pwm_get(struct device_node *np,
+					    const char *con_id)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline void pwm_put(struct pwm_device *pwm)
 {
 }
-- 
1.8.0

