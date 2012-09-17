Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2IQAux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33414 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab2IQAtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:42 -0400
Message-Id: <20120917003638.539650687@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 089/135] drm/i915: SDVO hotplug have different interrupt status bits for
 i915/i965/g4x
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

I had to make substantial changes to this one, so please review!

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 084b612ecf8e59973576b2f644e6949609c79375 upstream.

Note that gen3 is the only platform where we've got the bit
definitions right, hence the workaround of disabling sdvo hotplug
support on i945g/gm is not due to misdiagnosis of broken hotplug irq
handling ...

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: add some blurb about sdvo hotplug fail on i945g/gm I've
wondered about while reviewing.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2:
 - Adjust context
 - Handle all three cases in i915_driver_irq_postinstall() as there
   are not separate functions for gen3 and gen4+
 - Carry on using IS_SDVOB() in intel_sdvo_init()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2006,10 +2006,22 @@ static int i915_driver_irq_postinstall(s
 			hotplug_en |= HDMIC_HOTPLUG_INT_EN;
 		if (dev_priv->hotplug_supported_mask & HDMID_HOTPLUG_INT_STATUS)
 			hotplug_en |= HDMID_HOTPLUG_INT_EN;
-		if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS)
-			hotplug_en |= SDVOC_HOTPLUG_INT_EN;
-		if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS)
-			hotplug_en |= SDVOB_HOTPLUG_INT_EN;
+		if (IS_G4X(dev)) {
+			if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS_G4X)
+				hotplug_en |= SDVOC_HOTPLUG_INT_EN;
+			if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS_G4X)
+				hotplug_en |= SDVOB_HOTPLUG_INT_EN;
+		} else if (IS_GEN4(dev)) {
+			if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS_I965)
+				hotplug_en |= SDVOC_HOTPLUG_INT_EN;
+			if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS_I965)
+				hotplug_en |= SDVOB_HOTPLUG_INT_EN;
+		} else {
+			if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS_I915)
+				hotplug_en |= SDVOC_HOTPLUG_INT_EN;
+			if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS_I915)
+				hotplug_en |= SDVOB_HOTPLUG_INT_EN;
+		}
 		if (dev_priv->hotplug_supported_mask & CRT_HOTPLUG_INT_STATUS) {
 			hotplug_en |= CRT_HOTPLUG_INT_EN;
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1419,14 +1419,20 @@
 #define   DPC_HOTPLUG_INT_STATUS		(1 << 28)
 #define   HDMID_HOTPLUG_INT_STATUS		(1 << 27)
 #define   DPD_HOTPLUG_INT_STATUS		(1 << 27)
+/* CRT/TV common between gen3+ */
 #define   CRT_HOTPLUG_INT_STATUS		(1 << 11)
 #define   TV_HOTPLUG_INT_STATUS			(1 << 10)
 #define   CRT_HOTPLUG_MONITOR_MASK		(3 << 8)
 #define   CRT_HOTPLUG_MONITOR_COLOR		(3 << 8)
 #define   CRT_HOTPLUG_MONITOR_MONO		(2 << 8)
 #define   CRT_HOTPLUG_MONITOR_NONE		(0 << 8)
-#define   SDVOC_HOTPLUG_INT_STATUS		(1 << 7)
-#define   SDVOB_HOTPLUG_INT_STATUS		(1 << 6)
+/* SDVO is different across gen3/4 */
+#define   SDVOC_HOTPLUG_INT_STATUS_G4X		(1 << 3)
+#define   SDVOB_HOTPLUG_INT_STATUS_G4X		(1 << 2)
+#define   SDVOC_HOTPLUG_INT_STATUS_I965		(3 << 4)
+#define   SDVOB_HOTPLUG_INT_STATUS_I965		(3 << 2)
+#define   SDVOC_HOTPLUG_INT_STATUS_I915		(1 << 7)
+#define   SDVOB_HOTPLUG_INT_STATUS_I915		(1 << 6)
 
 /* SDVO port control */
 #define SDVOB			0x61140
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2514,6 +2514,7 @@ bool intel_sdvo_init(struct drm_device *
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_encoder *intel_encoder;
 	struct intel_sdvo *intel_sdvo;
+	u32 hotplug_mask;
 	int i;
 
 	intel_sdvo = kzalloc(sizeof(struct intel_sdvo), GFP_KERNEL);
@@ -2544,10 +2545,18 @@ bool intel_sdvo_init(struct drm_device *
 		}
 	}
 
-	if (IS_SDVOB(sdvo_reg))
-		dev_priv->hotplug_supported_mask |= SDVOB_HOTPLUG_INT_STATUS;
-	else
-		dev_priv->hotplug_supported_mask |= SDVOC_HOTPLUG_INT_STATUS;
+	hotplug_mask = 0;
+	if (IS_G4X(dev)) {
+		hotplug_mask = IS_SDVOB(sdvo_reg) ?
+			SDVOB_HOTPLUG_INT_STATUS_G4X : SDVOC_HOTPLUG_INT_STATUS_G4X;
+	} else if (IS_GEN4(dev)) {
+		hotplug_mask = IS_SDVOB(sdvo_reg) ?
+			SDVOB_HOTPLUG_INT_STATUS_I965 : SDVOC_HOTPLUG_INT_STATUS_I965;
+	} else {
+		hotplug_mask = IS_SDVOB(sdvo_reg) ?
+			SDVOB_HOTPLUG_INT_STATUS_I915 : SDVOC_HOTPLUG_INT_STATUS_I915;
+	}
+	dev_priv->hotplug_supported_mask |= hotplug_mask;
 
 	drm_encoder_helper_add(&intel_encoder->base, &intel_sdvo_helper_funcs);
 


