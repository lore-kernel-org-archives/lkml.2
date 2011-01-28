Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1A1A06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:26:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762Ab1A1A05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:26:57 -0500
Date: Thu, 27 Jan 2011 16:26:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Make vm_acct_memory scalable for large memory
 allocations
Message-Id: <20110127162626.8b38145b.akpm@linux-foundation.org>
In-Reply-To: <4D420A89.3050906@linux.intel.com>
References: <1296082319.2712.100.camel@schen9-DESK>
	<20110127153642.f022b51c.akpm@linux-foundation.org>
	<4D420A89.3050906@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 16:15:05 -0800
Andi Kleen <ak@linux.intel.com> wrote:

> 
> > This seems like a pretty dumb test case.  We have 64 cores sitting in a
> > loop "allocating" 32MB of memory, not actually using that memory and
> > then freeing it up again.
> >
> > Any not-completely-insane application would actually _use_ the memory.
> > Which involves pagefaults, page allocations and much memory traffic
> > modifying the page contents.
> >
> > Do we actually care?
> 
> It's a bit like a poorly tuned malloc. From what I heard poorly tuned 
> mallocs are quite
> common in the field, also with lots of custom ones around.
> 
> While it would be good to tune them better the kernel should also have 
> reasonable performance
> for this case.
> 
> The poorly tuned malloc has other problems too, but this addresses at 
> least one
> of them.
> 
> Also I think Tim's patch is a general improvement to a somewhat dumb 
> code path.
> 

I guess another approach to this would be change the way in which we
decide to update the central counter.

At present we'll spill the per-cpu counter into the central counter
when the per-cpu counter exceeds some fixed threshold.  But that's
dumb, because the error factor is relatively large for small values of
the counter, and relatively small for large values of the counter.

So instead, we should spill the per-cpu counter into the central
counter when the per-cpu counter exceeds some proportion of the central
counter (eg, 1%?).  That way the inaccuracy is largely independent of
the counter value and the lock-taking frequency decreases for large
counter values.

And given that "large cpu count" and "lots of memory" correlate pretty
well, I suspect such a change would fix up the contention which is
being seen here without magical startup-time tuning heuristics.

This again will require moving the batch threshold into the counter
itself and also recalculating it when the central counter is updated.
