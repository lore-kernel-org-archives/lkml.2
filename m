Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab2J2R4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:56:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab2J2R4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:56:31 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH] pwm: Device tree support for PWM polarity.
Date: Mon, 29 Oct 2012 23:10:27 +0530
Message-ID: <1351532427-19881-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip, Avinash" <avinashphilip@ti.com>

Adds support for 3rd cell in pwm-specifier. PWM polarity is encoded in
device tree support in bit encoded form. Platforms require polarity of
PWM device initialized during PWM device initialization has to encode
polarity in 3rd cell of pwm-specifier.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 73ec962... e522c59... M	Documentation/devicetree/bindings/pwm/pwm.txt
:100644 100644 f5acdaa... 1c6d50b... M	drivers/pwm/core.c
:100644 100644 112b314... d77c5b3... M	include/linux/pwm.h
 Documentation/devicetree/bindings/pwm/pwm.txt |   22 +++++++++++++++++++---
 drivers/pwm/core.c                            |   13 ++++++++++++-
 include/linux/pwm.h                           |    7 +++++++
 3 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm.txt b/Documentation/devicetree/bindings/pwm/pwm.txt
index 73ec962..e522c59 100644
--- a/Documentation/devicetree/bindings/pwm/pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm.txt
@@ -37,10 +37,26 @@ device:
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
+Optional pwm-specifier can be encoded in 3rd cell in bit encoded form.
+ -------------------------------------------------------------
+|     Property   |  BIT position | Encoding                   |
+|-------------------------------------------------------------|
+| Polarity       |   0           | Set   -> Polarity inversed |
+|                |               | Clear -> Polarity Normal   |
+ -------------------------------------------------------------
+
+Exapmple with optional PWM specifier for inversed polarity
+
+	bl: backlight {
+		pwms = <&pwm 0 5000000 1>;
+		pwm-names = "backlight";
+	};
+
 
 2) PWM controller nodes
 -----------------------
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index f5acdaa..1c6d50b 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -146,6 +146,15 @@ of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 
 	pwm_set_period(pwm, args->args[1]);
 
+	if (pc->of_pwm_n_cells > 2) {
+		enum pwm_polarity polarity;
+
+		/* Initialize polarity of PWM device */
+		polarity = args->args[2] & POLARITY_BIT ?
+			PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;
+		pwm_set_polarity(pwm, polarity);
+	}
+
 	return pwm;
 }
 
@@ -156,7 +165,9 @@ static void of_pwmchip_add(struct pwm_chip *chip)
 
 	if (!chip->of_xlate) {
 		chip->of_xlate = of_pwm_simple_xlate;
-		chip->of_pwm_n_cells = 2;
+
+		if (chip->of_pwm_n_cells != 3)
+			chip->of_pwm_n_cells = 2;
 	}
 
 	of_node_get(chip->dev->of_node);
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 112b314..d77c5b3 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -78,6 +78,13 @@ enum {
 	PWMF_ENABLED = 1 << 1,
 };
 
+/*
+ * DT Platform property support.
+ * POLARITY - set bit 0 in DT platform property
+ */
+
+#define POLARITY_BIT	BIT(0)
+
 struct pwm_device {
 	const char		*label;
 	unsigned long		flags;
-- 
1.7.9.5

