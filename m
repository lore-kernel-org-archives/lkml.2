Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab1CXRNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:13:13 -0400
Received: from relay2.sgi.com ([192.48.179.30]:53437 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933892Ab1CXRNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:13:10 -0400
Date: Thu, 24 Mar 2011 12:13:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	test_and_set_bit_lock if possible
Message-ID: <20110324171308.GC28825@sgi.com>
References: <201103241026.01624.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103241026.01624.knikanth@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 10:26:01AM +0530, Nikanth Karthikesan wrote:
> On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> signal can stall other CPUs. And as the number of cores increase this penalty
> scales proportionately. So it is best to try and avoid atomic instructions
> wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if it
> finds the bit set already.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 



Don't we also have an issue related to the coherency protocols. 

If the cacheline is referenced by a test-and-set instruction and
the line does not currently reside in the local caches, it is fetched
for exclusive access using a single off-socket request.

If the code first reads the CL, then does a test-and-set, the line
may be first read in shared mode. Then a second off-socket request must be issued to
obtain exclusive access. This can be a serious issue on large systems.
If the bit is typically already set, the new code is a big win but is this
the case? I suspect not.


Do we need a new variant of test-and-set? The new variant would
first test the bit, then set it if not already set. This would be used only
in places where the bit is likely already set.  The downside is that it is
frequently difficult to predict whether the bit is already set.


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
> +
> +/**
>   * __ffs - find first set bit in word
>   * @word: The word to search
>   *
