Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2GIOtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:49:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319Ab2GIOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:59 -0400
Message-Id: <20120709143119.284321581@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 18/48] drm/i915: kick any firmware framebuffers before claiming the gtt
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9f846a16d213523fbe6daea17e20df6b8ac5a1e5 upstream.

Especially vesafb likes to map everything as uc- (yikes), and if that
mapping hangs around still while we try to map the gtt as wc the
kernel will downgrade our request to uc-, resulting in abyssal
performance.

Unfortunately we can't do this as early as readon does (i.e. as the
first thing we do when initializing the hw) because our fb/mmio space
region moves around on a per-gen basis. So I've had to move it below
the gtt initialization, but that seems to work, too. The important
thing is that we do this before we set up the gtt wc mapping.

Now an altogether different question is why people compile their
kernels with vesafb enabled, but I guess making things just work isn't
bad per se ...

v2:
- s/radeondrmfb/inteldrmfb/
- fix up error handling

v3: Kill #ifdef X86, this is Intel after all. Noticed by Ben Widawsky.

v4: Jani Nikula complained about the pointless bool primary
initialization.

v5: Don't oops if we can't allocate, noticed by Chris Wilson.

v6: Resolve conflicts with agp rework and fixup whitespace.

This is commit e188719a2891f01b3100d in drm-next.

Backport to 3.5 -fixes queue requested by Dave Airlie - due to grub
using vesa on fedora their initrd seems to load vesafb before loading
the real kms driver. So tons more people actually experience a
dead-slow gpu. Hence also the Cc: stable.

Reported-and-tested-by: "Kilarski, Bernard R" <bernard.r.kilarski@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_dma.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1890,6 +1890,27 @@ ips_ping_for_i915_load(void)
 	}
 }
 
+static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
+{
+	struct apertures_struct *ap;
+	struct pci_dev *pdev = dev_priv->dev->pdev;
+	bool primary;
+
+	ap = alloc_apertures(1);
+	if (!ap)
+		return;
+
+	ap->ranges[0].base = dev_priv->dev->agp->base;
+	ap->ranges[0].size =
+		dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
+	primary =
+		pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
+
+	remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
+
+	kfree(ap);
+}
+
 /**
  * i915_driver_load - setup chip and create an initial config
  * @dev: DRM device
@@ -1927,6 +1948,15 @@ int i915_driver_load(struct drm_device *
 		goto free_priv;
 	}
 
+	dev_priv->mm.gtt = intel_gtt_get();
+	if (!dev_priv->mm.gtt) {
+		DRM_ERROR("Failed to initialize GTT\n");
+		ret = -ENODEV;
+		goto put_bridge;
+	}
+
+	i915_kick_out_firmware_fb(dev_priv);
+
 	/* overlay on gen2 is broken and can't address above 1G */
 	if (IS_GEN2(dev))
 		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(30));
@@ -1950,13 +1980,6 @@ int i915_driver_load(struct drm_device *
 		goto put_bridge;
 	}
 
-	dev_priv->mm.gtt = intel_gtt_get();
-	if (!dev_priv->mm.gtt) {
-		DRM_ERROR("Failed to initialize GTT\n");
-		ret = -ENODEV;
-		goto out_rmmap;
-	}
-
 	agp_size = dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
 
 	dev_priv->mm.gtt_mapping =


