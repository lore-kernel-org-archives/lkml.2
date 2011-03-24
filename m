Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab1CXIvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:51:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34842 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754Ab1CXIvm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:8:1>);
	Thu, 24 Mar 2011 04:51:42 -0400
Message-Id: <4D8B1463020000780003806C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 24 Mar 2011 08:52:35 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Nikanth Karthikesan" <knikanth@suse.de>
Cc: "Nick Piggin" <npiggin@kernel.dk>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Ingo Molnar" <mingo@redhat.com>, "Jack Steiner" <steiner@sgi.com>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	 test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
In-Reply-To: <201103241026.01624.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.03.11 at 05:56, Nikanth Karthikesan <knikanth@suse.de> wrote:
> On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> signal can stall other CPUs. And as the number of cores increase this 
> penalty
> scales proportionately. So it is best to try and avoid atomic instructions
> wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if it
> finds the bit set already.

Why don't you do this in test_and_set_bit() instead?

Jan

> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 903683b..26a42ff 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -203,19 +203,6 @@ static inline int test_and_set_bit(int nr, volatile 
> unsigned long *addr)
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
> @@ -339,6 +326,25 @@ static int test_bit(int nr, const volatile unsigned long 
> *addr);
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



