Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1JZFr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:47:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab1JZFrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:47:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=UZcVpVzZQs4i12qd5Wt4hp0vVfYIyFAzcrr2pvWm0jRwv6X9NO9eiA78R8OkFKrPi
	2Fvyv2IWGplFrOWgaTuMw==
Date: Tue, 25 Oct 2011 22:47:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@android.com>
cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com> <20111025090956.GA10797@suse.de> <alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com> <CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1796313805-1319608037=:18661"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1796313805-1319608037=:18661
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Oct 2011, Colin Cross wrote:

> > On Tue, 25 Oct 2011, Mel Gorman wrote:
> >
> >> That said, it will be difficult to remember why checking __GFP_NOFAIL in
> >> this case is necessary and someone might "optimitise" it away later. It
> >> would be preferable if it was self-documenting. Maybe something like
> >> this? (This is totally untested)
> >>
> >
> > __GFP_NOFAIL _should_ be optimized away in this case because all he's
> > passing is __GFP_WAIT | __GFP_NOFAIL.  That doesn't make any sense unless
> > all you want to do is livelock.
> 
> __GFP_NOFAIL is not set in the case that I care about.  If my change
> is hit, no forward progress has been made, so I agree it should not
> honor __GFP_NOFAIL.
> 

I was responding to Mel's comment, not your case.

> > __GFP_NOFAIL doesn't mean the page allocator would infinitely loop in all
> > conditions.  That's why GFP_ATOMIC | __GFP_NOFAIL actually fails, and I
> > would argue that __GFP_WAIT | __GFP_NOFAIL should fail as well since it's
> > the exact same condition except doesn't have access to the extra memory
> > reserves.
> >
> > Suspend needs to either set __GFP_NORETRY to avoid the livelock if it's
> > going to disable all means of memory reclaiming or freeing in the page
> > allocator.  Or, better yet, just make it GFP_NOWAIT.
> >
> 
> It would be nice to give compaction and the slab shrinker a chance to
> recover a few pages, both methods will work fine in suspend.

Ok, so __GFP_NORETRY it is.  Just make sure that when 
pm_restrict_gfp_mask() masks off __GFP_IO and __GFP_FS that it also sets 
__GFP_NORETRY even though the name of the function no longer seems 
appropriate anymore.

> GFP_NOWAIT will prevent them from ever running, and __GFP_NORETRY will
> give up even if they are making progress but haven't recovered enough
> pages.
> 

These are all order-3 or smaller allocations where fragmentation isn't a 
big issue.  If a call into direct compaction or reclaim fails to reclaim 
that small amount of contiguous memory, what makes you believe that a 
second call will?
--397155492-1796313805-1319608037=:18661--
