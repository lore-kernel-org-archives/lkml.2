Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1CXI5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:57:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41960 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab1CXI5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:57:04 -0400
Date: Thu, 24 Mar 2011 09:56:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110324085647.GI30812@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103241026.01624.knikanth@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikanth Karthikesan <knikanth@suse.de> wrote:

> On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> signal can stall other CPUs. And as the number of cores increase this penalty
> scales proportionately. So it is best to try and avoid atomic instructions
> wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if it
> finds the bit set already.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 903683b..26a42ff 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -203,19 +203,6 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
>  }
>  
>  /**
> - * test_and_set_bit_lock - Set a bit and return its old value for lock
> - * @nr: Bit to set
> - * @addr: Address to count from
> - *
> - * This is the same as test_and_set_bit on x86.
> - */
> -static __always_inline int
> -test_and_set_bit_lock(int nr, volatile unsigned long *addr)
> -{
> -	return test_and_set_bit(nr, addr);
> -}
> -
> -/**
>   * __test_and_set_bit - Set a bit and return its old value
>   * @nr: Bit to set
>   * @addr: Address to count from
> @@ -339,6 +326,25 @@ static int test_bit(int nr, const volatile unsigned long *addr);
>  	 : variable_test_bit((nr), (addr)))
>  
>  /**
> + * test_and_set_bit_lock - Set a bit and return its old value for lock
> + * @nr: Bit to set
> + * @addr: Address to count from
> + *
> + * This is the same as test_and_set_bit on x86. But atomic operation is
> + * avoided, if the bit was already set.
> + */
> +static __always_inline int
> +test_and_set_bit_lock(int nr, volatile unsigned long *addr)
> +{
> +#ifdef CONFIG_SMP
> +	barrier();
> +	if (test_bit(nr, addr))
> +		return 1;
> +#endif
> +	return test_and_set_bit(nr, addr);
> +}

On modern x86 CPUs there's no "#LOCK signal" anymore - it's replaced by a 
M[O]ESI cache coherency bus. I'd expect modern x86 CPUs to be pretty fast when 
the cacheline is local and the bit is set already.

So you really need to back up your patch with actual hard numbers. Putting this 
code into user-space and using pthreads to loop on the same global variable and 
testing the before/after effect would be sufficient i think. You can use 'perf 
stat --repeat 10' kind of measurements to see whether there's any improvement 
larger than the noise of the measurement.

Thanks,

	Ingo
