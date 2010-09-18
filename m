Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0IRTQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:40 -0400
Received: from kroah.org ([198.145.64.141]:43973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302Ab0IRTQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:36 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:08 2010
Message-Id: <20100918191307.994956720@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [125/129] drm/i915: overlay on gen2 cant address above 1G
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9f82d23846146990d475f6753be733e55788d88d upstream.

So set the coherent dma mask accordingly. This dma mask is only used
for physical objects, so it won't really matter allocation-wise.

Now this never really surfaced because sane 32bit kernels only have 1G
of lowmem. But some eager testers (distros?) still carry around the patch
to adjust lowmem via a kconfig option. And the kernel seems to favour
high allocations on boot-up, hence the overlay blowing up reliably.

Because the patch is tiny and nicely shows how broken gen2 is it's imho
worth to merge despite the fact that mucking around with the lowmem/
highmem division is (no longer) supported.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=28318
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -2079,6 +2079,10 @@ int i915_driver_load(struct drm_device *
 		goto free_priv;
 	}
 
+	/* overlay on gen2 is broken and can't address above 1G */
+	if (IS_GEN2(dev))
+		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(30));
+
 	dev_priv->regs = ioremap(base, size);
 	if (!dev_priv->regs) {
 		DRM_ERROR("failed to map registers\n");


