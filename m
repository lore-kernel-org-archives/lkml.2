Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2GYMi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:38:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53160 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab2GYMiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:38:54 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <rpurdie@rpsys.net>
CC: <broonie@opensource.wolfsonmicro.com>, <thierry.reding@avionic-design.de>,
        <shawn.guo@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH] pwm_backlight: Add device tree support for Low Threshold Brightness
Date: Wed, 25 Jul 2012 17:54:02 +0530
Message-ID: <1343219042-4371-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Low Threshold Brightness should be configured to have a linear relation
in brightness scale. This patch adds device tree support for low
threshold brightness as optional one for pwm_backlight.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 1e4fc72... 5c54380... M	Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
:100644 100644 995f016... 4965408... M	drivers/video/backlight/pwm_bl.c
 .../bindings/video/backlight/pwm-backlight.txt     |   21 ++++++++++++++++++++
 drivers/video/backlight/pwm_bl.c                   |    5 ++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..5c54380 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,8 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - low_threshold_brightness: brightness threshold low level. (get linear
+		 scales in brightness in low end of brightness levels)
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -26,3 +28,22 @@ Example:
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
 	};
+
+Example for brightness_threshold_level:
+
+	backlight {
+		compatible	= "pwm-backlight";
+		pwms = <&pwm 0 50000>;
+
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+		low_threshold_brightness = <50>;
+	};
+};
+Note:
+Low threshold support is required to have linear brightness scale from
+0 to max. For some panels, backlight absent on low end of brightness
+scale. So support for Low Threshold been required. So that the scale of
+brightness changed from Low Threshold to Max in scales defined in
+brightness-levels. In this example 20% maximum brightness scale should
+be required to turn on panel backlight.
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 995f016..4965408 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -143,6 +143,11 @@ static int pwm_backlight_parse_dt(struct device *dev,
 
 		data->dft_brightness = value;
 		data->max_brightness--;
+
+		ret = of_property_read_u32(node, "low_threshold_brightness",
+					   &value);
+		if (!ret)
+			data->lth_brightness = value;
 	}
 
 	/*
-- 
1.7.1

