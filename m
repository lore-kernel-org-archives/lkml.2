Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593Ab2I1TEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:04:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030566Ab2I1TER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 205/262] drm/i915: set the right gen3 flip_done mode also at resume
Date: Fri, 28 Sep 2012 11:52:14 -0700
Message-Id: <20120928183022.337702677@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 974a3b0f9f05b748fe11f1afc31efc32aa5160cb upstream.

Currently we've only frobbed this bit at irq_init time, but did
not restore it at resume time. Move it to the gen3 clock gating
function to fix this.

Notice while reading through code.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |    3 ---
 drivers/gpu/drm/i915/intel_pm.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2626,9 +2626,6 @@ void intel_irq_init(struct drm_device *d
 			dev->driver->irq_handler = i8xx_irq_handler;
 			dev->driver->irq_uninstall = i8xx_irq_uninstall;
 		} else if (INTEL_INFO(dev)->gen == 3) {
-			/* IIR "flip pending" means done if this bit is set */
-			I915_WRITE(ECOSKPD, _MASKED_BIT_DISABLE(ECO_FLIP_DONE));
-
 			dev->driver->irq_preinstall = i915_irq_preinstall;
 			dev->driver->irq_postinstall = i915_irq_postinstall;
 			dev->driver->irq_uninstall = i915_irq_uninstall;
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3528,6 +3528,9 @@ static void gen3_init_clock_gating(struc
 
 	if (IS_PINEVIEW(dev))
 		I915_WRITE(ECOSKPD, _MASKED_BIT_ENABLE(ECO_GATING_CX_ONLY));
+
+	/* IIR "flip pending" means done if this bit is set */
+	I915_WRITE(ECOSKPD, _MASKED_BIT_DISABLE(ECO_FLIP_DONE));
 }
 
 static void i85x_init_clock_gating(struct drm_device *dev)


