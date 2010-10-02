Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0JBH7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:59:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44314 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0JBH7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:59:43 -0400
Date: Sat, 2 Oct 2010 10:49:44 +0300
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
Message-ID: <20101002074944.GB14377@esdhcp036161.research.nokia.com>
References: <1285902536-7043-1-git-send-email-x0095840@ti.com>
 <1285902536-7043-2-git-send-email-x0095840@ti.com>
 <1285902536-7043-3-git-send-email-x0095840@ti.com>
 <20101001105711.GA11617@esdhcp036161.research.nokia.com>
 <496565EC904933469F292DDA3F1663E602F46544F9@dlee06.ent.ti.com>
 <20101001175327.GA13657@esdhcp036161.research.nokia.com>
 <496565EC904933469F292DDA3F1663E602F465461A@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496565EC904933469F292DDA3F1663E602F465461A@dlee06.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Oct 2010 07:59:37.0182 (UTC) FILETIME=[C226FFE0:01CB6207]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 09:21:36PM +0200, ext Guzman Lugo, Fernando wrote:
>  
> > On Fri, Oct 01, 2010 at 06:10:30PM +0200, ext Guzman Lugo, 
> > Fernando wrote:
> > >  
> > 
> > [snip]
> > 
> > > > >  arch/arm/plat-omap/iovmm.c |    6 +++---
> > > > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm/plat-omap/iovmm.c
> > > > b/arch/arm/plat-omap/iovmm.c
> > > > > index 24ca9c4..fc6b109 100644
> > > > > --- a/arch/arm/plat-omap/iovmm.c
> > > > > +++ b/arch/arm/plat-omap/iovmm.c
> > > > > @@ -289,19 +289,19 @@ static struct iovm_struct
> > > > *alloc_iovm_area(struct iommu *obj, u32 da,
> > > > >  	prev_end = 0;
> > > > >  	list_for_each_entry(tmp, &obj->mmap, list) {
> > > > >  
> > > > > -		if (prev_end >= start)
> > > > > +		if (prev_end > start)
> > > > >  			break;
> > > > >  
> > > > >  		if (start + bytes <= tmp->da_start)
> > > > >  			goto found;
> > > > >  
> > > > >  		if (flags & IOVMF_DA_ANON)
> > > > > -			start = roundup(tmp->da_end + 
> > 1, alignement);
> > > > > +			start = roundup(tmp->da_end, 
> > alignement);
> > > > 
> > > > There's a lack of comment here, but the purpose of
> > > > tmp->da_end + 1 is to create a gap between iovm areas to
> > > > force to trigger iommu faults when some access exceeds a 
> > valid area. 
> > > > Without this gap, such situation may produce data 
> > corruption which 
> > > > is much more difficult to track.
> > > 
> > > That only works when you are accessing sequencially beyond 
> > the End of 
> > > the vm_area. However if you are accessing a random address 
> > Which is in 
> > > the mmu tables you still can corrupt memory which does Not 
> > belong to 
> > > you. That looks not very effective then why waste Memory?
> > 
> > The main intention is to detect sequential access beyond the 
> > end of the vm area and it is effective for that purpose.
> > i.e., OMAP3 ISP has a hw issue which makes its H3A submodule, 
> > responsible to produce statistics data for the captured 
> > image, to write more data than it should. The workaround 
> > described in the errata wasn't enough to avoid error 
> > conditions, so a different approach was implemented. This gap 
> > did help me to make sure the new workaround is valid and no 
> > data corruption was occurring anymore.
> > Anyway, I can't see why memory is being wasted.
> > 
> 
> I was taking about vitual memory waste (maybe not so important).
> Is ok for me then keep the gap. Do other changes look good to
> You?

Do you mean in this patch?
All changes make sense only if you're removing the gap, except for the
fix below.

[snip]

> > > > >  
> > > > >  		prev_end = tmp->da_end;
> > > > >  	}
> > > > >  
> > > > > -	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
> > > > > +	if ((start >= prev_end) && (ULONG_MAX - start + 
> > 1 >= bytes))

This fix is partially valid. The correct change must be only:
-	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
+	if ((start > prev_end) && (ULONG_MAX - start + 1 >= bytes))

Otherwise you wouldn't guarantee the gap for fixed da.

Br,

David
