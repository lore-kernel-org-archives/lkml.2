Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1ATSEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:04:20 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:50083 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1ATSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:04:17 -0500
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KyongHo Cho <pullip.linux@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Ilho Lee <ilho215.lee@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>,
        MinChan Kim <minchan.kim@gmail.com>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <AANLkTi=nsAOtLPK75Wy5Rm8pfWob8xTP5259DyYuxR9J@mail.gmail.com>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com>
	 <1295544047.9039.609.camel@nimitz>
	 <AANLkTi=nsAOtLPK75Wy5Rm8pfWob8xTP5259DyYuxR9J@mail.gmail.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 20 Jan 2011 10:04:13 -0800
Message-ID: <1295546653.9039.680.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 02:38 +0900, KyongHo Cho wrote:
> Actually, as long as a bank in meminfo only resides in a pgdat, no
> problem happens
> because there is no restriction of size of area in a pgdat.
> That's why I just considered about sparsemem.

Ahh, so "banks" are always underneath a single pgdat, and a "bank" is
always contiguous?  That's handy.

> I worried that pfn_to_page() in sparsemem is a bit slower than that in flatmem.
> Moreover, the previous one didn't use pfn_to_page() but page++ for the
> performance.
> Nevertheless, I also think that pfn_to_page() make the code neat.

The sparsemem_vmemmap pfn_to_page() is just arithmetic.  The table-based
sparsemem requires lookups and is a _bit_ slower, but the tables have
very nice CPU cache properties and shouldn't miss the L1 very often in a
loop like that.

show_mem() isn't exactly a performance-critical path, either, right?
It's just an exception or error path.

If it turns out that doing pfn_to_page() *is* too slow, there are a
couple more alternatives.  pfn_to_section_nr() is just a bit shift and
is really cheap.  Should be just an instruction or two with either no
memory access, or just a load of the pfn from the stack.

We could make a generic function like this (Or I guess we could also
just make sure that pfn_to_section_nr() always returns 0 for
non-sparsemem configurations):

int pfns_same_section(unsigned long pfn1, unsigned long pfn2)
{
#ifdef CONFIG_SPARSEMEM
	return (pfn_to_section_nr(pfn1) == pfn_to_section_nr(pfn2));
#else
	return 1;
#endif
}

and use it in show_mem like so:

                do {
                        total++;
                        if (PageReserved(page))
                                reserved++;
                        else if (PageSwapCache(page))
                                cached++;
                        else if (PageSlab(page))
                                slab++;
                        else if (!page_count(page))
                                free++;
                        else
                                shared += page_count(page) - 1;
			pfn1++;
			/*
			 * Did we just cross a section boundary?
			 * If so, our pointer arithmetic is not
			 * valid, and we must re-run pfn_to_page()
			 */
			if (pfns_same_section(pfn1-1, pfn1)) {
	                        page++;
			} else {
				page = pfn_to_page(pfn1);
			}
                } while (page < end);

We can do basically the same thing, but instead checking to see if we
crossed a MAX_ORDER boundary.  That would keep us from having to refer
to sparsemem at all.  The buddy allocator relies on that guarantee, so
it's pretty set in stone.

-- Dave

