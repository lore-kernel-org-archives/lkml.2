Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0DPIaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 04:30:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:40677 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab0DPIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 04:30:50 -0400
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100416081859.GK5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.643778654@chello.nl> <1271120731.13059.6.camel@pasglop>
	 <20100413034311.GB2772@linux.vnet.ibm.com>
	 <1271400694.13059.183.camel@pasglop>  <20100416081859.GK5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 18:29:02 +1000
Message-ID: <1271406542.13059.188.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 18:18 +1000, Nick Piggin wrote:
> On Fri, Apr 16, 2010 at 04:51:34PM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2010-04-12 at 20:43 -0700, Paul E. McKenney wrote:
> > > > So we might have to support the interrupt assumption, at least in
> > > some
> > > > form, with those guys...
> > > 
> > > One way to make the interrupt assumption official is to use
> > > synchronize_sched() rather than synchronize_rcu().
> > 
> > Ok, so I'm a bit of a RCU newbie as you may know :-) Right now, we use
> > neither, we use call_rcu and we free the pages from the callback.
> 
> BTW. you currently have an interesting page table freeing path where
> you usually free by RCU, but (occasionally) free by IPI. This means
> you need to disable both RCU and interrupts to walk page tables.

Well, the point is we use interrupts to synchronize. The fact that RCU
used to do the job was an added benefit. I may need to switch to rcu
_sched variants tho to keep that. The IPI case is a slow path in case we
are out of memory and cannot allocate our page of RCU batch.

> If you change it to always use RCU, then you wouldn't need to disable
> interrupts. Whether this actually matters anywhere in your mm code, I
> don't know (it's probably not terribly important for gup_fast). But
> rcu disable is always preferable for latency and performance.

Well, the main case is the hash miss and that always runs with IRQs off.

Cheers,
Ben.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


