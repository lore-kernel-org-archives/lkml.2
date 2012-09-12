Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2ILJDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:03:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52989 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2ILJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:03:23 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH v3] pwm: Fix compilation error when CONFIG_PWM is not defined
Date: Wed, 12 Sep 2012 14:30:12 +0530
Message-Id: <1347440412-17249-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dummy implemention of public symbols for compilation-safe inclusion
of include/linux/pwm.h file when CONFIG_PWM is not defined.

Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since v2:
* #if condition for legacy functions modified
* Reverted layout changes, can be taken up when HAVE_PWM is no longer
required.

Changes since v1:
* Incorporated Thierry's suggestions regarding adding dummy function
implemention for all global functions
* Reorganized header file to have structure definitions first and then the
function definitions.

 include/linux/pwm.h |   69 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 21d076c..2c5daa9 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -6,6 +6,7 @@
 struct pwm_device;
 struct seq_file;
 
+#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
 /*
  * pwm_request - request a PWM device
  */
@@ -30,8 +31,29 @@ int pwm_enable(struct pwm_device *pwm);
  * pwm_disable - stop a PWM output toggling
  */
 void pwm_disable(struct pwm_device *pwm);
+#else
+static inline struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	return NULL;
+}
+
+static inline void pwm_free(struct pwm_device *pwm)
+{}
+
+static inline int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	return -EINVAL;
+}
+
+static inline int pwm_enable(struct pwm_device *pwm)
+{
+	return -EINVAL;
+}
+
+static inline void pwm_disable(struct pwm_device *pwm)
+{}
+#endif /* !(IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)) */
 
-#ifdef CONFIG_PWM
 struct pwm_chip;
 
 enum {
@@ -113,6 +135,7 @@ struct pwm_chip {
 	unsigned int		of_pwm_n_cells;
 };
 
+#if IS_ENABLED(CONFIG_PWM)
 int pwm_set_chip_data(struct pwm_device *pwm, void *data);
 void *pwm_get_chip_data(struct pwm_device *pwm);
 
@@ -124,6 +147,43 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 
 struct pwm_device *pwm_get(struct device *dev, const char *consumer);
 void pwm_put(struct pwm_device *pwm);
+#else
+static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
+{
+	return -EINVAL;
+}
+
+static inline void *pwm_get_chip_data(struct pwm_device *pwm)
+{
+	return NULL;
+}
+
+static inline int pwmchip_add(struct pwm_chip *chip)
+{
+	return -EINVAL;
+}
+
+static inline int pwmchip_remove(struct pwm_chip *chip)
+{
+	return -EINVAL;
+}
+
+static inline struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
+		unsigned int index,
+		const char *label)
+{
+	return NULL;
+}
+
+static inline struct pwm_device *pwm_get(struct device *dev,
+		const char *consumer)
+{
+	return NULL;
+}
+
+static inline void pwm_put(struct pwm_device *pwm)
+{}
+#endif /* !IS_ENABLED(CONFIG_PWM) */
 
 struct pwm_lookup {
 	struct list_head list;
@@ -141,8 +201,11 @@ struct pwm_lookup {
 		.con_id = _con_id,			\
 	}
 
+#if IS_ENABLED(CONFIG_PWM)
 void pwm_add_table(struct pwm_lookup *table, size_t num);
-
-#endif
+#else
+static inline void pwm_add_table(struct pwm_lookup *table, size_t num)
+{}
+#endif /* !IS_ENABLED(CONFIG_PWM) */
 
 #endif /* __LINUX_PWM_H */
-- 
1.7.4.1

