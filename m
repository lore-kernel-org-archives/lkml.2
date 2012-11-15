Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423664Ab2KOMLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:11:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250Ab2KOMLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:11:04 -0500
Date: Thu, 15 Nov 2012 12:10:57 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: linux-next: Tree for Nov 14
Message-ID: <20121115121057.GU8218@suse.de>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
 <20121113213742.292f3ace.akpm@linux-foundation.org>
 <20121114064726.GA2537@gmail.com>
 <20121113225635.a848fd6c.akpm@linux-foundation.org>
 <20121114073929.GA3130@gmail.com>
 <alpine.LNX.2.00.1211132346120.19216@eggly.anvils>
 <50A3CF4B.8020806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50A3CF4B.8020806@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 12:05:15PM -0500, Rik van Riel wrote:
> On 11/14/2012 03:13 AM, Hugh Dickins wrote:
> 
> >Please, Ingo, stop trying to force this in ahead of time, yet again.
> >
> >People are still reviewing and comparing competing solutions.
> >Maybe this latest will prove to be closest to the right answer,
> >maybe it will not.  It's, what, about two days old right now?
> >
> >If we had wanted to push in a good solution a little prematurely,
> >we would surely have chosen Andrea's AutoNUMA months ago, despite
> >efforts to block it; and maybe we shall still want to go that way.
> 
> As much as I would like to see NUMA stuff going upstream
> the day before yesterday, I have to agree with Hugh that
> we need to do things right.
> 

After my last test of tests against schednuma I have to agree. While the
differences we see in different tests could be explained by different JVM
configurations, it does not tell us *why* they performed differently. Because
of the monolithic nature of some of the patches it's non-trivial to
establish which part is causing the problems.  I still have not got
around to sending the latest schednuma through a spidey decoder ring to
see exactly how it works.  FWIW the idea that is described sounds great.

> Having unreviewed (some of it NAKed) code sitting in
> tip.git and you trying to force it upstream is not the
> right way to go.
> 
> >Please, forget about v3.8, cut this branch out of linux-next,
> >and seek consensus around getting it right for v3.9.
> 
> I suspect that no matter how long we delay merging the
> NUMA placement code, we will always run into some kind
> of regression. I am not sure if a delay will buy us much.
> 
> On the mm/ bits, there appears to be consensus already.
> Mel Gorman's patch series contains the nicest mm/ bits
> from autonuma and sched/numa, plus further improvements.
> Andrea has supported Mel's series, and Ingo is pulling
> code from it.
> 
> That leads me to believe Mel's NUMA bits may be worth
> considering for 3.8.
> 

I still think the series is not fully baked.  I'm still working on getting
some of the basics right and getting the System CPU usage down which right
now is through the roof. It's going to take me time and while I think I'll
have something working semi-properly by 3.8 rolls around I severely doubt
it'll have seen any wide-spread testing.  My preference is the final result
be sortof comparable with autonumas performance but satisfy the scheduler
folk in terms of how it integrates with kernel/sched/* and not use kernel
threads except as a last resort.

Big chunks are still missing. No knob for turning off from command line,
no THP native migration (getting the simple case right first), placement
policy is still extremely heavy (was run in kernel thread context before and
needs to change now), page struct elements are not folded into page->flags,
task_struct has fields that should move to task_struct->task_balancenuma,
no docs etc etc etc.

> On top of that, we could place the policy code by
> Peter and Ingo, but as a nice reviewable patch series,
> not hidden away through various tip.git branches.
> 
> Does a combination of Mel's NUMA mm/ bits and the
> policy code from Peter and Ingo sound reasonable?
> 
> Mel, is that reasonable to you?
> 

It'd be reasonable to me. Preferably patches would affect individual areas
rather than being a large patch affecting multiple areas. As well as being
easier to comprehend, we can also bisect the result. To me, the obvious
discrete areas that a single patch would affect are

1. The PTE update helper functions
2. The PTE scanning machinary driven from task_numa_tick
3. Task and process fault accounting and how that information is used
   to determine if a page is misplaced
4. Fault handling, migrating the page if misplaced, what information is
   provided to the placement policy

Obviously that is not always possible.

Thanks to the kernel.org folk I have a git tree at

	git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git

The mm-balancenuma-v1r15[*] and mm-balancenuma-v2r45 branches correspond to
the V1 and V2 series I released. I've pushed a mm-balancenuma-v3r22-snapshot
branch which is unreleased but shows where the tree currently stands.
Almost nothing in there after the initial placement policy has been tested
at all but it shows the initial adjustment to how PMD faults are handled
and some preliminary migration rate-limiting code. The same patches when
complete should be usable by schednuma be it due to a rebase on top or
because they pull the patches in and adjust them accordingly.

-- 
Mel Gorman
SUSE Labs
