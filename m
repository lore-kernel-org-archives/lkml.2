Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0JASDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:03:40 -0400
Received: from smtp.nokia.com ([147.243.1.47]:35577 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0JASDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:03:39 -0400
Date: Fri, 1 Oct 2010 20:53:27 +0300
From: David Cohen <david.cohen@nokia.com>
To: "ext Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Doyu Hiroshi (Nokia-MS/Espoo)" <hiroshi.doyu@nokia.com>,
        "Contreras Felipe (Nokia-MS/Helsinki)" <felipe.contreras@nokia.com>,
        "Palande Ameya (Nokia-MS/Helsinki)" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] iovmm: fix roundup for next area and end check for
 the last area
Message-ID: <20101001175327.GA13657@esdhcp036161.research.nokia.com>
References: <1285902536-7043-1-git-send-email-x0095840@ti.com>
 <1285902536-7043-2-git-send-email-x0095840@ti.com>
 <1285902536-7043-3-git-send-email-x0095840@ti.com>
 <20101001105711.GA11617@esdhcp036161.research.nokia.com>
 <496565EC904933469F292DDA3F1663E602F46544F9@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496565EC904933469F292DDA3F1663E602F46544F9@dlee06.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 06:10:30PM +0200, ext Guzman Lugo, Fernando wrote:
>  

[snip]

> > >  arch/arm/plat-omap/iovmm.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm/plat-omap/iovmm.c 
> > b/arch/arm/plat-omap/iovmm.c 
> > > index 24ca9c4..fc6b109 100644
> > > --- a/arch/arm/plat-omap/iovmm.c
> > > +++ b/arch/arm/plat-omap/iovmm.c
> > > @@ -289,19 +289,19 @@ static struct iovm_struct 
> > *alloc_iovm_area(struct iommu *obj, u32 da,
> > >  	prev_end = 0;
> > >  	list_for_each_entry(tmp, &obj->mmap, list) {
> > >  
> > > -		if (prev_end >= start)
> > > +		if (prev_end > start)
> > >  			break;
> > >  
> > >  		if (start + bytes <= tmp->da_start)
> > >  			goto found;
> > >  
> > >  		if (flags & IOVMF_DA_ANON)
> > > -			start = roundup(tmp->da_end + 1, alignement);
> > > +			start = roundup(tmp->da_end, alignement);
> > 
> > There's a lack of comment here, but the purpose of 
> > tmp->da_end + 1 is to create a gap between iovm areas to 
> > force to trigger iommu faults when some access exceeds a 
> > valid area. Without this gap, such situation may produce data 
> > corruption which is much more difficult to track.
> 
> That only works when you are accessing sequencially beyond the
> End of the vm_area. However if you are accessing a random address
> Which is in the mmu tables you still can corrupt memory which does
> Not belong to you. That looks not very effective then why waste
> Memory?

The main intention is to detect sequential access beyond the end of the
vm area and it is effective for that purpose.
i.e., OMAP3 ISP has a hw issue which makes its H3A submodule, responsible
to produce statistics data for the captured image, to write more data than
it should. The workaround described in the errata wasn't enough to avoid
error conditions, so a different approach was implemented. This gap
did help me to make sure the new workaround is valid and no data
corruption was occurring anymore.
Anyway, I can't see why memory is being wasted.

> 
> Maybe other mechanism should be implemente like in the process
> Switching when if the process has DMM virtual memory area and if
> So enablig only that area (all other process areas will be
> Dissabled and it would get a mmufault in case of access). However
> That increase the time of switching between process.

Sure. We can have other mechanisms. But in the above scenario, H3A
submodule has sequential access and can corrupt its own data. It has
more than one buffer and they're likely to be mapped to sequential
memory areas without the mechanism you're about to remove.

If you're able to implement a better mechanism, please remove this one
just when a new is already there. :)

Regards,

David

> 
> Regards,
> Fernando.
> 
> > 
> > Br,
> > 
> > David
> > 
> > >  
> > >  		prev_end = tmp->da_end;
> > >  	}
> > >  
> > > -	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
> > > +	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
> > >  		goto found;
> > >  
> > >  	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
> > > --
> > > 1.6.3.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe 
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org 
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
