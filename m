Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab0I0Mqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44027 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188Ab0I0Mq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:28 -0400
Date: Mon, 27 Sep 2010 13:46:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rth@twiddle.net,
        linux-kernel@vger.kernel.org
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100927124624.GC19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
 <20100925191836.GW19804@ZenIV.linux.org.uk>
 <20100925192509.GX19804@ZenIV.linux.org.uk>
 <20100927075828.GA15344@jurassic.park.msu.ru>
 <20100927121227.GB19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927121227.GB19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 01:12:28PM +0100, Al Viro wrote:
> On Mon, Sep 27, 2010 at 11:58:28AM +0400, Ivan Kokshaysky wrote:
> > On Sat, Sep 25, 2010 at 08:25:09PM +0100, Al Viro wrote:
> > > BTW, am I right assuming that HAE modifications is UP-only thing?  It would
> > > be obviously b0rken on any SMP box, since alpha_mv is not per-CPU thing...
> > 
> > The only SMP system that does HAE modifications at runtime is T2, so it has
> > a spinlock protection around set_hae() - see core_t2.h. Others are either
> > limited to use HAE window 0 only, or do not have HAE hardware at all.
> 
> Um?  Pardon me, but that makes no sense; how would a spinlock taken in
> e.g. readl() stop another process from leaving a syscall, getting to
> RESTORE_ALL and overwriting HAE register while we are halfway through
> the spinlock-protected area?

AFAICS, we have 3 variants:
	1) alpha_mv.hae_register == &alpha_mv.hae_cache; all that code
becomes a no-op.
	2) UP boxen with hae_register pointing someplace real; we save
HAE in SAVE_ALL, restore it in RESTORE_ALL and disable interrupts around
the updates of hae_cache/*hae_register to keep them in sync.  readl()
et.al. set HAE, then do memory access and rely on not giving CPU up between
these moments.  Since alpha doesn't do PREEMPT, we are OK (otherwise we'd
needed to disable preempt in those places; also not a big deal)
	3) SMP t2 boxen; we protect the entire sequence from setting HAE to
memory access with spinlock and with disabling interrupts.  We don't rely on
interrupts not modifying the damn thing, but we *do* rely on other CPU not
messing with HAE on syscall paths outside of spinlock-protected area.  And
we have RESTORE_ALL hit us on all exits to userland, interrupt, trap and
syscall alike.

	Looks like (3) has always been broken...
