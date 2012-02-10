Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989Ab2BJXPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:15:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760630Ab2BJWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:05 -0500
MIME-Version: 1.0
Message-Id: <20120210222949.102085830@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: [patch 46/86] drm/i915: protect force_wake_(get|put) with the gt_lock
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9f1f46a45a681d357d1ceedecec3671a5ae957f4 upstream.

The problem this patch solves is that the forcewake accounting
necessary for register reads is protected by dev->struct_mutex. But the
hangcheck and error_capture code need to access registers without
grabbing this mutex because we hold it while waiting for the gpu.
So a new lock is required. Because currently the error_state capture
is called from the error irq handler and the hangcheck code runs from
a timer, it needs to be an irqsafe spinlock (note that the registers
used by the irq handler (neglecting the error handling part) only uses
registers that don't need the forcewake dance).

We could tune this down to a normal spinlock when we rework the
error_state capture and hangcheck code to run from a workqueue.  But
we don't have any read in a fastpath that needs forcewake, so I've
decided to not care much about overhead.

This prevents tests/gem_hangcheck_forcewake from i-g-t from killing my
snb on recent kernels - something must have slightly changed the
timings. On previous kernels it only trigger a WARN about the broken
locking.

v2: Drop the previous patch for the register writes.

v3: Improve the commit message per Chris Wilson's suggestions.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_debugfs.c |    8 ++++++--
 drivers/gpu/drm/i915/i915_dma.c     |    1 +
 drivers/gpu/drm/i915/i915_drv.c     |   18 ++++++++++++------
 drivers/gpu/drm/i915/i915_drv.h     |   10 +++++++---
 4 files changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1314,9 +1314,13 @@ static int i915_gen6_forcewake_count_inf
 	struct drm_info_node *node = (struct drm_info_node *) m->private;
 	struct drm_device *dev = node->minor->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned forcewake_count;
 
-	seq_printf(m, "forcewake count = %d\n",
-		   atomic_read(&dev_priv->forcewake_count));
+	spin_lock_irq(&dev_priv->gt_lock);
+	forcewake_count = dev_priv->forcewake_count;
+	spin_unlock_irq(&dev_priv->gt_lock);
+
+	seq_printf(m, "forcewake count = %u\n", forcewake_count);
 
 	return 0;
 }
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -2042,6 +2042,7 @@ int i915_driver_load(struct drm_device *
 	if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
 
+	spin_lock_init(&dev_priv->gt_lock);
 	spin_lock_init(&dev_priv->irq_lock);
 	spin_lock_init(&dev_priv->error_lock);
 	spin_lock_init(&dev_priv->rps_lock);
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -368,11 +368,12 @@ void __gen6_gt_force_wake_mt_get(struct
  */
 void gen6_gt_force_wake_get(struct drm_i915_private *dev_priv)
 {
-	WARN_ON(!mutex_is_locked(&dev_priv->dev->struct_mutex));
+	unsigned long irqflags;
 
-	/* Forcewake is atomic in case we get in here without the lock */
-	if (atomic_add_return(1, &dev_priv->forcewake_count) == 1)
+	spin_lock_irqsave(&dev_priv->gt_lock, irqflags);
+	if (dev_priv->forcewake_count++ == 0)
 		dev_priv->display.force_wake_get(dev_priv);
+	spin_unlock_irqrestore(&dev_priv->gt_lock, irqflags);
 }
 
 void __gen6_gt_force_wake_put(struct drm_i915_private *dev_priv)
@@ -392,10 +393,12 @@ void __gen6_gt_force_wake_mt_put(struct
  */
 void gen6_gt_force_wake_put(struct drm_i915_private *dev_priv)
 {
-	WARN_ON(!mutex_is_locked(&dev_priv->dev->struct_mutex));
+	unsigned long irqflags;
 
-	if (atomic_dec_and_test(&dev_priv->forcewake_count))
+	spin_lock_irqsave(&dev_priv->gt_lock, irqflags);
+	if (--dev_priv->forcewake_count == 0)
 		dev_priv->display.force_wake_put(dev_priv);
+	spin_unlock_irqrestore(&dev_priv->gt_lock, irqflags);
 }
 
 void __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv)
@@ -626,6 +629,7 @@ int i915_reset(struct drm_device *dev, u
 	 * need to
 	 */
 	bool need_display = true;
+	unsigned long irqflags;
 	int ret;
 
 	if (!i915_try_reset)
@@ -644,8 +648,10 @@ int i915_reset(struct drm_device *dev, u
 	case 6:
 		ret = gen6_do_reset(dev, flags);
 		/* If reset with a user forcewake, try to restore */
-		if (atomic_read(&dev_priv->forcewake_count))
+		spin_lock_irqsave(&dev_priv->gt_lock, irqflags);
+		if (dev_priv->forcewake_count)
 			dev_priv->display.force_wake_get(dev_priv);
+		spin_unlock_irqrestore(&dev_priv->gt_lock, irqflags);
 		break;
 	case 5:
 		ret = ironlake_do_reset(dev, flags);
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -286,7 +286,13 @@ typedef struct drm_i915_private {
 	int relative_constants_mode;
 
 	void __iomem *regs;
-	u32 gt_fifo_count;
+	/** gt_fifo_count and the subsequent register write are synchronized
+	 * with dev->struct_mutex. */
+	unsigned gt_fifo_count;
+	/** forcewake_count is protected by gt_lock */
+	unsigned forcewake_count;
+	/** gt_lock is also taken in irq contexts. */
+	struct spinlock gt_lock;
 
 	struct intel_gmbus {
 		struct i2c_adapter adapter;
@@ -738,8 +744,6 @@ typedef struct drm_i915_private {
 
 	struct drm_property *broadcast_rgb_property;
 	struct drm_property *force_audio_property;
-
-	atomic_t forcewake_count;
 } drm_i915_private_t;
 
 enum i915_cache_level {


