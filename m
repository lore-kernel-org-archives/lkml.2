Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1HXIRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:17:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1HXIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:17:45 -0400
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] Fix non-LPAE boot regression.
Date: Wed, 24 Aug 2011 11:16:25 +0300
User-Agent: KMail/1.13.7 (Linux/3.0.1-gentoo-anarsoul; KDE/4.6.3; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <201108131556.27301.anarsoul@gmail.com> <20110815120914.GB21596@e102109-lin.cambridge.arm.com> <201108151531.45469.anarsoul@gmail.com>
In-Reply-To: <201108151531.45469.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241116.26118.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 August 2011 15:31:44 Vasily Khoruzhick wrote:
> On Monday 15 August 2011 15:09:14 Catalin Marinas wrote:
> > Hi Vasily,
> > 
> > On Sat, Aug 13, 2011 at 01:58:19PM +0100, Vasily Khoruzhick wrote:
> > > It was introduced by  407f8b4cb07cbc5c1c7cc386f231224e2524ccea
> > > ARM: LPAE: MMU setup for the 3-level page table format
> > > 
> > > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > > ---
> > > 
> > >  arch/arm/kernel/head.S |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> > > index 0bdafc4..5add5f5 100644
> > > --- a/arch/arm/kernel/head.S
> > > +++ b/arch/arm/kernel/head.S
> > > 
> > > @@ -206,7 +206,7 @@ __create_page_tables:
> > >  1:	orr	r3, r7, r5, lsl #SECTION_SHIFT	@ flags + kernel base
> > >  
> > >  	str	r3, [r4, r5, lsl #PMD_ORDER]	@ identity mapping
> > >  	cmp	r5, r6
> > > 
> > > -	addlo	r5, r5, #SECTION_SHIFT >> 20	@ next section
> > > +	addlo	r5, r5, #1			@ next section
> > > 
> > >  	blo	1b
> > 
> > That's correct.
> > 
> > >  	/*
> > > 
> > > @@ -217,7 +217,7 @@ __create_page_tables:
> > >  	mov	r3, r3, lsr #SECTION_SHIFT
> > >  	orr	r3, r7, r3, lsl #SECTION_SHIFT
> > >  	add	r0, r4,  #(KERNEL_START & 0xff000000) >> (SECTION_SHIFT -
> > >  	PMD_ORDER)
> > > 
> > > -	str	r3, [r0, #(KERNEL_START & 0x00e00000) >> (SECTION_SHIFT -
> > > PMD_ORDER)]! +	str	r3, [r0, #(KERNEL_START & 0x00f00000) >>
> > > (SECTION_SHIFT - PMD_ORDER)]!
> > 
> > The reason for this was that the sections are 2MB with LPAE and a page
> > table entry is 64-bit wide. We always shift that value by 18 but with
> > LPAE we don't want to write in the middle of a page table entry if
> > KERNEL_START is not 2MB aligned.
> > 
> > But if KERNEL_START is not 2MB aligned, I think we get the wrong
> > physical address by 1MB (with the classic page table format).
> 
> Yep, for my case KERNEL_START is not 2MB aligned (TEXT_OFFSET is 0x00108000). 
> (CONFIG_PM_H1940 is set)
> 
> > There are a few alternatives to fixing this:
> > 
> > 1. Different KERNEL_START masking for classic or LPAE page tables.
> > 2. Always force 2MB section and the code above moving the phys addr into
> >    r3 would need to take this into account.
> > 
> > I would go for 1 with some shifting like below:
> > 
> > +	str	r3, [r0, #((KERNEL_START & 0x00f00000) >> SECTION_SHIFT) <<
> > PMD_ORDER]!
> > 
> > This should give us 0x00f00000 with classic page tables and 0x00e00000
> > with LPAE.
> > 
> > Thanks.
> 
> Ok, I'll test this change when I get home.

Works for me on s3c24xx. Sorry for a delay.

Regards
Vasily
