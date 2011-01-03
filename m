Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1ACLcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:32:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45571 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1ACLcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:32:48 -0500
Subject: Re: [RFC][PATCH 05/17] x86: Optimize arch_spin_unlock_wait()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.724459093@chello.nl>
	 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 12:32:42 +0100
Message-ID: <1294054362.2016.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 10:26 -0800, Linus Torvalds wrote:
> On Fri, Dec 24, 2010 at 4:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Only wait for the current holder to release the lock.
> >
> > spin_unlock_wait() can only be about the current holder, since
> > completion of this function is inherently racy with new contenders.
> > Therefore, there is no reason to wait until the lock is completely
> > unlocked.
> 
> Is there really any reason for this patch? I'd rather keep the simpler
> and more straightforward code unless you have actual numbers.

No numbers, the testcase I use for this series is too unstable to really
give that fine results. Its more a result of seeing the code an going:
"oohh that can wait a long time when the lock is severely contended".

But I think I can get rid of the need for calling this primitive
alltogether, which is even better.

> > +static inline void __ticket_spin_unlock_wait(arch_spinlock_t *lock)
> > +{
> > +       int tmp = ACCESS_ONCE(lock->slock);
> > +
> > +       if (!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK))
> > +               return; /* not locked */
> > +
> > +       /* wait until the current lock holder goes away */
> > +       while ((lock->slock & TICKET_MASK) == (tmp & TICKET_MASK))
> > +               cpu_relax();
> >  }
> 
> Also, the above is just ugly. You've lost the ACCESS_ONCE() on the
> lock access, and it's using another model of masking than the regular
> one. Both of which may be intentional (maybe you are _trying_ to get
> the compiler to just load the low bytes and avoid the 'and'), but the
> whole open-coding of the logic - twice, and with different looking
> masking - just makes my skin itch.

I'm not sure I fully understand the complaint here. The ACCESS_ONCE is
for the tmp variable, which we use several times and needs to contain a
single load of the lock variable and should not be optimized away into
multiple loads.

The first conditional: 

      if (!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK))

Is exactly like the regular __ticket_spin_is_contended, and while that
is a somewhat overly clever way of writing head != tail, I don't see a
problem with that.

The second conditional:

      while ((lock->slock & TICKET_MASK) == (tmp & TICKET_MASK))

Is indeed different, it waits for the lock tail (new load) to change
from the first observed (first load) tail. Once we observe the tail
index changing we know the previous owner completed and we can drop out.

Anyway, if I can indeed get rid of my unlock_wait usage its all moot
anyway, there aren't many users of this primitive.
