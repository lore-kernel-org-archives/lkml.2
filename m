Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2GES4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:56:09 -0400
Received: from waste.org ([173.11.57.241]:54427 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab2GES4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:56:07 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 14:56:07 EDT
Message-ID: <1341514078.4020.1213.camel@calx>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
From: Matt Mackall <mpm@selenic.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Date: Thu, 05 Jul 2012 13:47:58 -0500
In-Reply-To: <1341511933-11169-2-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	 <1341511933-11169-2-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 14:12 -0400, Theodore Ts'o wrote:
> We've been moving away from add_interrupt_randomness() for various
> reasons: it's too expensive to do on every interrupt, and flooding the
> CPU with interrupts could theoretically cause bogus floods of entropy
> from a somewhat externally controllable source.
> 
> This solves both problems by limiting the actual randomness addition
> to just once a second or after 128 interrupts, whicever comes first.
> During that time, the interrupt cycle data is buffered up in a per-cpu
> pool.  Also, we make sure the the nonblocking pool used by urandom is
> initialized before we start feeding the normal input pool.  This
> assures that /dev/urandom is returning unpredictable data as soon as
> possible.
> 
> (Based on an original patch by Linus, but significantly modified by
> tytso.)

This series generally looks good to me, thanks for working on this. Some
notes:

a) now that you have a lockless collection path, you can drop the
trickle logic that protects against thrashing the lock
b) you can drop the last of the IRQF_SAMPLE_RANDOM users (and the
corresponding deprecation notice)
c) this code looks like it might credit timer interrupts with entropy on
a system otherwise sitting in the idle loop:

> -	if (state == NULL)
> +	if ((fast_pool->count & 255) &&
> +	    !time_after(now, fast_pool->last + HZ))
>  		return;
>  
> -	DEBUG_ENT("irq event %d\n", irq);
> -	add_timer_randomness(state, 0x100 + irq);
> +	fast_pool->last = now;
> +
> +	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
> +	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
> +	credit_entropy_bits(r, 1);

I think you should demand a minimum number of events > HZ to actually
credit any valid entropy.

But I also still think the whole entropy counting/blocking scheme ought
to be dropped and /dev/random should become identical to /dev/urandom.
This series gets very close to the point where that's feasible.

-- 
Mathematics is the supreme nostalgia of our time.


