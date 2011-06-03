Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1FCRbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:31:46 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:38288 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1FCRbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:31:45 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Jun 2011 18:31:42 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <airlied@linux.ie>,
        <alexdeucher@gmail.com>
Subject: [PATCH] tentative fix for radeon on systems >4GB without hardware
 iommu
In-Reply-To: <20110601222226.GH27166@one.firstfloor.org>
References: <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
 <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
 <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
 <20110601132444.GA4081@dumpdata.com>
 <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
 <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
 <20110601222226.GH27166@one.firstfloor.org>
Message-ID: <72a54a970741bfc342467045351df812@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

 --- 
 linux-2.6.39-gentoo/drivers/gpu/drm/radeon/radeon_device.c.old	2011-06-03 
 19:11:33.208891994 +0200
 +++ 
 linux-2.6.39-gentoo/drivers/gpu/drm/radeon/radeon_device.c	2011-06-03 
 19:21:10.240337986 +0200
 @@ -752,6 +752,7 @@ int radeon_device_init(struct radeon_dev
  	dma_bits = rdev->need_dma32 ? 32 : 40;
  	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
  	if (r) {
 +		rdev->need_dma32 = true;
  		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
  	}

