Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0LHBAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:17 -0500
Received: from kroah.org ([198.145.64.141]:48743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0LHBAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:15 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.647134517@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [083/289] drm/i915: Update hotplug interrupts register definitions for Sandybridge
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yuanhan Liu <yuanhan.liu@intel.com>

commit 2d7b8366ae4a9ec2183c30e432a4a9a495c82bcd upstream.

On Sandybridge, the bit definition for hotplug on SDE has changed, so
update the code to new definition.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=30378
Signed-off-by: Yuanhan Liu <yuanhan.liu@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |   21 ++++++++++++++++-----
 drivers/gpu/drm/i915/i915_reg.h |    4 ++++
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -310,6 +310,7 @@ irqreturn_t ironlake_irq_handler(struct
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 	int ret = IRQ_NONE;
 	u32 de_iir, gt_iir, de_ier, pch_iir;
+	u32 hotplug_mask;
 	struct drm_i915_master_private *master_priv;
 	struct intel_ring_buffer *render_ring = &dev_priv->render_ring;
 
@@ -325,6 +326,11 @@ irqreturn_t ironlake_irq_handler(struct
 	if (de_iir == 0 && gt_iir == 0 && pch_iir == 0)
 		goto done;
 
+	if (HAS_PCH_CPT(dev))
+		hotplug_mask = SDE_HOTPLUG_MASK_CPT;
+	else
+		hotplug_mask = SDE_HOTPLUG_MASK;
+
 	ret = IRQ_HANDLED;
 
 	if (dev->primary->master) {
@@ -366,10 +372,8 @@ irqreturn_t ironlake_irq_handler(struct
 		drm_handle_vblank(dev, 1);
 
 	/* check event from PCH */
-	if ((de_iir & DE_PCH_EVENT) &&
-	    (pch_iir & SDE_HOTPLUG_MASK)) {
+	if ((de_iir & DE_PCH_EVENT) && (pch_iir & hotplug_mask))
 		queue_work(dev_priv->wq, &dev_priv->hotplug_work);
-	}
 
 	if (de_iir & DE_PCU_EVENT) {
 		I915_WRITE16(MEMINTRSTS, I915_READ(MEMINTRSTS));
@@ -1424,8 +1428,7 @@ static int ironlake_irq_postinstall(stru
 	u32 display_mask = DE_MASTER_IRQ_CONTROL | DE_GSE | DE_PCH_EVENT |
 			   DE_PLANEA_FLIP_DONE | DE_PLANEB_FLIP_DONE;
 	u32 render_mask = GT_PIPE_NOTIFY | GT_BSD_USER_INTERRUPT;
-	u32 hotplug_mask = SDE_CRT_HOTPLUG | SDE_PORTB_HOTPLUG |
-			   SDE_PORTC_HOTPLUG | SDE_PORTD_HOTPLUG;
+	u32 hotplug_mask;
 
 	dev_priv->irq_mask_reg = ~display_mask;
 	dev_priv->de_irq_enable_reg = display_mask | DE_PIPEA_VBLANK | DE_PIPEB_VBLANK;
@@ -1450,6 +1453,14 @@ static int ironlake_irq_postinstall(stru
 	I915_WRITE(GTIER, dev_priv->gt_irq_enable_reg);
 	(void) I915_READ(GTIER);
 
+	if (HAS_PCH_CPT(dev)) {
+		hotplug_mask = SDE_CRT_HOTPLUG_CPT | SDE_PORTB_HOTPLUG_CPT  |
+			       SDE_PORTC_HOTPLUG_CPT | SDE_PORTD_HOTPLUG_CPT ;
+	} else {
+		hotplug_mask = SDE_CRT_HOTPLUG | SDE_PORTB_HOTPLUG |
+			       SDE_PORTC_HOTPLUG | SDE_PORTD_HOTPLUG;
+	}
+
 	dev_priv->pch_irq_mask_reg = ~hotplug_mask;
 	dev_priv->pch_irq_enable_reg = hotplug_mask;
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2551,6 +2551,10 @@
 #define SDE_PORTD_HOTPLUG_CPT	(1 << 23)
 #define SDE_PORTC_HOTPLUG_CPT	(1 << 22)
 #define SDE_PORTB_HOTPLUG_CPT	(1 << 21)
+#define SDE_HOTPLUG_MASK_CPT	(SDE_CRT_HOTPLUG_CPT |		\
+				 SDE_PORTD_HOTPLUG_CPT |	\
+				 SDE_PORTC_HOTPLUG_CPT |	\
+				 SDE_PORTB_HOTPLUG_CPT)
 
 #define SDEISR  0xc4000
 #define SDEIMR  0xc4004


