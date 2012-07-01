Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab2GASWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47008 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab2GASQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:41 -0400
Message-Id: <20120701172011.654681357@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 35/48] drm/i915: Refactor the deferred PM_IIR handling into a single
 function
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit fc6826d1dcd65f3d1e9a5377678882e4e08f02be upstream.

This function, along with the registers and deferred work hander, are
all shared with SandyBridge, IvyBridge and their variants. So remove the
duplicate code into a single function.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context; drop changes for Valley View]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_irq.c |   70 +++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -424,6 +424,31 @@
 	mutex_unlock(&dev_priv->dev->struct_mutex);
 }
 
+static void gen6_queue_rps_work(struct drm_i915_private *dev_priv,
+				u32 pm_iir)
+{
+	unsigned long flags;
+
+	/*
+	 * IIR bits should never already be set because IMR should
+	 * prevent an interrupt from being shown in IIR. The warning
+	 * displays a case where we've unsafely cleared
+	 * dev_priv->pm_iir. Although missing an interrupt of the same
+	 * type is not a problem, it displays a problem in the logic.
+	 *
+	 * The mask bit in IMR is cleared by rps_work.
+	 */
+
+	spin_lock_irqsave(&dev_priv->rps_lock, flags);
+	WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
+	dev_priv->pm_iir |= pm_iir;
+	I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
+	POSTING_READ(GEN6_PMIMR);
+	spin_unlock_irqrestore(&dev_priv->rps_lock, flags);
+
+	queue_work(dev_priv->wq, &dev_priv->rps_work);
+}
+
 static void pch_irq_handler(struct drm_device *dev, u32 pch_iir)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
@@ -529,16 +554,8 @@
 		pch_irq_handler(dev, pch_iir);
 	}
 
-	if (pm_iir & GEN6_PM_DEFERRED_EVENTS) {
-		unsigned long flags;
-		spin_lock_irqsave(&dev_priv->rps_lock, flags);
-		WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
-		dev_priv->pm_iir |= pm_iir;
-		I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
-		POSTING_READ(GEN6_PMIMR);
-		spin_unlock_irqrestore(&dev_priv->rps_lock, flags);
-		queue_work(dev_priv->wq, &dev_priv->rps_work);
-	}
+	if (pm_iir & GEN6_PM_DEFERRED_EVENTS)
+		gen6_queue_rps_work(dev_priv, pm_iir);
 
 	/* should clear PCH hotplug event before clear CPU irq */
 	I915_WRITE(SDEIIR, pch_iir);
@@ -634,25 +651,8 @@
 		i915_handle_rps_change(dev);
 	}
 
-	if (IS_GEN6(dev) && pm_iir & GEN6_PM_DEFERRED_EVENTS) {
-		/*
-		 * IIR bits should never already be set because IMR should
-		 * prevent an interrupt from being shown in IIR. The warning
-		 * displays a case where we've unsafely cleared
-		 * dev_priv->pm_iir. Although missing an interrupt of the same
-		 * type is not a problem, it displays a problem in the logic.
-		 *
-		 * The mask bit in IMR is cleared by rps_work.
-		 */
-		unsigned long flags;
-		spin_lock_irqsave(&dev_priv->rps_lock, flags);
-		WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
-		dev_priv->pm_iir |= pm_iir;
-		I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
-		POSTING_READ(GEN6_PMIMR);
-		spin_unlock_irqrestore(&dev_priv->rps_lock, flags);
-		queue_work(dev_priv->wq, &dev_priv->rps_work);
-	}
+	if (IS_GEN6(dev) && pm_iir & GEN6_PM_DEFERRED_EVENTS)
+		gen6_queue_rps_work(dev_priv, pm_iir);
 
 	/* should clear PCH hotplug event before clear CPU irq */
 	I915_WRITE(SDEIIR, pch_iir);


