Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1IOBwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 21:52:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:60856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab1IOBwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 21:52:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,384,1312182000"; 
   d="scan'208";a="48967645"
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of
 an ioremapped memory range
From: Zhang Rui <rui.zhang@intel.com>
To: Shaohua Li <shli@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <CANejiEXSvT1hGasoowf1nCc5+EWyXr8PSmfpWDJOT0d_vEiKxA@mail.gmail.com>
References: <1314860114.32522.3.camel@rui>	<1314864889.13161.4.camel@rui>
	 <1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAC=cRTOzcgm+3kHGcZrHs=9Q3cs5z6vmBqb1Bn+2qcvcSZ-2Xg@mail.gmail.com>
	 <1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CANejiEXSvT1hGasoowf1nCc5+EWyXr8PSmfpWDJOT0d_vEiKxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 09:52:15 +0800
Message-ID: <1316051535.15084.5.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 09:22 +0800, Shaohua Li wrote:
> 2011/9/12 Matt Fleming <matt@console-pimps.org>:
> > On Fri, 2011-09-02 at 13:12 +0800, huang ying wrote:
> >> On Thu, Sep 1, 2011 at 8:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> >> >
> >> > Hmm.. does anyone know why we ioremap_cache() the memory on
> >> > CONFIG_X86_32 instead of ioremap_nocache()? In the case of
> >> > EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
> >> > we've ioremap'd the memory we should skip set_memory_uc() altogether,
> >> > no?
> >>
> >> Because whether the mapping should be cached is determined by md->attr
> >> instead of md->type.  And besides UC, we may add WC, etc support.
> >
> > Confused.
> >
> > The CONFIG_X86_64 version of efi_ioremap() looks like this,
> >
> > void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
> >                                 u32 type)
> > {
> >        unsigned long last_map_pfn;
> >
> >        if (type == EFI_MEMORY_MAPPED_IO)
> >                return ioremap(phys_addr, size);
> >
> > Which uses md->type to figure out if we should call ioremap(), which on
> > x86 is #define'd to ioremap_nocache(). CONFIG_X86_32 doesn't do this,
> > but it looks to me like it should.
> agree. mapping it wrong and fixing it later makes no sense. we should get
> the mapping correct at the first.
> 
So what kinds of memory regions need ioremap_nocache?
should we make this decision based on the memory range type or attribute
or even both of them?

-rui

> > Zhang, I agree that calling __pa() on an ioremap()'d region is bogus,
> > but I don't understand why no one is seeing this crash on x86-64. Is it
> > something to do with the x86-64 memory map layout such that __pa() works
> > on an ioremap()'d address?
> x86-64 does identity mapping for larger space (from 0 to the last physical mem
> even there is hole). Maybe this is the reason.


