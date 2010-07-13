Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0GMPnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:43:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63516 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0GMPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=epOpsw6x+tI6A8/J6cZ1wyYPa4ZxKTrzYV5gtLTtni0GRl+D+9qDt+RXdA3sYhqqie
         LvY6S26xb9d68412INtoGnGJKJQ5IAlO035b0kRiStd1ofxZGJtfPqrYZ/pYnyGvIMnE
         buyEk42Bbf1xzgJkI5WnTftRTwYV51yOIPoNM=
Date: Wed, 14 Jul 2010 00:43:35 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux@arm.linux.org.uk, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-ID: <20100713154335.GB2815@barrios-desktop>
References: <20100712155348.GA2815@barrios-desktop>
 <20100713093006.GB14504@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713093006.GB14504@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:30:06AM +0200, Johannes Weiner wrote:
> On Tue, Jul 13, 2010 at 12:53:48AM +0900, Minchan Kim wrote:
> > Kukjin, Could you test below patch?
> > I don't have any sparsemem system. Sorry. 
> > 
> > -- CUT DOWN HERE --
> > 
> > Kukjin reported oops happen while he change min_free_kbytes
> > http://www.spinics.net/lists/arm-kernel/msg92894.html
> > It happen by memory map on sparsemem. 
> > 
> > The system has a memory map following as. 
> >      section 0             section 1              section 2
> > 0x20000000-0x25000000, 0x40000000-0x50000000, 0x50000000-0x58000000
> > SECTION_SIZE_BITS 28(256M)
> > 
> > It means section 0 is an incompletely filled section.
> > Nontheless, current pfn_valid of sparsemem checks pfn loosely. 
> > 
> > It checks only mem_section's validation.
> > So in above case, pfn on 0x25000000 can pass pfn_valid's validation check.
> > It's not what we want.
> > 
> > The Following patch adds check valid pfn range check on pfn_valid of sparsemem.
> 
> Look at the declaration of struct mem_section for a second.  It is
> meant to partition address space uniformly into backed and unbacked
> areas.
> 
> It comes with implicit size and offset information by means of
> SECTION_SIZE_BITS and the section's index in the section array.
> 
> Now you are not okay with the _granularity_ but propose to change _the
> model_ by introducing a subsection within each section and at the same
> time make the concept of a section completely meaningless: its size
> becomes arbitrary and its associated mem_map and flags will apply to
> the subsection only.
> 
> My question is: if the sections are not fine-grained enough, why not
> just make them?
> 
> The biggest possible section size to describe the memory population on
> this machine accurately is 16M.  Why not set SECTION_SIZE_BITS to 24?

You're right. AFAIK, Kukjin tried it but Russell and others rejected it. 
Let's wrap it up. 

First of all, Thanks for joining good discussion, Kame, Hannes, Mel and 
Russell. 

The system has following memory map. 
0x20000000-0x25000000,       0x40000000-0x50000000, 0x50000000-0x58000000
       80M          hole : 432M      256M                   128M

1) FLATMEM
If it uses FLATMEM, it wastes 864(432M/512K) pages due to memmap on hole. 
That's horrible. 

2) SPARSEMEM(16M)
It makes 56 mem_sections. It costs 448(56 * 8)byte.
It doesn't make unused memmap. So good.

3) SPARSEMEM(256M)
It makes 3 mem_sections. It costs 24(3 * 8) byte. 
And if we free unused memmap on 176M(256M - 80M), we can save 352 pages.

3 is best about memory usage. but for 3, we should check pfn_valid more tightly.
It can be checked by my patch. but mm guys didn't like it since it makes memory 
model messy due to some funny architecture.(ie, sparsemem designed to not include
hole.) and it still has a problem if there is a hole in the middle of section.

3 is not a big deal than 2 about memory usage.
If the system use memory space fully(MAX_PHYSMEM_BITS 31), it just consumes
1024(128 * 8) byte. So now I think best solution is 2. 

Russell. What do you think about it?

-- 
Kind regards,
Minchan Kim
