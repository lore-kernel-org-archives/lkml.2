Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0G1P43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:56:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36903 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0G1P40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lWcOelgOXrZB6UkpF3ST5Ah9/1rliXwTpuvIMVINCtM0A3n+N66adICTAVK9IbiZ0F
         Awy8l5RRhKbyaWvUf6loRFzMFusfNrtTrbQg13yV0Woe+G46YvnWXXQ3kOjmA7pK0VP0
         NDHx0CO3PfERwpaNWTfPmCnzoUV0iCZwme1hg=
Date: Thu, 29 Jul 2010 00:56:17 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
Message-ID: <20100728155617.GA5401@barrios-desktop>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
 <alpine.DEB.2.00.1007261136160.5438@router.home>
 <pfn.valid.v4.reply.1@mdm.bga.com>
 <AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com>
 <pfn.valid.v4.reply.2@mdm.bga.com>
 <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
 <alpine.DEB.2.00.1007270929290.28648@router.home>
 <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
 <alpine.DEB.2.00.1007281005440.21717@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007281005440.21717@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:14:51AM -0500, Christoph Lameter wrote:
> On Wed, 28 Jul 2010, Minchan Kim wrote:
> 
> > static inline int memmap_valid(unsigned long pfn)
> > {
> >        struct page *page = pfn_to_page(pfn);
> >        struct page *__pg = virt_to_page(page);
> 
> Does that work both for vmemmap and real mmapping?

When Kame suggested this idea, he doesn't consider vmemmap model. 
(He prevent this featur's enabling by config !SPARSEMEM_VMEMMAP)

config SPARSEMEM_HAS_HOLE
       bool "allow holes in sparsemem's memmap"
       depends on ARM && SPARSEMEM && !SPARSEMEM_VMEMMAP
       default n

When I change it with ARCH_HAS_HOLES_MEMORYMODEL, it was my mistake.
I can change it with ARCH_HAS_HOLES_MEMORYMODEL && !SPARSE_VMEMMAP. 

I wonder whether we supports VMEMMAP. 
That's because hole problem of sparsemem is specific on ARM. 
ARM forks uses it for saving memory space but VMEMMAP does use more memory.
I think it's irony. 

> 
> >        return page_private(__pg) == MAGIC_MEMMAP && PageReserved(__pg);
> > }
> 
> Problem is that pages may be allocated for the mmap from a variety of
> places. The pages in mmap_init_zone() and allocated during boot may have
> PageReserved set whereas the page allocated via vmemmap_alloc_block() have
> PageReserved cleared since they came from the page allocator.
> 
> You need to have consistent use of PageReserved in page structs for the
> mmap in order to do this properly.

Yes if we supports both model. 

> 
> Simplest scheme would be to clear PageReserved() in all page struct
> associated with valid pages and clear those for page structs that do not
> refer to valid pages.

I can't understand your words.
Clear PG_resereved in valid pages and invalid pages both?

I guess your code look like that clear PG_revered on valid memmap
but set PG_reserved on invalid memmap.
Right?

invalid memmap pages will be freed by free_memmap and will be used 
on any place. How do we make sure it has PG_reserved?

Maybe I don't understand your point. 


> 
> Then
> 
> mmap_valid = !PageReserved(xxx(pfn_to_page(pfn))

-- 
Kind regards,
Minchan Kim
