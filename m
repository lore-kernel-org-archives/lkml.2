Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1DGI0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 04:26:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1DGI0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 04:26:15 -0400
Date: Thu, 7 Apr 2011 10:25:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407082550.GG24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
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


(Cc:-ed more memory ordering folks.)

* Andy Lutomirski <luto@MIT.EDU> wrote:

> RDTSC is completely unordered on modern Intel and AMD CPUs.  The
> Intel manual says that lfence;rdtsc causes all previous instructions
> to complete before the tsc is read, and the AMD manual says to use
> mfence;rdtsc to do the same thing.
> 
> We want a stronger guarantee, though: we want the tsc to be read
> before any memory access that occurs after the call to
> vclock_gettime (or vgettimeofday).  We currently guarantee that with
> a second lfence or mfence.  This sequence is not really supported by
> the manual (AFAICT) and it's also slow.
> 
> This patch changes the rdtsc to use implicit memory ordering instead
> of the second fence.  The sequence looks like this:
> 
> {l,m}fence
> rdtsc
> mov [something dependent on edx],[tmp]
> return [some function of tmp]
> 
> This means that the time stamp has to be read before the load, and
> the return value depends on tmp.  All x86-64 chips guarantee that no
> memory access after a load moves before that load.  This means that
> all memory access after vread_tsc occurs after the time stamp is
> read.
> 
> The trick is that the answer should not actually change as a result
> of the sneaky memory access.  I accomplish this by shifting rdx left
> by 32 bits, twice, to generate the number zero.  (I can't imagine
> that any CPU can break that dependency.)  Then I use "zero" as an
> offset to a memory access that we had to do anyway.
> 
> On Sandy Bridge (i7-2600), this improves a loop of
> clock_gettime(CLOCK_MONOTONIC) by 5 ns/iter (from ~22.7 to ~17.7).
> time-warp-test still passes.
> 
> I suspect that it's sufficient to just load something dependent on
> edx without using the result, but I don't see any solid evidence in
> the manual that CPUs won't eliminate useless loads.  I leave scary
> stuff like that to the real experts.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/kernel/tsc.c |   37 ++++++++++++++++++++++++++++++-------
>  1 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index bc46566..858c084 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -767,18 +767,41 @@ static cycle_t read_tsc(struct clocksource *cs)
>  static cycle_t __vsyscall_fn vread_tsc(void)
>  {
>  	cycle_t ret;
> +	u64 zero, last;
>  
>  	/*
> -	 * Surround the RDTSC by barriers, to make sure it's not
> -	 * speculated to outside the seqlock critical section and
> -	 * does not cause time warps:
> +	 * rdtsc is unordered, and we want it to be ordered like
> +	 * a load with respect to other CPUs (and we don't want
> +	 * it to execute absurdly early wrt code on this CPU).
> +	 * rdtsc_barrier() is a barrier that provides this ordering
> +	 * with respect to *earlier* loads.  (Which barrier to use
> +	 * depends on the CPU.)
>  	 */
>  	rdtsc_barrier();
> -	ret = (cycle_t)vget_cycles();
> -	rdtsc_barrier();
>  
> -	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
> -		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
> +	asm volatile ("rdtsc\n\t"
> +		      "shl $0x20,%%rdx\n\t"
> +		      "or %%rdx,%%rax\n\t"
> +		      "shl $0x20,%%rdx"
> +		      : "=a" (ret), "=d" (zero) : : "cc");
> +
> +	/*
> +	 * zero == 0, but as far as the processor is concerned, zero
> +	 * depends on the output of rdtsc.  So we can use it as a
> +	 * load barrier by loading something that depends on it.
> +	 * x86-64 keeps all loads in order wrt each other, so this
> +	 * ensures that rdtsc is ordered wrt all later loads.
> +	 */
> +
> +	/*
> +	 * This doesn't multiply 'zero' by anything, which *should*
> +	 * generate nicer code, except that gcc cleverly embeds the
> +	 * dereference into the cmp and the cmovae.  Oh, well.
> +	 */
> +	last = *( (cycle_t *)
> +		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
> +
> +	return ret >= last ? ret : last;

Ok, that's like totally sick ;-)

It's a software barrier in essence, using data dependency obfuscation.

First objection would be the extra memory references: we have a general 
aversion against memory references. The memory reference here is arguably 
special, it is to the stack so should be in cache and should be pretty fast.

But the code really looks too tricky for its own good.

For example this assumption:

> The trick is that the answer should not actually change as a result
> of the sneaky memory access.  I accomplish this by shifting rdx left
> by 32 bits, twice, to generate the number zero.  (I can't imagine
> that any CPU can break that dependency.)  Then I use "zero" as an

is not particularly future-proof. Yes, i doubt any CPU will bother to figure 
out the data dependency across such a sequence, but synthetic CPUs might and 
who knows what the far future brings.

Also, do we *really* have RDTSC SMP-coherency guarantees on multi-socket CPUs 
today? It now works on multi-core, but on bigger NUMA i strongly doubt it. So 
this hack tries to preserve something that we wont be able to offer anyway.

So the much better optimization would be to give up on exact GTOD coherency and 
just make sure the same task does not see time going backwards. If user-space 
wants precise coherency it can use synchronization primitives itsef. By default 
it would get the fast and possibly off by a few cycles thing instead. We'd 
never be seriously jump in time - only small jumps would happen in practice, 
depending on CPU parallelism effects.

If we do that then the optimization would be to RDTSC and not use *any* of the 
barriers, neither the hardware ones nor your tricky software data-dependency 
obfuscation barrier.

Note that doing this will also have other advantages: we wont really need 
alternatives patching, thus we could more easily move this code into .S - which 
would allow further optimizations, such as the elimination of this GCC 
inflicted slowdown:

> +	/*
> +	 * This doesn't multiply 'zero' by anything, which *should*
> +	 * generate nicer code, except that gcc cleverly embeds the
> +	 * dereference into the cmp and the cmovae.  Oh, well.
> +	 */
> +	last = *( (cycle_t *)
> +		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
> +
> +	return ret >= last ? ret : last;

Thanks,

	Ingo
