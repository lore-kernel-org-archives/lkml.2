Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab2AKVnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:43:08 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35632 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934009Ab2AKVms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:42:48 -0500
Date: Wed, 11 Jan 2012 22:42:42 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, akpm@linux-foundation.org,
        mel@csn.ul.ie, minchan.kim@gmail.com
Subject: Re: [PATCH v2 -mm] make swapin readahead skip over holes
Message-ID: <20120111214242.GF24386@cmpxchg.org>
References: <20120111143044.3c538d46@cuia.bos.redhat.com>
 <20120111205041.GE24386@cmpxchg.org>
 <4F0DFF64.4040704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0DFF64.4040704@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 04:30:12PM -0500, Rik van Riel wrote:
> On 01/11/2012 04:10 PM, Johannes Weiner wrote:
> >On Wed, Jan 11, 2012 at 02:30:44PM -0500, Rik van Riel wrote:
> >>Ever since abandoning the virtual scan of processes, for scalability
> >>reasons, swap space has been a little more fragmented than before.
> >>This can lead to the situation where a large memory user is killed,
> >>swap space ends up full of "holes" and swapin readahead is totally
> >>ineffective.
> >>
> >>On my home system, after killing a leaky firefox it took over an
> >>hour to page just under 2GB of memory back in, slowing the virtual
> >>machines down to a crawl.
> >>
> >>This patch makes swapin readahead simply skip over holes, instead
> >>of stopping at them.  This allows the system to swap things back in
> >>at rates of several MB/second, instead of a few hundred kB/second.
> >>
> >>The checks done in valid_swaphandles are already done in
> >>read_swap_cache_async as well, allowing us to remove a fair amount
> >>of code.
> >
> >__swap_duplicate() also checks for whether the offset is within the
> >swap device range.  Do you think we could remove get_swap_cluster()
> >altogether and just try reading the aligned page_cluster range?
> 
> That is how I implemented it originally, but we need
> to take the swap_lock so it is cleaner to implement
> a helper function in swapfile.c :)

AFAICS, it's only needed to validate the offset against si->max, but
this too is done in __swap_duplicate().

What's otherwise left is just rounding down swp_offset(entry) and
adding 1 << page_cluster to it, that shouldn't need the swap_lock?

Am I missing something?
