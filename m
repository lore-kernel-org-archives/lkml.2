Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab1KJBzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:55:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1KJBzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:55:06 -0500
Date: Thu, 10 Nov 2011 02:54:38 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111110015438.GP5075@redhat.com>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110005307.GC3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110005307.GC3083@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 12:53:07AM +0000, Mel Gorman wrote:
> compaction. Are you ok with that? The number of THPs in use was reduced
> but it also was during a somewhat unrealistic stress test so it might
> not matter.

I think having more THP collapsed during the unrealistic load is not
so important, likely the unrelistic load is dominated not by TLB
misses but by kernel load so even if it materializes it shouldn't make
a difference. And khugepaged will just retry at the next pass anyway
so it doesn't matter if it's delayed a bit I think. And retrying on
the same address with __GFP_OTHER_NODE doesn't sound good idea.

> It's not really needed to avoid stalls - just !(gfp_mask &
> __GFP_NO_KSWAPD) is enough for that. It's only needed if we want

I would go with this first. You can keep the second patch in queue,
but considering it's altering the fast paths that affects no-THP
config too, we could at least benchmark it to be sure it's not
measurable. I guess it's not, but hey if it's not needed then we
shouldn't care.

And it was already ok, we thought it didn't matter so we reversed it
in c6a140bf164829769499b5e50d380893da39b29e but it clearly matters for
usb stick, so I would simply reapply it.

One reason we reversed it was also the fact it wasn't so clean to take
that decision in function of __GFP_NO_KSWAPD.  I think it's probably
cleaner to check if __GFP_NORETRY is set instead of __GFP_NO_KSWAPD is
set.

That flag should indicate we don't really care too much if we fail the
allocation or not and not to go too hard on it, and notably those are
the allocations that are totally ok to fail without having to trigger
OOM, so again not worth going the extra mile to succeed them.

Alternatively we could check __GFP_NOFAIL but that's mostly obsolete,
yet another alternative is to check order >_ALLOC_COSTLY_ORDER but you
know any additional PAGE_ALLOC_COSTLY_ORDER check tends to make me
unhappy as the behavior has an enormous change from
PAGE_ALLOC_COSTLY_ORDER to PAGE_ALLOC_COSTLY_ORDER+1 and that's an
arbitrary number that doesn't justify a big change in behavior. So the
less PAGE_ALLOC_COSTLY_ORDER the better, ideally there shall be none :)

So I would suggest to resubmit the 1/2 patch changed to __GFP_NORETRY
or just a plain revert with __GFP_NO_KSWAPD if you don't like the
__GFP_NORETRY.

And to queue up the change to the alloc_pages_vma for later, it's not
a bad idea at all but it only paysoff for khugepaged, and 99% of
userland allocations aren't happening there.
