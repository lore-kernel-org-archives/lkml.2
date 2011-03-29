Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1C2GSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:18:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1C2GSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:18:45 -0400
Date: Tue, 29 Mar 2011 08:18:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110329061825.GB27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu>
 <bd92441ac72b3aa162dcd58422334e2091095c33.1301324270.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd92441ac72b3aa162dcd58422334e2091095c33.1301324270.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Andy Lutomirski <luto@MIT.EDU> wrote:

> @@ -767,18 +767,38 @@ static cycle_t read_tsc(struct clocksource *cs)
>  static cycle_t __vsyscall_fn vread_tsc(void)
>  {
>  	cycle_t ret;
> -
> -	/*
> -	 * Surround the RDTSC by barriers, to make sure it's not
> -	 * speculated to outside the seqlock critical section and
> -	 * does not cause time warps:
> +	u64 zero, last;
> +
> +	/* rdtsc is unordered, and we want it to be ordered like
> +	 * a load with respect to other CPUs (and we don't want
> +	 * it to execute absurdly early wrt code on this CPU.)
> +	 * rdtsc_barrier() is a barrier that provides this ordering
> +	 * with respect to *earlier* loads.  (Which barrier to use
> +	 * depends on the CPU.)
>  	 */
>  	rdtsc_barrier();
> -	ret = (cycle_t)vget_cycles();
> -	rdtsc_barrier();
>  
> -	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
> -		ret : __vsyscall_gtod_data.clock.cycle_last;
> +	asm volatile ("rdtsc\n\t"
> +		      "shl $0x20,%%rdx\n\t"
> +		      "or %%rdx,%%rax\n\t"
> +		      "shl $0x20,%%rdx"
> +		      : "=a" (ret), "=d" (zero) : : "cc");
> +
> +	/* zero == 0, but as far as the processor is concerned, zero
> +	 * depends on the output of rdtsc.  So we can use it as a
> +	 * load barrier by loading something that depends on it.
> +	 * x86-64 keeps all loads in order wrt each other, so this
> +	 * ensures that rdtsc is ordered wrt all later loads.
> +	 */
> +
> +	/* This doesn't multiply 'zero' by anything, which *should*
> +	 * generate nicer code, except that gcc cleverly embeds the
> +	 * dereference into the cmp and the cmovae.  Oh, well.
> +	 */
> +	last = *( (cycle_t *)
> +		  ((char *)&__vsyscall_gtod_data.clock.cycle_last + zero) );
> +
> +	return ret >= last ? ret : last;

Looks like GCC hurts performance here more than it helps. Have you considered 
putting the whole function into assembly in a .S file? How maintainable does it 
look like?

Thanks,

	Ingo
