Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1ADGp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:45:58 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57562 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab1ADGp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:45:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMpPIk15Ldpx/2dsb2JhbACkNXS7SIVKBJAq
Date: Tue, 4 Jan 2011 17:45:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC][PATCH 05/17] x86: Optimize arch_spin_unlock_wait()
Message-ID: <20110104064542.GF3402@amd>
References: <20101224122338.172750730@chello.nl>
 <20101224123742.724459093@chello.nl>
 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
 <1294054362.2016.74.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294054362.2016.74.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:32:42PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-12-24 at 10:26 -0800, Linus Torvalds wrote:
> > On Fri, Dec 24, 2010 at 4:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Only wait for the current holder to release the lock.
> > >
> > > spin_unlock_wait() can only be about the current holder, since
> > > completion of this function is inherently racy with new contenders.
> > > Therefore, there is no reason to wait until the lock is completely
> > > unlocked.
> > 
> > Is there really any reason for this patch? I'd rather keep the simpler
> > and more straightforward code unless you have actual numbers.
> 
> No numbers, the testcase I use for this series is too unstable to really
> give that fine results. Its more a result of seeing the code an going:
> "oohh that can wait a long time when the lock is severely contended".

It would be kind of nice to fix, with ticket locks, dumb spin_unlock_wait
can infinitely starve if the lock queue is never empty, wheras at least
the simple spinlocks it would have a statistical chance of being given
the cacheline in unlocked state.

 
> But I think I can get rid of the need for calling this primitive
> alltogether, which is even better.

I always hated it because it seems hard to use right and verify result
is correct, particularly because it has no memory ordering guarantees.

assert(active == 1);
spin_lock(&blah);
if (should_die)
  active = 0;
counter++;
spin_unlock(&blah);

if (active) {
  spin_lock(&blah);
  /* do something */
  spin_unlock(&blah);
} else {
  /* wait for last to go away */
  spin_unlock_wait(&blah);
  counter++;
}

I don't know, stupid example but I can't really think of good ways to
use it off the top of my head.

Anyway this has a lost update problem even on x86 because counter can
be speculatively loaded out of order from the load of the lock word.
So the nice simple lock APIs which supposedly don't require any thought
of barriers have tricked us!

So I agree, taking it out the back and shooting it in the head would make
the world a better place.

