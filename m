Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1KAMgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:36:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab1KAMgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:36:12 -0400
Date: Tue, 1 Nov 2011 12:36:08 +0000
From: Mel Gorman <mgorman@suse.de>
To: Colin Cross <ccross@android.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
Message-ID: <20111101123608.GD25123@suse.de>
References: <alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com>
 <CAMbhsRS+-jn7d1bTd4F0_RB9860iWjOHLfOkDsqLfWEUbR3TYA@mail.gmail.com>
 <alpine.DEB.2.00.1110252322220.20273@chino.kir.corp.google.com>
 <CAMbhsRQdrWRLkj7U-u2AZxM11mSUNj5_1K27g58cMBo1Js1Yeg@mail.gmail.com>
 <alpine.DEB.2.00.1110252327270.20273@chino.kir.corp.google.com>
 <CAMbhsRR0z-aJ848gq6ZQATZOgz=EybVsRtaQbjCr42PtCubCzw@mail.gmail.com>
 <alpine.DEB.2.00.1110252347330.20273@chino.kir.corp.google.com>
 <CAMbhsRScgfokDOiT7c9RbmqC7E_ZXrwLEYXE7JZWFGoePjAXvg@mail.gmail.com>
 <alpine.DEB.2.00.1110260006470.23227@chino.kir.corp.google.com>
 <CAMbhsRRZBUcfv5kT4aYm=Z3+kc-usYJVqyc_+1gAEy-4yH_nPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRRZBUcfv5kT4aYm=Z3+kc-usYJVqyc_+1gAEy-4yH_nPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 12:22:14AM -0700, Colin Cross wrote:
> On Wed, Oct 26, 2011 at 12:10 AM, David Rientjes <rientjes@google.com> wrote:
> > On Tue, 25 Oct 2011, Colin Cross wrote:
> >
> >> > gfp_allowed_mask is initialized to GFP_BOOT_MASK to start so that __GFP_FS
> >> > is never allowed before the slab allocator is completely initialized, so
> >> > you've now implicitly made all early boot allocations to be __GFP_NORETRY
> >> > even though they may not pass it.
> >>
> >> Only before interrupts are enabled, and then isn't it vulnerable to
> >> the same livelock?  Interrupts are off, single cpu, kswapd can't run.
> >> If an allocation ever failed, which seems unlikely, why would retrying
> >> help?
> >>
> >
> > If you want to claim gfp_allowed_mask as a pm-only entity, then I see no
> > problem with this approach.  However, if gfp_allowed_mask would be allowed
> > to temporarily change after init for another purpose then it would make
> > sense to retry because another allocation with __GFP_FS on another cpu or
> > kswapd could start making progress could allow for future memory freeing.
> >
> > The suggestion to add a hook directly into a pm-interface was so that we
> > could isolate it only to suspend and, to me, is the most maintainable
> > solution.
> >
> 
> pm_restrict_gfp_mask seems to claim gfp_allowed_mask as owned by pm at runtime:
> "gfp_allowed_mask also should only be modified with pm_mutex held,
> unless the suspend/hibernate code is guaranteed not to run in parallel
> with that modification"
> 
> I think we've wrapped around to Mel's original patch, which adds a
> pm_suspending() helper that is implemented next to
> pm_restrict_gfp_mask.  His patch puts the check inside
> !did_some_progress instead of should_alloc_retry, which I prefer as it
> at least keeps trying until reclaim isn't working.  Pekka was trying
> to avoid adding pm-specific checks into the allocator, which is why I
> stuck to the symptom (__GFP_FS is clear) rather than the cause (PM).
> 

Right now, I'm still no seeing a problem with the pm_suspending() check
as it's made for a corner-case situation in a very slow path that is
self-documenting. This thread has died somewhat and there is still no
fix merged. Is someone cooking up a patch they would prefer as an
alternative? If not, I'm going to resubmit the fix based on
pm_suspending.

-- 
Mel Gorman
SUSE Labs
