Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1DGHzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:55:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1DGHzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:55:07 -0400
Date: Thu, 7 Apr 2011 09:54:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 3/6] x86-64: Don't generate cmov in vread_tsc
Message-ID: <20110407075456.GC24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <49856c9e1325fd1a1f1786f05a7f2befe14666d6.1302137785.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49856c9e1325fd1a1f1786f05a7f2befe14666d6.1302137785.git.luto@mit.edu>
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


* Andy Lutomirski <luto@mit.edu> wrote:

> vread_tsc checks whether rdtsc returns something less than
> cycle_last, which is an extremely predictable branch.  GCC likes
> to generate a cmov anyway, which is several cycles slower than
> a predicted branch.  This saves a couple of nanoseconds.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/kernel/tsc.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 858c084..69ff619 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -794,14 +794,25 @@ static cycle_t __vsyscall_fn vread_tsc(void)
>  	 */
>  
>  	/*
> -	 * This doesn't multiply 'zero' by anything, which *should*
> -	 * generate nicer code, except that gcc cleverly embeds the
> -	 * dereference into the cmp and the cmovae.  Oh, well.
> +	 * This doesn't multiply 'zero' by anything, which generates
> +	 * very slightly nicer code than multiplying it by 8.
>  	 */
>  	last = *( (cycle_t *)
>  		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
>  
> -	return ret >= last ? ret : last;
> +	if (likely(ret >= last))
> +		return ret;
> +
> +	/*
> +	 * GCC likes to generate cmov here, but this branch is extremely
> +	 * predictable (it's just a funciton of time and the likely is
> +	 * very likely) and there's a data dependence, so force GCC
> +	 * to generate a branch instead.  I don't barrier() because
> +	 * we don't actually need a barrier, and if this function
> +	 * ever gets inlined it will generate worse code.
> +	 */
> +	asm volatile ("");

Hm, you have not addressed the review feedback i gave in:

  Message-ID: <20110329061546.GA27398@elte.hu>

Thanks,

	Ingo
