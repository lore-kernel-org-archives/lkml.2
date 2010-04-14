Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0DOH3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58205 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0DOH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:45 -0400
Subject: Re: [PATCH 07/13] powerpc: Preemptible mmu_gather
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1271121817.13059.19.camel@pasglop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.901224587@chello.nl>  <1271121817.13059.19.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 15:51:48 +0200
Message-ID: <1271253108.32749.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 11:23 +1000, Benjamin Herrenschmidt wrote:
> > +      * If there are, but we fail to batch, we need to IPI (all?) CPUs so as
> > +      * to serialize against the IRQ disable. In case we do batch, the RCU
> > +      * grace period is at least long enough to cover IRQ disabled sections
> > +      * (XXX assumption, not strictly true).
> 
> Yeah well ... I'm not that familiar with RCU anymore. Back when I wrote
> that, iirc, I would more or less be safe against a CPU that doesn't
> schedule, but things may have well changed.
> 
> We are trying to be safe against another CPU walking page tables in the
> asm lockless hash miss or TLB miss code. Note that sparc64 has a similar
> issue. This is highly optimized asm code that -cannot- call into things
> like rcu_read_lock().

Right, so Paul has been working hard to remove certain implementation
artifact from RCU, such as the preempt-disable == rcu_read_lock thing.

Now, even Preemptible RCU has IRQ-disabled == rcu_read_lock, simply
because the RCU grace period state machine is driven from an interrupt.

But there is no such requirement on RCU at all, so in the interest of
removing assumptions and code validating we're trying to remove such
things.




