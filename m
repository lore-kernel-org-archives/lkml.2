Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2GETKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:10:20 -0400
Received: from waste.org ([173.11.57.241]:55022 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133Ab2GETKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:10:19 -0400
Message-ID: <1341515412.4020.1230.camel@calx>
Subject: Re: [PATCH 02/10] random: use lockless techniques when mixing
 entropy pools
From: Matt Mackall <mpm@selenic.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Date: Thu, 05 Jul 2012 14:10:12 -0500
In-Reply-To: <1341511933-11169-3-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	 <1341511933-11169-3-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 14:12 -0400, Theodore Ts'o wrote:
> The real-time Linux folks didn't like add_interrupt_randomness()
> taking a spinlock since it is called in the low-level interrupt
> routine.  Using atomic_t's and cmpxchg is also too expensive on some
> of the older architectures.  So we'll bite the bullet and use
> ACCESS_ONCE() and smp_rmb()/smp_wmb() to minimize the race windows
> when mixing in the entropy pool.

I don't think this will work correctly. It's important that simultaneous
_readers_ of the state get different results. Otherwise, you can get
things like duplicate UUIDs generated on different cores, something
that's been observed in the field(!). I thought I added a comment to
that effect some years back, but I guess not.

This means at a bare minimum, you need an atomic operation like a
cmpxchg on some component like input_rotate. Per-cpu mix pointers also
won't work as they can accidentally align. Per-cpu secret pads will
probably work, however, though it creates an interesting initialization
problem.

On the other hand, you don't care about any of this when not extracting
and you can be as fast and loose as you'd like.

> +	input_rotate = ACCESS_ONCE(r->input_rotate);
> +	i = ACCESS_ONCE(r->add_ptr);
>  
>  	/* mix one byte at a time to simplify size handling and churn faster */
>  	while (nbytes--) {
> @@ -514,19 +514,19 @@ static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
>  		input_rotate += i ? 7 : 14;
>  	}
>  
> -	r->input_rotate = input_rotate;
> -	r->add_ptr = i;
> +	ACCESS_ONCE(r->input_rotate) = input_rotate;
> +	ACCESS_ONCE(r->add_ptr) = i;
> +	local_irq_restore(flags);
> +	smp_wmb();
>  
>  	if (out)
>  		for (j = 0; j < 16; j++)
>  			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];

-- 
Mathematics is the supreme nostalgia of our time.


