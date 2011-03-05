Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583Ab1CEBDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:03:53 -0500
Received: from kroah.org ([198.145.64.141]:50456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760558Ab1CEBAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.450183221@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        daniel.vetter@ffwll.ch, chris@chris-wilson.co.uk,
        Jan Niehusmann <jan@gondor.com>
Subject: [60/73] drm/i915: fix memory corruption with GM965 and >4GB RAM
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Niehusmann <jan@gondor.com>

commit 6927faf30920b8c03dfa007e732642a1f1f20089 upstream.

On a Thinkpad x61s, I noticed some memory corruption when
plugging/unplugging the external VGA connection. The symptoms are that
4 bytes at the beginning of a page get overwritten by zeroes.
The address of the corruption varies when rebooting the machine, but
stays constant while it's running (so it's possible to repeatedly write
some data and then corrupt it again by plugging the cable).

Further investigation revealed that the corrupted address is
(dev_priv->status_page_dmah->busaddr & 0xffffffff), ie. the beginning of
the hardware status page of the i965 graphics card, cut to 32 bits.

So it seems that for some memory access, the hardware uses only 32 bit
addressing. If the hardware status page is located >4GB, this
corrupts unrelated memory.

Signed-off-by: Jan Niehusmann <jan@gondor.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1943,6 +1943,17 @@ int i915_driver_load(struct drm_device *
 	if (IS_GEN2(dev))
 		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(30));
 
+	/* 965GM sometimes incorrectly writes to hardware status page (HWS)
+	 * using 32bit addressing, overwriting memory if HWS is located
+	 * above 4GB.
+	 *
+	 * The documentation also mentions an issue with undefined
+	 * behaviour if any general state is accessed within a page above 4GB,
+	 * which also needs to be handled carefully.
+	 */
+	if (IS_BROADWATER(dev) || IS_CRESTLINE(dev))
+		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(32));
+
 	dev_priv->regs = ioremap(base, size);
 	if (!dev_priv->regs) {
 		DRM_ERROR("failed to map registers\n");


