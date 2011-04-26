Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1DZM0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57526 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1DZM0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:53 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Jan Niehusmann <jan@gondor.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 15/21] drm/i915: fix memory corruption with GM965 and >4GB RAM" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:41 +0200
Message-Id: <1303820801-3841-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 15/21] drm/i915: fix memory corruption with GM965 and >4GB RAM

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 80b161cb0bac6dc7644776615f1cea3074b1e788 Mon Sep 17 00:00:00 2001
From: Jan Niehusmann <jan@gondor.com>
Date: Fri, 4 Mar 2011 00:28:02 +0100
Subject: [PATCH 15/21] drm/i915: fix memory corruption with GM965 and >4GB RAM

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
[bwh: Backport to 2.6.33]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index c93c98a..be27acc 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1411,6 +1411,17 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (IS_GEN2(dev))
 		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(30));

+	/* 965GM sometimes incorrectly writes to hardware status page (HWS)
+	 * using 32bit addressing, overwriting memory if HWS is located
+	 * above 4GB.
+	 *
+	 * The documentation also mentions an issue with undefined
+	 * behaviour if any general state is accessed within a page above 4GB,
+	 * which also needs to be handled carefully.
+	 */
+	if (IS_I965G(dev) && !IS_G4X(dev) && !IS_IRONLAKE(dev))
+		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(32));
+
 	dev_priv->regs = ioremap(base, size);
 	if (!dev_priv->regs) {
 		DRM_ERROR("failed to map registers\n");
--
1.7.0.4

