Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1ITPr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:47:29 -0400
Received: from home.keithp.com ([63.227.221.253]:56448 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1ITPr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:47:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: Enable digital port hotplug on PCH systems
Date: Tue, 20 Sep 2011 08:47:21 -0700
Message-Id: <1316533641-13478-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were relying on the BIOS to set these bits, which doesn't always
happen.

Signed-off-by: Keith Packard <keithp@keithp.com>
---

v2: set the hotplug bits in the irq post-install hook, just
like we do for pre-PCH hardware.

 drivers/gpu/drm/i915/i915_irq.c |   24 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h |    5 ++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 9cbb0cd..c22823b 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1777,6 +1777,26 @@ static void ironlake_irq_preinstall(struct drm_device *dev)
 	POSTING_READ(SDEIER);
 }
 
+/*
+ * Enable digital hotplug on the PCH, and configure the DP short pulse
+ * duration to 2ms (which is the minimum in the Display Port spec)
+ *
+ * This register is the same on all known PCH chips.
+ */
+
+static void ironlake_enable_pch_hotplug(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	u32	hotplug;
+
+	hotplug = I915_READ(PCH_PORT_HOTPLUG);
+	hotplug &= ~(PORTD_PULSE_DURATION_MASK|PORTC_PULSE_DURATION_MASK|PORTB_PULSE_DURATION_MASK);
+	hotplug |= PORTD_HOTPLUG_ENABLE | PORTD_PULSE_DURATION_2ms;
+	hotplug |= PORTC_HOTPLUG_ENABLE | PORTC_PULSE_DURATION_2ms;
+	hotplug |= PORTB_HOTPLUG_ENABLE | PORTB_PULSE_DURATION_2ms;
+	I915_WRITE(PCH_PORT_HOTPLUG, hotplug);
+}
+
 static int ironlake_irq_postinstall(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
@@ -1839,6 +1859,8 @@ static int ironlake_irq_postinstall(struct drm_device *dev)
 	I915_WRITE(SDEIER, hotplug_mask);
 	POSTING_READ(SDEIER);
 
+	ironlake_enable_pch_hotplug(dev);
+
 	if (IS_IRONLAKE_M(dev)) {
 		/* Clear & enable PCU event interrupts */
 		I915_WRITE(DEIIR, DE_PCU_EVENT);
@@ -1896,6 +1918,8 @@ static int ivybridge_irq_postinstall(struct drm_device *dev)
 	I915_WRITE(SDEIER, hotplug_mask);
 	POSTING_READ(SDEIER);
 
+	ironlake_enable_pch_hotplug(dev);
+
 	return 0;
 }
 
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
-- 
1.7.6.3

