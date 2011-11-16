Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1KPVjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:39:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42574 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1KPVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:39:07 -0500
Date: Wed, 16 Nov 2011 13:39:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@android.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <20111116095244.GM27150@suse.de>
Message-ID: <alpine.DEB.2.00.1111161332330.16596@chino.kir.corp.google.com>
References: <20111114140421.GA27150@suse.de> <alpine.DEB.2.00.1111151332160.26232@chino.kir.corp.google.com> <20111116095244.GM27150@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Mel Gorman wrote:

> Good point. I agree that it would be more consistent although
> there is still the risk of infinite looping with __GFP_NOFAIL if
> storage devices are disabled.
> 

Yeah, that's always been possible even regardless of the state of storage 
devices.  If a task has access to memory reserves via TIF_MEMDIE, 
__alloc_pages_high_priority() will just loop indefinitely anyway for these 
allocations.  While users of __GFP_NOFAIL accept that it won't return NULL 
as long as they have __GFP_WAIT (which they all do), then they should also 
accept the fact that it may never return at all.

> Colin reported elsewhere in this thread that "the particular allocation
> that usually causes the problem is the pgd_alloc for page tables when
> re-enabling the 2nd cpu during resume". On X86, those allocations are using
> the flags
> 
> GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
> 
> so they should not be trapped in an infinite loop due to __GFP_NOFAIL.
> On ARM, they use GFP_KERNEL so should also be ok.
> 

The __GFP_REPEAT is concerning because there's a high liklihood that 
!__GFP_FS as a result of suspend will never cause enough pages to be 
reclaimed so the necessary threshold will be reached to exit from its own 
self-induced infinite loop.  So if we go forward with failing allocations 
attempted without __GFP_IO and __GFP_FS that are !__GFP_NOFAIL, then we 
should also add that __GFP_REPEAT is a no-op without __GFP_IO or __GFP_FS.

> David, is this what you meant? This patch includes all the
> documentation-related updates that were discussed in this thread as well
> as updated the check in mm/swapfile.c for hibernation.
> 
> ==== CUT HERE ====
> mm: avoid livelock on !__GFP_FS allocations v2
> 
> Changelog since V1
>   o Move PM check to should_alloc_retry (David Rientjes)
>   o Add some additional documentation
> 
> Colin Cross reported;
> 
>   Under the following conditions, __alloc_pages_slowpath can loop forever:
>   gfp_mask & __GFP_WAIT is true
>   gfp_mask & __GFP_FS is false
>   reclaim and compaction make no progress
>   order <= PAGE_ALLOC_COSTLY_ORDER
> 
>   These conditions happen very often during suspend and resume,
>   when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
>   allocations into __GFP_WAIT.
> 
>   The oom killer is not run because gfp_mask & __GFP_FS is false,
>   but should_alloc_retry will always return true when order is less
>   than PAGE_ALLOC_COSTLY_ORDER.
> 
> In his fix, he avoided retrying the allocation if reclaim made no
> progress and __GFP_FS was not set. The problem is that this would
> result in GFP_NOIO allocations failing that previously succeeded
> which would be very unfortunate.
> 
> The big difference between GFP_NOIO and suspend converting GFP_KERNEL
> to behave like GFP_NOIO is that normally flushers will be cleaning
> pages and kswapd reclaims pages allowing GFP_NOIO to succeed after
> a short delay. The same does not necessarily apply during suspend as
> the storage device may be suspended.
> 
> This patch special cases the suspend case to fail the page allocation
> if reclaim cannot make progress and adds some documentation on how
> gfp_allowed_mask is currently used. Failing allocations like this
> may cause suspend to abort but that is better than a livelock.
> 
> [mgorman@suse.de: Rework fix to be suspend specific]
> [rientjes@google.com: Move suspended device check to should_alloc_retry]
> Reported-by: Colin Cross <ccross@android.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>

Thanks Mel!
