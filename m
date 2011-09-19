Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab1ISWWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:22:20 -0400
Received: from home.keithp.com ([63.227.221.253]:41861 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1ISWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:19 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/9] drm/i915: Enable digital port hotplug on PCH systems
Date: Mon, 19 Sep 2011 15:21:55 -0700
Message-Id: <1316470923-27832-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were relying on the BIOS to set these bits, which doesn't always
happen.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |    5 ++++-
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 542453f..b7fbb74 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2903,12 +2903,13 @@
 #define SDEIER  0xc400c
 
 /* digital port hotplug */
-#define PCH_PORT_HOTPLUG        0xc4030
+#define PCH_PORT_HOTPLUG        0xc4030		/* SHOTPLUG_CTL */
 #define PORTD_HOTPLUG_ENABLE            (1 << 20)
 #define PORTD_PULSE_DURATION_2ms        (0)
 #define PORTD_PULSE_DURATION_4_5ms      (1 << 18)
 #define PORTD_PULSE_DURATION_6ms        (2 << 18)
 #define PORTD_PULSE_DURATION_100ms      (3 << 18)
+#define PORTD_PULSE_DURATION_MASK	(3 << 18)
 #define PORTD_HOTPLUG_NO_DETECT         (0)
 #define PORTD_HOTPLUG_SHORT_DETECT      (1 << 16)
 #define PORTD_HOTPLUG_LONG_DETECT       (1 << 17)
@@ -2917,6 +2918,7 @@
 #define PORTC_PULSE_DURATION_4_5ms      (1 << 10)
 #define PORTC_PULSE_DURATION_6ms        (2 << 10)
 #define PORTC_PULSE_DURATION_100ms      (3 << 10)
+#define PORTC_PULSE_DURATION_MASK	(3 << 10)
 #define PORTC_HOTPLUG_NO_DETECT         (0)
 #define PORTC_HOTPLUG_SHORT_DETECT      (1 << 8)
 #define PORTC_HOTPLUG_LONG_DETECT       (1 << 9)
@@ -2925,6 +2927,7 @@
 #define PORTB_PULSE_DURATION_4_5ms      (1 << 2)
 #define PORTB_PULSE_DURATION_6ms        (2 << 2)
 #define PORTB_PULSE_DURATION_100ms      (3 << 2)
+#define PORTB_PULSE_DURATION_MASK	(3 << 2)
 #define PORTB_HOTPLUG_NO_DETECT         (0)
 #define PORTB_HOTPLUG_SHORT_DETECT      (1 << 0)
 #define PORTB_HOTPLUG_LONG_DETECT       (1 << 1)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9fb4a40..54403dd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7151,6 +7151,18 @@ static void intel_setup_outputs(struct drm_device *dev)
 		I915_WRITE(PFIT_CONTROL, 0);
 	}
 
+	/* Enable digital port hotplug detect on PCH hardware */
+	if (HAS_PCH_SPLIT(dev)) {
+		u32	hotplug;
+
+		hotplug = I915_READ(PCH_PORT_HOTPLUG);
+		hotplug &= ~(PORTD_PULSE_DURATION_MASK|PORTC_PULSE_DURATION_MASK|PORTB_PULSE_DURATION_MASK);
+		hotplug |= PORTD_HOTPLUG_ENABLE | PORTD_PULSE_DURATION_2ms;
+		hotplug |= PORTC_HOTPLUG_ENABLE | PORTC_PULSE_DURATION_2ms;
+		hotplug |= PORTB_HOTPLUG_ENABLE | PORTB_PULSE_DURATION_2ms;
+		I915_WRITE(PCH_PORT_HOTPLUG, hotplug);
+	}
+
 	if (HAS_PCH_SPLIT(dev)) {
 		dpd_is_edp = intel_dpd_is_edp(dev);
 
-- 
1.7.6.3

