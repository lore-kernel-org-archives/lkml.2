Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689Ab2EOCSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53128 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964911Ab2EOCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 054/179] drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu
Date: Mon, 14 May 2012 22:12:30 -0400
Message-ID: <1337048075-6132-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Haid <d.haid@gogi.tv>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
cc: stable@kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 2008481..feff1c8 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -641,6 +641,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	dma_bits = rdev->need_dma32 ? 32 : 40;
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
+		rdev->need_dma32 = true;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}
 
-- 
1.7.9.6

