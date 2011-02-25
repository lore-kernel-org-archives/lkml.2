Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab1BYUXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:23:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:22932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873Ab1BYUW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:22:58 -0500
Message-Id: <b9dded$i2gkhr@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,227,1297065600"; 
   d="scan'208";a="606622267"
Date: Fri, 25 Feb 2011 20:22:53 +0000
To: Jan Niehusmann <jan@gondor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-gtt: fix memory corruption with GM965 and >4GB RAM
Cc: intel-gfx@lists.freedesktop.org
References: <20110223233022.GA3439@x61s.reliablesolutions.de> <20110225123056.GA3759@x61s.reliablesolutions.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110225123056.GA3759@x61s.reliablesolutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 13:30:56 +0100, Jan Niehusmann <jan@gondor.com> wrote:
> On Thu, Feb 24, 2011 at 12:30:22AM +0100, Jan Niehusmann wrote to
> linux-kernel@vger.kernel.org:
> > On a Thinkpad x61s, I noticed some memory corruption when
> > plugging/unplugging the external VGA connection.
> > 
> > Symptoms:
> > ---------
> > 
> > 4 bytes at the beginning of a page get overwritten by zeroes. 
> > The address of the corruption varies when rebooting the machine, but
> > stays constant while it's running (so it's possible to repeatedly write
> > some data and then corrupt it again by plugging the cable).
> 
> Further investigation revealed that the corrupted address is
> (dev_priv->status_page_dmah->busaddr & 0xffffffff), ie. the beginning of
> the hardware status page of the i965 graphics card, cut to 32 bits.

965GM explicitly supports 36bits of addressing in the PTE. The only
exception is that general state (part of the 3D engine) must be located in
the lower 4GiB.

Simply ignoring the upper 4bits is the wrong approach and means that the
PTE then point to random pages, and completely irrelevant to the physical
address used in the hardware status page address register.

I have been considering:

diff --git a/drivers/gpu/drm/i915/i915_dma.c
b/drivers/gpu/drm/i915/i915_dma.c
index ffa2196..268e448 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1896,6 +1896,8 @@ int i915_driver_load(struct drm_device *dev,
unsigned long
        /* overlay on gen2 is broken and can't address above 1G */
        if (IS_GEN2(dev))
                dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(30));
+       if (IS_BRROADWATER(dev) || IS_CRESTLINE(dev))
+               dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(32));
 
        mmio_bar = IS_GEN2(dev) ? 1 : 0;
        dev_priv->regs = pci_iomap(dev->pdev, mmio_bar, 0);

to prevent hitting the erratum.

However your bug looks to be:

diff --git a/drivers/gpu/drm/i915/i915_dma.c
b/drivers/gpu/drm/i915/i915_dma.c
index ffa2196..3b80507 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -66,9 +66,9 @@ static int i915_init_phys_hws(struct drm_device *dev)
 
        memset_io(ring->status_page.page_addr, 0, PAGE_SIZE);
 
-       if (INTEL_INFO(dev)->gen >= 4)
-               dev_priv->dma_status_page |= (dev_priv->dma_status_page >> 28) &
-                                            0xf0;
+       if (INTEL_INFO(dev)->gen >= 4) /* 36-bit addressing */
+               dev_priv->dma_status_page |=
+                       (dev_priv->status_page_dmah->busaddr >> 28) & 0xf0;
 
        I915_WRITE(HWS_PGA, dev_priv->dma_status_page);
        DRM_DEBUG_DRIVER("Enabled hardware status page\n");

-- 
Chris Wilson, Intel Open Source Technology Centre
