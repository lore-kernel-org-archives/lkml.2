Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3ACMbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:31:05 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61766 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3ACMbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:31:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130103002341.3cc4b7b4@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
	<20130103002341.3cc4b7b4@annuminas.surriel.com>
Date: Thu, 3 Jan 2013 04:31:00 -0800
Message-ID: <CANN689Hd01BNYhcBJJBfz7VXJiFM5QikGOLVnokS4Gbq7cT=1g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] x86,smp: auto tune spinlock backoff delay factor
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 9:23 PM, Rik van Riel <riel@redhat.com> wrote:
> Proportional spinlock delay with a high delay factor works well
> when there is lots contention on a lock. Likewise, a smaller
> delay factor works well when a lock is lightly contended.
>
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention.

I don't quite like that part of the explanation - Ideally I would like
to explain that there are huge benefits in having the delay be at
least equivalent to the time taken by a no-load spin/release section,
and that beyond that there are small additional benefits to using a
longer delay when the spinlock hold times are larger, and an
explanation of why linear increase / exponential delay works nicely
here.

I'll see if I can make a more concrete proposal and still keep it
short enough :)

> +#define MIN_SPINLOCK_DELAY 1
> +#define MAX_SPINLOCK_DELAY 16000
> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };

unsigned would seem more natural here, though it's only a tiny detail

>  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>  {
>         __ticket_t head = inc.head, ticket = inc.tail;
>         __ticket_t waiters_ahead;
> +       int delay = __this_cpu_read(spinlock_delay);

I like that you used __this_cpu_read() - your v1 version wasn't as nice.

> +
> +               /*
> +                * The lock is still busy; slowly increase the delay. If we
> +                * end up sleeping too long, the code below will reduce the
> +                * delay. Ideally we acquire the lock in the tight loop above.
> +                */
> +               if (!(head % 7) && delay < MAX_SPINLOCK_DELAY)
> +                       delay++;
> +
> +               loops = delay * waiters_ahead;

I don't like the head % 7 thing. I think using fixed point arithmetic
would be nicer:

if (delay < MAX_SPINLOCK_DELAY)
  delay += 256/7; /* Or whatever constant we choose */

loops = (delay * waiter_ahead) >> 8;

Also, we should probably skip the delay increment on the first loop
iteration - after all, we haven't waited yet, so we can't say that the
delay was too short.

> -               if (head == ticket)
> +               if (head == ticket) {
> +                       /*
> +                        * We overslept and have no idea how long the lock
> +                        * went idle. Reduce the delay as a precaution.
> +                        */
> +                       delay -= delay/32 + 1;

There is a possibility of integer underflow here. It seems that the
window to hit it would be quite small, but it can happen (at the very
least, imagine getting an interrupt at an inopportune time which would
make it look like you overslept). I think this may be what was causing
the stability issues I noticed.

I'll try to come up with a custom version of this patch. I do feel
that we're going in a good direction in general, though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
