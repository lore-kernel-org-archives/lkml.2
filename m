Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2LGIle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:41:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab2LGIlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:41:32 -0500
Date: Fri, 7 Dec 2012 08:32:48 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121207083248.GF17258@suse.de>
References: <20121206091744.GA1397@polaris.bitmath.org>
 <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
 <CA+55aFw9WQN-MYFKzoGXF9Z70h1XsMu5X4hLy0GPJopBVuE=Yg@mail.gmail.com>
 <20121206175451.GC17258@suse.de>
 <CA+55aFwDZHXf2FkWugCy4DF+mPTjxvjZH87ydhE5cuFFcJ-dJg@mail.gmail.com>
 <20121206183259.GA591@polaris.bitmath.org>
 <CA+55aFzievpA_b5p-bXwW11a89eC-ucpzKUuSqb2PNQOLrqaPg@mail.gmail.com>
 <20121206192845.GA599@polaris.bitmath.org>
 <CA+55aFy4Lv+_aPEakOJNR2F9PR=09jviT6Z70_NkWV5bSH5ABw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFy4Lv+_aPEakOJNR2F9PR=09jviT6Z70_NkWV5bSH5ABw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:38:47AM -0800, Linus Torvalds wrote:
> Ok, I've applied the patch.
> 

Thanks.

> Mel, some grepping shows that there is an old line that does
> 
>     end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
> 
> which looks bogus.

It's bogus. The impact is that multiple compaction attempts may be needed
to clear a particular block for allocation. THP allocation success rate
under stress will be lower and the latency before a range of pages is
collapsed by khugepaged to a huge page will be higher. The impact of this
is less and it should not result in a bug like Henrik's

An attentive reviewer is going to exclaim that GFP_ATOMIC allocations for
jumbo frames is impacted by this but it isn't. Even with this bogus walk,
compaction will be clearing SWAP_CLUSTER_MAX contiguous chunks which is
enough for jumbo frames.

> That should probably also use "+ 1" instead. But
> I'll consider that an independent issue, so I applied the one patch
> regardless.
> 
> There is also a
> 
>     low_pfn += pageblock_nr_pages;
>     low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
> 
> that looks suspicious for similar reasons. Maybe
> 
>     low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
> 

This one is working by co-incidence because the low_pfn will be aligned
in most cases. If it was outright broken then CMA would never work either.

> instead? Although that *can* result in the same low_pfn in the end, so
> maybe that one was correct after all? I just did some grepping, no
> actual semantic analysis...
> 

They need fixing but the impact is much less severe and does not justify
delaying 3.8 over unlike the other last-minute fixes. My performance
writing patches during talks was less than stellar yesterday so I'll avoid
a repeat performance and follow up with Andrew early next week with a cc
to -stable. It'll also give me a chance to run the patches through the
highalloc stress tests and confirm that allocation success rate is higher
and latency lower as would be expected by such a fix.

Thanks.

-- 
Mel Gorman
SUSE Labs
