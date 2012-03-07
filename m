Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2CGLwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:52:37 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:35329 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2CGLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:51:00 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/9] drm/i915/intel_i2c: assign HDMI port D to pin pair 6
Date: Wed,  7 Mar 2012 19:50:43 +0800
Message-Id: <1331121050-17857-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to i915 documentation [1], "Port D" (DP/HDMI Port D) is
actually gmbus pin pair 6 (gmbus0.2:0 == 110b GPIOF), not 7 (111b).
Pin pair 7 is a reserved pair.

[1] Documentation for [DevSNB+] and [DevIBX], as found on
http://intellinuxgraphics.org

Note: the "reserved" and "disabled" pairs do not actually map to a
physical pair of pins, nor GPIO regs and shouldn't be initialized or used.
Fixing this is left for a later patch.

This bug has not been noticed for two reasons:
 1) "gmbus" mode is currently disabled - all transfers are actually using
    "bit-bang" mode which uses the GPIO port 5 (the "HDMI/DPD CTLDATA/CLK"
    pair), at register 0x5024 (defined as GPIOF i915_reg.h).
    Since this is the correct pair of pins for HDMI1, transfers succeed.

 2) Even if gmbus mode is re-enabled, the first attempted transaction
    will fail because it tries to use the wrong ("Reserved") pin pair.
    However, the driver immediately falls back again to the bit-bang
    method, which correctly uses GPIOF, so again, transfers succeed.

However, if gmbus mode is re-enabled and the GPIO fall-back mode is
disabled, then reading an attached monitor's EDID fail.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_reg.h  |    6 +++---
 drivers/gpu/drm/i915/intel_i2c.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 03c53fc..56af0df 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -697,9 +697,9 @@
 #define   GMBUS_PORT_PANEL	3
 #define   GMBUS_PORT_DPC	4 /* HDMIC */
 #define   GMBUS_PORT_DPB	5 /* SDVO, HDMIB */
-				  /* 6 reserved */
-#define   GMBUS_PORT_DPD	7 /* HDMID */
-#define   GMBUS_NUM_PORTS       8
+#define   GMBUS_PORT_DPD	6 /* HDMID */
+#define   GMBUS_PORT_RESERVED	7 /* 7 reserved */
+#define   GMBUS_NUM_PORTS	8
 #define GMBUS1			0x5104 /* command/status */
 #define   GMBUS_SW_CLR_INT	(1<<31)
 #define   GMBUS_SW_RDY		(1<<30)
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index a94e383..45ce1d2 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -157,8 +157,8 @@ intel_gpio_create(struct drm_i915_private *dev_priv, u32 pin)
 		GPIOC,
 		GPIOD,
 		GPIOE,
-		0,
 		GPIOF,
+		0,
 	};
 	struct intel_gpio *gpio;
 
@@ -377,8 +377,8 @@ int intel_setup_gmbus(struct drm_device *dev)
 		"panel",
 		"dpc",
 		"dpb",
-		"reserved",
 		"dpd",
+		"reserved",
 	};
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret, i;
-- 
1.7.7.3

