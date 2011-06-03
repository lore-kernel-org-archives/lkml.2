Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1FCXO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:14:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54744 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1FCXOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:14:23 -0400
Date: Fri, 3 Jun 2011 19:13:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Daniel Haid <d.haid@gogi.tv>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, airlied@linux.ie
Subject: Re: [PATCH] tentative fix for radeon on systems >4GB without
 hardware iommu
Message-ID: <20110603231350.GA20316@dumpdata.com>
References: <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
 <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
 <20110601132444.GA4081@dumpdata.com>
 <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
 <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
 <20110601222226.GH27166@one.firstfloor.org>
 <72a54a970741bfc342467045351df812@admin.gogi.tv>
 <BANLkTik+p65G5f08RfxiYojvAax_nrDiqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <BANLkTik+p65G5f08RfxiYojvAax_nrDiqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DE96AB9.005E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 04:44:59PM -0400, Alex Deucher wrote:
> On Fri, Jun 3, 2011 at 1:31 PM, Daniel Haid <d.haid@gogi.tv> wrote:
> > On my x86_64 system with >4GB of ram and swiotlb instead of
> > a hardware iommu (because I have a VIA chipset), the call
> > to pci_set_dma_mask (see below) with 40bits returns an error.
> >
> > But it seems that the radeon driver is designed to have
> > need_dma32 = true exactly if pci_set_dma_mask is called
> > with 32 bits and false if it is called with 40 bits.
> >
> > I have read somewhere that the default are 32 bits. So if the
> > call fails I suppose that need_dma32 should be set to true.
> >
> > And indeed the patch fixes the problem I have had before
> > and which I had described here:
> > http://choon.net/forum/read.php?21,106131,115940
> 
> This looks like the correct fix. rdev->need_dma32 is used when we init
> ttm for memory management later.
> 
> Alex

<nods>

Daniel, did you find other graphic drivers that forget to set need_dma32
after failing to set the dma_mask ?

> 
> Acked-by: Alex Deucher <alexdeucher@gmail.com>
> 
> >
> > --- linux-2.6.39-gentoo/drivers/gpu/drm/radeon/radeon_device.c.old
> >  2011-06-03 19:11:33.208891994 +0200
> > +++ linux-2.6.39-gentoo/drivers/gpu/drm/radeon/radeon_device.c  2011-06-03
> > 19:21:10.240337986 +0200
> > @@ -752,6 +752,7 @@ int radeon_device_init(struct radeon_dev
> >        dma_bits = rdev->need_dma32 ? 32 : 40;
> >        r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
> >        if (r) {
> > +               rdev->need_dma32 = true;
> >                printk(KERN_WARNING "radeon: No suitable DMA available.\n");
> >        }
> >
> >
