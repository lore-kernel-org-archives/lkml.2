Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1G0Vsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:12903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab1G0Vsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258250"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: d.haid@gogi.tv, alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [44/99] drm/radeon/kms: fix for radeon on systems >4GB without
Message-Id: <20110727214843.1E2CF2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel Haid <d.haid@gogi.tv>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_device.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/radeon_device.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_device.c
@@ -645,6 +645,7 @@ int radeon_device_init(struct radeon_dev
 	dma_bits = rdev->need_dma32 ? 32 : 40;
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
+		rdev->need_dma32 = true;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}
 
