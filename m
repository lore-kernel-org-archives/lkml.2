Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab1ILPJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:09:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:51839 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab1ILPJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:09:30 -0400
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Sep 2011 17:09:04 +0200
In-Reply-To: <20110912144706.GA21716@Krystal>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
	 <1315836358.26517.43.camel@twins>
	 <20110912142305.GN7761@one.firstfloor.org> <20110912144706.GA21716@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315840144.26517.66.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 10:47 -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > On Mon, Sep 12, 2011 at 04:05:58PM +0200, Peter Zijlstra wrote:
> > > Subject: llist: Remove cpu_relax() usage in cmpxchg loops
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date: Mon Sep 12 15:50:49 CEST 2011
> > > 
> > > Initial benchmarks show they're a net loss (2 socket wsm):
> > > 
> > 
> > May still save power.
> 
> Looking at kernel/spinlock.c:
> 
> void __lockfunc __raw_##op##_lock(locktype##_t *lock) \
> {
> [...]
>                 while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
>                         arch_##op##_relax(&lock->raw_lock); \
> 
> so basically, in typical locking primitives (spinlock), it looks like
> lower power consumption is preferred over getting the raw maximal
> performance in fully contented scenarios.

Who says its about power consumption? That was a baseless claim made by
Andi which you propagate as a truth. Typically PAUSE is too short to
really save any power and the only gain of having it in loops is to
provide a window where another core on the cache domain can have a go.

If power consumption would be the prime concern Intel should fix their
damn mwait implementation so we can use that for locks. Local spinners +
mwait would give a very power efficient 'spin'-lock.

> So what is the rationale for making those lock-less lists retry scheme
> different from spinlocks here ?

PAUSE should help on the medium contended case (it would be pointless on
heavy contention), but hurt the lightly contended case. We have all
kinds of contention spinlocks in the kernel, but we don't as of yet have
very contended llist users in the kernel.

Furthermore, I would argue we should avoid growing them, significantly
contended atomic ops are bad, use a different scheme.

