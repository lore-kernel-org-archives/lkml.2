Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab1CAWYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:24:22 -0500
Received: from vs1.gondor.com ([78.47.100.202]:50692 "EHLO
	mail.moria.gondor.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756103Ab1CAWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:24:21 -0500
Date: Tue, 1 Mar 2011 23:24:16 +0100
From: Jan Niehusmann <jan@gondor.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: fix memory corruption with GM965 and >4GB RAM
Message-ID: <20110301222416.GA3526@x61s.reliablesolutions.de>
References: <20110223233022.GA3439@x61s.reliablesolutions.de>
 <20110225123056.GA3759@x61s.reliablesolutions.de>
 <b9dded$i2gkhr@orsmga002.jf.intel.com>
 <20110225211646.GA6837@x61s.reliablesolutions.de>
 <b9dded$i2hik6@orsmga002.jf.intel.com>
 <20110225230527.GC3601@viiv.ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225230527.GC3601@viiv.ffwll.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 12:05:27AM +0100, Daniel Vetter wrote:
> Actually, on style points I prefer your patch: The hw status page is
> allocated with drm_pci_alloc which calls dma_alloc_coherent, so setting
> the coherent mask is sufficient. The dma mask set in the gtt is
> essentially useless, because we call get_user_pages on everything anyway
> (in gem - iirc agp uses it). I just think it's confusing to limit the
> general dma mask and continue to happily map pages above 4G.

Indeed, setting dma_alloc_coherent should be sufficient, AFAIKT. After
all, only the HWS seems to be affected, which is allocated with
drm_pci_alloc, which in turn uses dma_alloc_coherent.

I just tried the patch below, it also works for me (as expected). Added
the comment because otherwise it wouldn't be obvious why the mask gets
set to 32 bit.

What I don't know is if really only Broadwater and Crestline chips are
affected. The tests were done with a Crestline one. But I think it's a
fair guess that the bug would have been noticed earlier if more recent
chips were affected, as >4GB RAM have become much more common since then.

Signed-off-by: Jan Niehusmann <jan@gondor.com>

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 17bd766..1961580 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1895,6 +1895,12 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (IS_GEN2(dev))
 		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(30));
 
+	/* 965GM sometimes incorrectly writes to hardware status page (HWS)
+	 * using 32bit addressing, overwriting memory if HWS is located
+	 * above 4GB. */
+	if (IS_BROADWATER(dev) || IS_CRESTLINE(dev))
+		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(32));
+
 	mmio_bar = IS_GEN2(dev) ? 1 : 0;
 	dev_priv->regs = pci_iomap(dev->pdev, mmio_bar, 0);
 	if (!dev_priv->regs) {
