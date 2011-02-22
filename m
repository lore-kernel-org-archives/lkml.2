Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1BVRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:09:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1BVRJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:09:26 -0500
Date: Tue, 22 Feb 2011 18:08:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Clemens Ladisch <cladisch@googlemail.com>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110222170850.GB31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <20110222165944.GG15652@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222165944.GG15652@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 04:59:45PM +0000, Mel Gorman wrote:
> There is a small chance that if the lock is contended, the current CPU
> will simply reacquire the lock. Any idea how likely that is? The
> need_resched() check itself seems reasonable and should reduce the
> length of time interrupts are disabled.

If the loop is short the contention probability should be small. I
mostly added it because that's the way cond_resched_lock does it. I
thought it was better anyway.

> Why is this change necessary? kswapd may go to sleep sooner as a result
> of this change but it doesn't affect the length of time interrupts are
> disabled. Some other latency problem you've found?

It's not. But I don't want to run more than 1 loop. Otherwise I'm
afraid that kswapd will generate a too big high load.

> I'm not seeing how this change is related to interrupts either. The intention
> of the current code is that after compaction, a zone should not be considered
> all_unreclaimnable. The reason is that there was enough free memory
> before compaction started but compaction takes some time during which
> kswapd is not reclaiming pages at all. The view of the zone before and
> after compaction is not directly related to all_unreclaimable so
> all_reclaimable should only be set after shrinking a zone and there is
> insufficient free memory to meet watermarks.

There is not just the interrupt issue. There's also a problem that
kswapd is generating a too high load. And I'm afraid what can happen
is that kswapd should go in all reclaimable state and it doesn't
because there was also an high order allocation in the mix. So I
prefer to obey to the order=0 all unreclaimable logic with higher
priority. The freeing-max one page above is also to run max 1 scan
over all pfn before putting kswapd in all unreclaimable state. The
probability that a GFP_ATOMIC allocation improves performance thanks
to being "jumbo" more than one entire scan of the pfn in the system
sounds quite small. If all goes well kswapd will generate more than
one atomic page. Also it's good to keep the COMPACTION_KSWAPD mode to
differentiate the low/high wmark (with kswapd checking the high one if
not even a page of the right order is available).
