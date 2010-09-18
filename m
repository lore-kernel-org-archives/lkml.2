Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0IRTRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:17:39 -0400
Received: from kroah.org ([198.145.64.141]:43967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0IRTQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:36 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.911201661@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [124/129] drm/i915: Allocate the PCI resource for the MCHBAR
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit a25c25c2a2aa55e609099a9f74453c518aec29a6 upstream.

We were failing when trying to allocate the resource for MMIO of the
MCHBAR because we forgot to specify what type of resource we wanted.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -883,7 +883,7 @@ intel_alloc_mchbar_resource(struct drm_d
 	int reg = IS_I965G(dev) ? MCHBAR_I965 : MCHBAR_I915;
 	u32 temp_lo, temp_hi = 0;
 	u64 mchbar_addr;
-	int ret = 0;
+	int ret;
 
 	if (IS_I965G(dev))
 		pci_read_config_dword(dev_priv->bridge_dev, reg + 4, &temp_hi);
@@ -893,22 +893,23 @@ intel_alloc_mchbar_resource(struct drm_d
 	/* If ACPI doesn't have it, assume we need to allocate it ourselves */
 #ifdef CONFIG_PNP
 	if (mchbar_addr &&
-	    pnp_range_reserved(mchbar_addr, mchbar_addr + MCHBAR_SIZE)) {
-		ret = 0;
-		goto out;
-	}
+	    pnp_range_reserved(mchbar_addr, mchbar_addr + MCHBAR_SIZE))
+		return 0;
 #endif
 
 	/* Get some space for it */
-	ret = pci_bus_alloc_resource(dev_priv->bridge_dev->bus, &dev_priv->mch_res,
+	dev_priv->mch_res.name = "i915 MCHBAR";
+	dev_priv->mch_res.flags = IORESOURCE_MEM;
+	ret = pci_bus_alloc_resource(dev_priv->bridge_dev->bus,
+				     &dev_priv->mch_res,
 				     MCHBAR_SIZE, MCHBAR_SIZE,
 				     PCIBIOS_MIN_MEM,
-				     0,   pcibios_align_resource,
+				     0, pcibios_align_resource,
 				     dev_priv->bridge_dev);
 	if (ret) {
 		DRM_DEBUG_DRIVER("failed bus alloc: %d\n", ret);
 		dev_priv->mch_res.start = 0;
-		goto out;
+		return ret;
 	}
 
 	if (IS_I965G(dev))
@@ -917,8 +918,7 @@ intel_alloc_mchbar_resource(struct drm_d
 
 	pci_write_config_dword(dev_priv->bridge_dev, reg,
 			       lower_32_bits(dev_priv->mch_res.start));
-out:
-	return ret;
+	return 0;
 }
 
 /* Setup MCHBAR if possible, return true if we should disable it again */


