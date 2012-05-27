Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab2E0BTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:19:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab2E0BTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:19:09 -0400
Message-Id: <20120527002521.284173367@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:12 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 66/91] drm/i915: Avoid a double-read of PCH_IIR during interrupt handling
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9adab8b5a7fde248504f484e197589f3e3c922e2 upstream.

Currently the code re-reads PCH_IIR during the hotplug interrupt
processing. Not only is this a wasted read, but introduces a potential
for handling a spurious interrupt as we then may not clear all the
interrupts processed (since the re-read IIR may contains more interrupts
asserted than we clear using the result of the original read).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -424,14 +424,11 @@ static void gen6_pm_rps_work(struct work
 	mutex_unlock(&dev_priv->dev->struct_mutex);
 }
 
-static void pch_irq_handler(struct drm_device *dev)
+static void pch_irq_handler(struct drm_device *dev, u32 pch_iir)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	u32 pch_iir;
 	int pipe;
 
-	pch_iir = I915_READ(SDEIIR);
-
 	if (pch_iir & SDE_AUDIO_POWER_MASK)
 		DRM_DEBUG_DRIVER("PCH audio power change on port %d\n",
 				 (pch_iir & SDE_AUDIO_POWER_MASK) >>
@@ -529,7 +526,7 @@ static irqreturn_t ivybridge_irq_handler
 	if (de_iir & DE_PCH_EVENT_IVB) {
 		if (pch_iir & SDE_HOTPLUG_MASK_CPT)
 			queue_work(dev_priv->wq, &dev_priv->hotplug_work);
-		pch_irq_handler(dev);
+		pch_irq_handler(dev, pch_iir);
 	}
 
 	if (pm_iir & GEN6_PM_DEFERRED_EVENTS) {
@@ -629,7 +626,7 @@ static irqreturn_t ironlake_irq_handler(
 	if (de_iir & DE_PCH_EVENT) {
 		if (pch_iir & hotplug_mask)
 			queue_work(dev_priv->wq, &dev_priv->hotplug_work);
-		pch_irq_handler(dev);
+		pch_irq_handler(dev, pch_iir);
 	}
 
 	if (de_iir & DE_PCU_EVENT) {


