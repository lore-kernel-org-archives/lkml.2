Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3ACNFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:05:50 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47431 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab3ACNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:05:47 -0500
Subject: Re: [RFC PATCH 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
In-Reply-To: <CANN689FQK0c4VCPvT-Zg0vFLApOCMed7BwEEaR_ixFjO3gwBGQ@mail.gmail.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
	 <20130103002444.113f4950@annuminas.surriel.com>
	 <CANN689FQK0c4VCPvT-Zg0vFLApOCMed7BwEEaR_ixFjO3gwBGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 05:05:43 -0800
Message-ID: <1357218343.21409.24347.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 04:48 -0800, Michel Lespinasse wrote:
> On Wed, Jan 2, 2013 at 9:24 PM, Rik van Riel <riel@redhat.com> wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> >
> > Eric Dumazet found a regression with the spinlock backoff code,
> > in workloads where multiple spinlocks were contended, each having
> > a different wait time.
> 
> I think you should really clarify that the regression was observed
> with version 1 of your proposal. At that time,
> 
> 1- the autotune code tended to use too long delays for long held locks, and
> 
> 2- there was no exponential backoff, which meant that sharing stats
> between a long held and a short held spinlock could really hurt
> throughput on the short held spinlock
> 
> 
> I believe that with autotune v2, this really shouldnt be a problem and
> stats sharing should result in just using a delay that's appropriate
> for the shorter of the two lock hold times - which is not the optimal
> value, but is actually close enough performance wise and, most
> importantly, should not cause any regression when compared to current
> mainline.
> 
> (it's important to point that out because otherwise, you might trick
> Linus into thinking your patches are risky, which I think they
> shouldn't be after you implemented exponential backoff)
> 
> >  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
> >  {
> >         __ticket_t head = inc.head, ticket = inc.tail;
> >         __ticket_t waiters_ahead;
> > -       int delay = __this_cpu_read(spinlock_delay);
> > +       u32 hash = hash32_ptr(lock);
> > +       u32 slot = hash_32(hash, DELAY_HASH_SHIFT);
> > +       struct delay_entry *ent = &__get_cpu_var(spinlock_delay[slot]);
> > +       u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;
> 
> IMO we want to avoid MIN_SPINLOCK_DELAY here. The exponential backoff
> autotune should make us resilient to collisions (if they happen we'll
> just end up with something very close to the min of the delays that
> would have been appropriate for either locks), so it should be better
> to just let collisions happen rather than force the use of
> MIN_SPINLOCK_DELAY.
> 

exponential backoff wont help, I tried this idea last week and found
that its better to detect hash collision and safely use
MIN_SPINLOCK_DELAY in this case.

Its better to not overestimate the delay and spin much longer than
needed.

On a hash collision, we dont know at all the contention history of this
lock, unless we store the EWMA delay inside the lock.

(On x86 and NR_CPUS <= 256, we have a 16 bit hole in the spinlock that
 we could use for this)



