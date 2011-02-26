Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1BZAQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:16:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078Ab1BZAQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:16:52 -0500
Date: Sat, 26 Feb 2011 01:16:11 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are
 disabled while isolating pages for migration
Message-ID: <20110226001611.GA19630@random.random>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
 <1298664299-10270-3-git-send-email-mel@csn.ul.ie>
 <20110225223204.GW25382@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225223204.GW25382@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:32:04PM +0100, Johannes Weiner wrote:
> I don't understand why this conditional is broken up like this.
> cond_resched() will have the right checks anyway.  Okay, you would
> save fatal_signal_pending() in the 'did one cluster' case.  Is it that
> expensive?  Couldn't this be simpler like
> 
> 		did_cluster = ((low_pfn + 1) % SWAP_CLUSTER_MAX) == 0
> 		lock_contended = spin_is_contended(&zone->lru_lock);
> 		if (did_cluster || lock_contended || need_resched()) {
> 			spin_unlock_irq(&zone->lru_lock);
> 			cond_resched();
> 			spin_lock_irq(&zone->lru_lock);
> 			if (fatal_signal_pending(current))
> 				break;
> 		}
> 
> instead?

If we don't release irqs first, how can need_resched get set in the
first place if the local apic irq can't run? I guess that's why
there's no cond_resched_lock_irq. BTW, I never liked too much clearing
interrupts for locks that can't ever be taken from irq (it's a
scalability boost to reduce contention but it makes things like above
confusing and it increases irq latency a bit.
