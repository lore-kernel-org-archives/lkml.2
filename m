Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1FPHBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47946 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709Ab1FPHA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:56 -0400
X-Sasl-enc: /mxNFmiUIb5fwfohUSTHL/VvQQDj8bDZ2x8JgOuPBNr/ 1308207655
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.707610616@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [38/89] drm/radeon/kms: fix for radeon on systems >4GB without
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 hardware iommu

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

---
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -752,6 +752,7 @@ int radeon_device_init(struct radeon_dev
 	dma_bits = rdev->need_dma32 ? 32 : 40;
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
+		rdev->need_dma32 = true;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}
 


