Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424480Ab2LFQ40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:56:26 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:39924 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424328Ab2LFQ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:56:25 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnhKAPHMwFBV5qjOPGdsb2JhbABEhUuFI7M7FwMBAQEBODSCHgEBBAEnExwTAQ8FCwgDDjgUJQoaE4gKCsI+FJAHYQOWAoV7g1OJbg
X-IronPort-AV: E=Sophos;i="4.84,230,1355094000"; 
   d="scan'208";a="165391500"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Dec 2012 17:58:29 +0100
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206165829.GA392@polaris.bitmath.org>
References: <20121206091744.GA1397@polaris.bitmath.org>
 <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206161934.GA17258@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

> Still travelling and am not in a position to test this properly :(.
> However, this bug feels very similar to a bug in the migration scanner where
> a pfn_valid check is missed because the start is not aligned.  Henrik, when
> did this start happening? I would be a little surprised if it started between
> 3.6 and 3.7-rcX but maybe it's just easier to hit now for some reason.

I started using transparent hugepages when moving to 3.7-rc1, so it is
quite possible that the problem was there already in 3.6.

> How reproducible is this? Is there anything in particular you do to
> trigger the oops?

Unfortunately nothing special, and it is rare. IIRC, it has happened
after a long uptime, but I guess that only means the probability of
the oops is higher then.

> Does the following patch help any? It's only compile tested I'm afraid.
> 
> ---8<---
> mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGES block during isolation for free
> 
> Commit 0bf380bc (mm: compaction: check pfn_valid when entering a new
> MAX_ORDER_NR_PAGES block during isolation for migration) added a check
> for pfn_valid() when isolating pages for migration as the scanner does
> not necessarily start pageblock-aligned. However, the free scanner has
> the same problem. If it encounters a hole, it can also trigger an oops
> when is calls PageBuddy(page) on a page that is within an hole.
> 
> Reported-by: Henrik Rydberg <rydberg@euromail.se>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Cc: stable@vger.kernel.org
> ---
>  mm/compaction.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 9eef558..7d85ad485 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -298,6 +298,16 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  			continue;
>  		if (!valid_page)
>  			valid_page = page;
> +
> +		/*
> +		 * As blockpfn may not start aligned, blockpfn->end_pfn
> +		 * may cross a MAX_ORDER_NR_PAGES boundary and a pfn_valid
> +		 * check is necessary. If the pfn is not valid, stop
> +		 * isolation.
> +		 */
> +		if ((blockpfn & (MAX_ORDER_NR_PAGES - 1)) == 0 &&
> +		    !pfn_valid(blockpfn))
> +			break;
>  		if (!PageBuddy(page))
>  			continue;
>  

I am running with it now, adding a printout to see if the case happens
at all. Might take a while, will try to stress the machine a bit.

Thanks,
Henrik
