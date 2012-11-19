Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2KSRvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:51:44 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54626 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2KSRvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:51:43 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2] pwm: Device tree support for PWM polarity.
Date: Mon, 19 Nov 2012 23:21:12 +0530
Message-ID: <1353347472-26863-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for encoding PWM properties in bit encoded form with
of_pwm_xlate_with_flags() function support. Platforms require platform
specific PWM properties has to populate in 3rd cell of the pwm-specifier
and PWM driver should also set .of_xlate support with this function.
Currently PWM property polarity encoded in bit position 0 of the third
cell in pwm-specifier.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Changes since v1:
	- of_pwm_xlate_with_flags function support added.
	- Documentation update

:100644 100644 73ec962... 04b0dc4... M	Documentation/devicetree/bindings/pwm/pwm.txt
:100644 100644 f5acdaa... 9b49e78... M	drivers/pwm/core.c
:100644 100644 112b314... 70756f2... M	include/linux/pwm.h
 Documentation/devicetree/bindings/pwm/pwm.txt |   18 +++++++++++++++---
 drivers/pwm/core.c                            |   25 +++++++++++++++++++++++++
 include/linux/pwm.h                           |   12 ++++++++++++
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm.txt b/Documentation/devicetree/bindings/pwm/pwm.txt
index 73ec962..04b0dc4 100644
--- a/Documentation/devicetree/bindings/pwm/pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm.txt
@@ -37,10 +37,22 @@ device:
 		pwm-names = "backlight";
 	};
 
+Note that in the example above, specifying the "pwm-names" is redundant
+because the name "backlight" would be used as fallback anyway.
+
 pwm-specifier typically encodes the chip-relative PWM number and the PWM
-period in nanoseconds. Note that in the example above, specifying the
-"pwm-names" is redundant because the name "backlight" would be used as
-fallback anyway.
+period in nanoseconds.
+
+Optionally, the pwm-specifier can encode a number of flags in a third cell:
+- bit 0: PWM signal polarity (0: normal polarity, 1: inverse polarity)
+
+Example with optional PWM specifier for inverse polarity
+
+	bl: backlight {
+		pwms = <&pwm 0 5000000 1>;
+		pwm-names = "backlight";
+	};
+
 
 2) PWM controller nodes
 -----------------------
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index f5acdaa..9b49e78 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -129,6 +129,31 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 	return 0;
 }
 
+struct pwm_device *
+of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
+{
+	struct pwm_device *pwm;
+
+	if (pc->of_pwm_n_cells < 3)
+		return ERR_PTR(-EINVAL);
+
+	if (args->args[0] >= pc->npwm)
+		return ERR_PTR(-EINVAL);
+
+	pwm = pwm_request_from_chip(pc, args->args[0], NULL);
+	if (IS_ERR(pwm))
+		return pwm;
+
+	pwm_set_period(pwm, args->args[1]);
+
+	if (args->args[2] & PWM_SPEC_POLARITY)
+		pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
+	else
+		pwm_set_polarity(pwm, PWM_POLARITY_NORMAL);
+
+	return pwm;
+}
+
 static struct pwm_device *
 of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 112b314..70756f2 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -78,6 +78,10 @@ enum {
 	PWMF_ENABLED = 1 << 1,
 };
 
+/* flags in the third cell of the DT PWM specifier */
+#define PWM_SPEC_POLARITY	(1 << 0)
+
+
 struct pwm_device {
 	const char		*label;
 	unsigned long		flags;
@@ -176,6 +180,8 @@ void pwm_put(struct pwm_device *pwm);
 
 struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer);
 void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
+struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
+		const struct of_phandle_args *args);
 #else
 static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
 {
@@ -223,6 +229,12 @@ static inline struct pwm_device *devm_pwm_get(struct device *dev,
 static inline void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
 {
 }
+
+static inline struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
+		const struct of_phandle_args *args)
+{
+	return ERR_PTR(-ENODEV);
+}
 #endif
 
 struct pwm_lookup {
-- 
1.7.0.4

