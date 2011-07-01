Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1GAJSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:18:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34966 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1GAJSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:18:39 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 10/10] drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu" has been added to staging queue
Date: Fri,  1 Jul 2011 10:18:32 +0100
Message-Id: <1309511912-3185-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 10/10] drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 2e49607f2fdfe966ea6caae27c1e7547b917ccb7 Mon Sep 17 00:00:00 2001
From: Daniel Haid <d.haid@gogi.tv>
Date: Wed, 8 Jun 2011 20:04:45 +1000
Subject: [PATCH 10/10] drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

commit 62fff811d73095bd95579d72f558f03c78f7914a upstream.

On my x86_64 system with >4GB of ram and swiotlb instead of
a hardware iommu (because I have a VIA chipset), the call
to pci_set_dma_mask (see below) with 40bits returns an error.

But it seems that the radeon driver is designed to have
need_dma32 = true exactly if pci_set_dma_mask is called
with 32 bits and false if it is called with 40 bits.

I have read somewhere that the default are 32 bits. So if the
call fails I suppose that need_dma32 should be set to true.

And indeed the patch fixes the problem I have had before
and which I had described here:
http://choon.net/forum/read.php?21,106131,115940

Acked-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ac47fd0..6a78b34 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -682,6 +682,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	dma_bits = rdev->need_dma32 ? 32 : 40;
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
+		rdev->need_dma32 = true;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}

--
1.7.4.1

