Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3AJMtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:49:53 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:39473 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3AJMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:49:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130108173029.305d99c0@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
	<20130108173029.305d99c0@annuminas.surriel.com>
Date: Thu, 10 Jan 2013 04:49:50 -0800
Message-ID: <CANN689GqkkP4yhJyNa9QvaH=8fj_xkKr24tapw+ypfqWG_pKoQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] x86,smp: auto tune spinlock backoff delay factor
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 2:30 PM, Rik van Riel <riel@redhat.com> wrote:
> v3: use fixed-point math for the delay calculations, suggested by Michel Lespinasse
>
> -               if (head == ticket)
> +               if (head == ticket) {
> +                       /*
> +                        * We overslept, and do not know by how.
> +                        * Exponentially decay the value of delay,
> +                        * to get it back to a good value quickly.
> +                        */
> +                       if (delay >= 2 * DELAY_FIXED_1)
> +                               delay -= max(delay/32, DELAY_FIXED_1);
>                         break;
> +               }

I think delay -= (delay - MIN_SPINLOCK_DELAY) / 32 would work too, and
avoid the conditions here.

It won't make a difference in practice because delay > 32 *
DELAY_FIXED_1 on all machines I tested (even for the shortest possible
do-nothing spinlocked regions)


Also - I think we could make MIN_SPINLOCK_DELAY a tunable. There is a
limit to how fast the lock cacheline can bounce from one waiter to the
next, and we know that this limit isn't DELAY_FIXED_1. Using
DELAY_FIXED_1 is OK when we don't know of a better lower bound for a
given system, but I think it'd be nice if one could set the correct
value if they know it.



Looking at the bigger picture:

The tests I've done haven't shown any regressions over baseline. Your
v1 proposal had a tendency to oversleep but this has been fixed in v2
and v3. The only risk I can foresee, and I think this hasn't been
tested enough, would be that the algorithm might oversleep when it
encounters a mix of short and long held spinlocks. I think the proper
behavior when we encounter this is that we want to be conservative and
use the shortest encountered spinlock as our delay in that case. There
is a strong theorical case that additive increase/exponential decay
should achieve that, but I'd like to see it tested in practice.

Trying to lay down the argument why additive increase / exponential
decay should work here:
- When we oversleep, we spin (waiters_ahead * delay / DELAY_FIXED_1)
iterations (with waiters_ahead < NR_CPUS) and update new_delay = delay
* (31 / 32)
- If we keep oversleeping, delay will converge towards 0 so that the
sum of all overslept delay values will be original_delay *
sum(i=0...infinity, (31/32)^i) which is 32 * original_delay. So, the
total number of oversleeping iterations is bounded by original_delay *
(NR_CPUS * 32 / DELAY_FIXED_1)
- Each increase of delay by DELAY_FIXED_1 / 7 can thus be seen as
having a potential worst-case future cost of (NR_CPUS * 32 / 7)
oversleeping iterations.
I like that this last value is at least bounded, but it's still high
enough that I think actual behavior in the face of varying hold
durations should be investigated.



As for test results:
running 32 instances of netperf -t UDP_STREAM -H <server> -- -m 128 on
a 32 hypercores machine (2 sandybridge sockets) and htb root qdisc:
I am seeing ~650 to ~680 Mbps total with baseline 3.7, and ~860 to
~890 Mbps total with patches 1-3 applied.
(patch 4 makes the results a bit more consistent, in the ~880 to ~890
Mbps range)



Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
