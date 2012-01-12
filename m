Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2ALOxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:53:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2ALOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:53:34 -0500
Date: Thu, 12 Jan 2012 14:53:30 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, akpm@linux-foundation.org,
        mel@csn.ul.ie, minchan.kim@gmail.com
Subject: Re: [PATCH v2 -mm] make swapin readahead skip over holes
Message-ID: <20120112145330.GK4118@suse.de>
References: <20120111143044.3c538d46@cuia.bos.redhat.com>
 <20120111205041.GE24386@cmpxchg.org>
 <4F0DFF64.4040704@redhat.com>
 <20120111214242.GF24386@cmpxchg.org>
 <4F0E05F6.30105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F0E05F6.30105@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 04:58:14PM -0500, Rik van Riel wrote:
> On 01/11/2012 04:42 PM, Johannes Weiner wrote:
> >On Wed, Jan 11, 2012 at 04:30:12PM -0500, Rik van Riel wrote:
> >>On 01/11/2012 04:10 PM, Johannes Weiner wrote:
> >>>On Wed, Jan 11, 2012 at 02:30:44PM -0500, Rik van Riel wrote:
> >>>>Ever since abandoning the virtual scan of processes, for scalability
> >>>>reasons, swap space has been a little more fragmented than before.
> >>>>This can lead to the situation where a large memory user is killed,
> >>>>swap space ends up full of "holes" and swapin readahead is totally
> >>>>ineffective.
> >>>>
> >>>>On my home system, after killing a leaky firefox it took over an
> >>>>hour to page just under 2GB of memory back in, slowing the virtual
> >>>>machines down to a crawl.
> >>>>
> >>>>This patch makes swapin readahead simply skip over holes, instead
> >>>>of stopping at them.  This allows the system to swap things back in
> >>>>at rates of several MB/second, instead of a few hundred kB/second.
> >>>>
> >>>>The checks done in valid_swaphandles are already done in
> >>>>read_swap_cache_async as well, allowing us to remove a fair amount
> >>>>of code.
> >>>
> >>>__swap_duplicate() also checks for whether the offset is within the
> >>>swap device range.  Do you think we could remove get_swap_cluster()
> >>>altogether and just try reading the aligned page_cluster range?
> >>
> >>That is how I implemented it originally, but we need
> >>to take the swap_lock so it is cleaner to implement
> >>a helper function in swapfile.c :)
> >
> >AFAICS, it's only needed to validate the offset against si->max, but
> >this too is done in __swap_duplicate().
> >
> >What's otherwise left is just rounding down swp_offset(entry) and
> >adding 1<<  page_cluster to it, that shouldn't need the swap_lock?
> >
> >Am I missing something?
> 
> Good point.  I guess we could get rid of get_swap_cluster
> afterall and let __swap_duplicate deal with everything.
> 
> Andrew, Mel, is that ok with you?
> 

I still think it is a bit unfortunate that we can end up allocating
more pages than we need and the radix_preload() before __swap_duplicate
identifies that the work was unnecessary. However, duplicate logic is
also bad and as you say, in the context of the cost of swap IO, the cost
is negligible and it's a corner case.

I'm ok with it.

-- 
Mel Gorman
SUSE Labs
