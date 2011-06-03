Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1FCUpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:45:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47739 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1FCUpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mQ1iS29TSt8oABE4xV9HU2ExM7fExHj3bm7sIqPRxFCTnnqq6f+z/4qJDaXyU/rHeG
         ImibB/08bjsQhxb63fwc5ulKIkeA6U3zPJF+4ud6kXbWkSxjFtWbpaIkmjNMxrf2MbOX
         qmkkQTgxs5lGKssSWHkzAQ048n35INuCph0u0=
MIME-Version: 1.0
In-Reply-To: <72a54a970741bfc342467045351df812@admin.gogi.tv>
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
	<72a54a970741bfc342467045351df812@admin.gogi.tv>
Date: Fri, 3 Jun 2011 16:44:59 -0400
Message-ID: <BANLkTik+p65G5f08RfxiYojvAax_nrDiqg@mail.gmail.com>
Subject: Re: [PATCH] tentative fix for radeon on systems >4GB without hardware iommu
From: Alex Deucher <alexdeucher@gmail.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 1:31 PM, Daniel Haid <d.haid@gogi.tv> wrote:
> On my x86_64 system with >4GB of ram and swiotlb instead of
> a hardware iommu (because I have a VIA chipset), the call
> to pci_set_dma_mask (see below) with 40bits returns an error.
>
> But it seems that the radeon driver is designed to have
> need_dma32 = true exactly if pci_set_dma_mask is called
> with 32 bits and false if it is called with 40 bits.
>
> I have read somewhere that the default are 32 bits. So if the
> call fails I suppose that need_dma32 should be set to true.
>
> And indeed the patch fixes the problem I have had before
> and which I had described here:
> http://choon.net/forum/read.php?21,106131,115940

This looks like the correct fix. rdev->need_dma32 is used when we init
ttm for memory management later.

Alex

Acked-by: Alex Deucher <alexdeucher@gmail.com>

>
> --- linux-2.6.39-gentoo/drivers/gpu/drm/radeon/radeon_device.c.old
>  2011-06-03 19:11:33.208891994 +0200
> +++ linux-2.6.39-gentoo/drivers/gpu/drm/radeon/radeon_device.c  2011-06-03
> 19:21:10.240337986 +0200
> @@ -752,6 +752,7 @@ int radeon_device_init(struct radeon_dev
>        dma_bits = rdev->need_dma32 ? 32 : 40;
>        r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
>        if (r) {
> +               rdev->need_dma32 = true;
>                printk(KERN_WARNING "radeon: No suitable DMA available.\n");
>        }
>
>
