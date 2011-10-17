Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1JQE7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 00:59:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1JQE7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 00:59:44 -0400
Date: Mon, 17 Oct 2011 06:58:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111017045806.GA11561@elte.hu>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca>
 <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins>
 <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca>
 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> However, I don't see why that spinlock is needed at all. Why aren't 
> those fields just atomics (or at least just "sum_exec_runtime")? 
> And why does "cputime_add()" exist at all? [...]

Agreed, atomic64_t is the best choice here. (When the lock was added 
to struct *_cputimer this should probably have been done already - 
but we didn't have atomic64_t back then yet.)

> That stupid definition of cputime_add() has apparently existed 
> as-is since it was introduced in 2005. Why do we have code like 
> this:
> 
>     times->utime = cputime_add(times->utime, t->utime);
> 
> instead of just
> 
>     times->utime += t->utime;
> 
> which seems not just shorter, but more readable too? The reason is 
> not some type safety in the cputime_add() thing, it's just a macro.

Yes. This was in fact how the old scheduler accunting code looked 
like:

-                               utime += t->utime;
-                               stime += t->stime;
+                               utime = cputime_add(utime, t->utime);
+                               stime = cputime_add(stime, t->stime);

before the pointless looking cputime_t wrappery was added in 2005:

 0a71336: [PATCH] cputime: introduce cputime

For the record, i absolutely hate much of the other time related type 
obfuscation we do as well.

For example the ktime_t obfuscation - we only do it to avoid a divide 
on 32-bit architectures that cannot do fast 64/32 divisions ...

It makes the time code a *lot* less obvious than it could be.

I think we should use one flat u64 nanoseconds time type in the 
kernel (preparing it with using KTIME_SCALAR on all architectures for 
a release or so), used with very simple and obvious C arithmetics.

That simple time type could then trickle down as well: we could use 
it everywhere in kernel code and limit the hodge-podge of ABI time 
units to the syscall boundary. (and convert the internal time unit to 
whatever ABI unit there is close to the syscall boundary)

There's a point where micro-optimized 32-bit support related 
maintenance overhead (and the resulting loss of 
robustness/flexibility) becomes too expensive IMO.

Thanks,

	Ingo
