Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1DZM0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57398 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1DZM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:42 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 14/21] drm/i915: overlay on gen2 can't address above 1G" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:39 +0200
Message-Id: <1303820799-3809-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 14/21] drm/i915: overlay on gen2 can't address above 1G

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 4623da5a05f8e55ee3d7b09c63b53f6a94d9e998 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Mon, 30 Aug 2010 21:25:23 +0200
Subject: [PATCH 14/21] drm/i915: overlay on gen2 can't address above 1G

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
Cc: stable@kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[bwh: Backport to 2.6.33]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 2b2adb5..c93c98a 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1407,6 +1407,10 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		goto free_priv;
 	}

+	/* overlay on gen2 is broken and can't address above 1G */
+	if (IS_GEN2(dev))
+		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(30));
+
 	dev_priv->regs = ioremap(base, size);
 	if (!dev_priv->regs) {
 		DRM_ERROR("failed to map registers\n");
--
1.7.0.4

