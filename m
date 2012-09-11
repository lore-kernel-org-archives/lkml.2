Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2IKJrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:47:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42988 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab2IKJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:47:17 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH v2] pwm: Fix compilation error when CONFIG_PWM is not defined
Date: Tue, 11 Sep 2012 15:14:15 +0530
Message-Id: <1347356655-17191-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dummy implemention of public symbols for compilation-safe inclusion
of include/linux/pwm.h file when CONFIG_PWM is not defined.

While at it, also reorganize the file.

Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since v1:
* Incorporated Thierry's suggestions regarding adding dummy function
implemention for all global functions
* Reorganized header file to have structure definitions first and then the
function definitions.

 include/linux/pwm.h |  135 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 97 insertions(+), 38 deletions(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 21d076c..f1e685b 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -6,32 +6,6 @@
 struct pwm_device;
 struct seq_file;
 
-/*
- * pwm_request - request a PWM device
- */
-struct pwm_device *pwm_request(int pwm_id, const char *label);
-
-/*
- * pwm_free - free a PWM device
- */
-void pwm_free(struct pwm_device *pwm);
-
-/*
- * pwm_config - change a PWM device configuration
- */
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
-
-/*
- * pwm_enable - start a PWM output toggling
- */
-int pwm_enable(struct pwm_device *pwm);
-
-/*
- * pwm_disable - stop a PWM output toggling
- */
-void pwm_disable(struct pwm_device *pwm);
-
-#ifdef CONFIG_PWM
 struct pwm_chip;
 
 enum {
@@ -113,18 +87,6 @@ struct pwm_chip {
 	unsigned int		of_pwm_n_cells;
 };
 
-int pwm_set_chip_data(struct pwm_device *pwm, void *data);
-void *pwm_get_chip_data(struct pwm_device *pwm);
-
-int pwmchip_add(struct pwm_chip *chip);
-int pwmchip_remove(struct pwm_chip *chip);
-struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
-					 unsigned int index,
-					 const char *label);
-
-struct pwm_device *pwm_get(struct device *dev, const char *consumer);
-void pwm_put(struct pwm_device *pwm);
-
 struct pwm_lookup {
 	struct list_head list;
 	const char *provider;
@@ -141,8 +103,105 @@ struct pwm_lookup {
 		.con_id = _con_id,			\
 	}
 
+#ifdef CONFIG_PWM
+/*
+ * pwm_request - request a PWM device
+ */
+struct pwm_device *pwm_request(int pwm_id, const char *label);
+
+/*
+ * pwm_free - free a PWM device
+ */
+void pwm_free(struct pwm_device *pwm);
+
+/*
+ * pwm_config - change a PWM device configuration
+ */
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
+
+/*
+ * pwm_enable - start a PWM output toggling
+ */
+int pwm_enable(struct pwm_device *pwm);
+
+/*
+ * pwm_disable - stop a PWM output toggling
+ */
+void pwm_disable(struct pwm_device *pwm);
+
+int pwm_set_chip_data(struct pwm_device *pwm, void *data);
+void *pwm_get_chip_data(struct pwm_device *pwm);
+
+int pwmchip_add(struct pwm_chip *chip);
+int pwmchip_remove(struct pwm_chip *chip);
+struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
+					 unsigned int index,
+					 const char *label);
+
+struct pwm_device *pwm_get(struct device *dev, const char *consumer);
+void pwm_put(struct pwm_device *pwm);
+
 void pwm_add_table(struct pwm_lookup *table, size_t num);
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
+
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
 
+static inline void pwm_add_table(struct pwm_lookup *table, size_t num)
+{}
 #endif
 
 #endif /* __LINUX_PWM_H */
-- 
1.7.4.1

