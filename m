Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1DGLoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:44:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1DGLob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FIW+t61A7onB+jV8NzBBIDM1kPVhoMLQ6qq7rZEizjDhBVvm4Wpxhh8HfknqwVnkAN
         03pvCj+m21g1Yjwj6WPKniXdHE5mT65mYF3cSRzbRNpOdqmBJp/xoAtHQqdu6/eT4aVS
         LHQx5Dowd2QQvrV4MnzpE5pbwplXqgxPo30SM=
MIME-Version: 1.0
In-Reply-To: <20110407082550.GG24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <20110407082550.GG24879@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 7 Apr 2011 07:44:09 -0400
X-Google-Sender-Auth: AaP9uj0dEni63GTieY9Li5spvYE
Message-ID: <BANLkTik=Gefr11qyJ1cDer3mv76SUu8h_g@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 4:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> (Cc:-ed more memory ordering folks.)
>

>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -767,18 +767,41 @@ static cycle_t read_tsc(struct clocksource *cs)
>>  static cycle_t __vsyscall_fn vread_tsc(void)
>>  {
>>       cycle_t ret;
>> +     u64 zero, last;
>>
>>       /*
>> -      * Surround the RDTSC by barriers, to make sure it's not
>> -      * speculated to outside the seqlock critical section and
>> -      * does not cause time warps:
>> +      * rdtsc is unordered, and we want it to be ordered like
>> +      * a load with respect to other CPUs (and we don't want
>> +      * it to execute absurdly early wrt code on this CPU).
>> +      * rdtsc_barrier() is a barrier that provides this ordering
>> +      * with respect to *earlier* loads.  (Which barrier to use
>> +      * depends on the CPU.)
>>        */
>>       rdtsc_barrier();
>> -     ret = (cycle_t)vget_cycles();
>> -     rdtsc_barrier();
>>
>> -     return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
>> -             ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
>> +     asm volatile ("rdtsc\n\t"
>> +                   "shl $0x20,%%rdx\n\t"
>> +                   "or %%rdx,%%rax\n\t"
>> +                   "shl $0x20,%%rdx"
>> +                   : "=a" (ret), "=d" (zero) : : "cc");
>> +
>> +     /*
>> +      * zero == 0, but as far as the processor is concerned, zero
>> +      * depends on the output of rdtsc.  So we can use it as a
>> +      * load barrier by loading something that depends on it.
>> +      * x86-64 keeps all loads in order wrt each other, so this
>> +      * ensures that rdtsc is ordered wrt all later loads.
>> +      */
>> +
>> +     /*
>> +      * This doesn't multiply 'zero' by anything, which *should*
>> +      * generate nicer code, except that gcc cleverly embeds the
>> +      * dereference into the cmp and the cmovae.  Oh, well.
>> +      */
>> +     last = *( (cycle_t *)
>> +               ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
>> +
>> +     return ret >= last ? ret : last;
>
> Ok, that's like totally sick ;-)
>
> It's a software barrier in essence, using data dependency obfuscation.
>
> First objection would be the extra memory references: we have a general
> aversion against memory references. The memory reference here is arguably
> special, it is to the stack so should be in cache and should be pretty fast.
>
> But the code really looks too tricky for its own good.
>
> For example this assumption:
>
>> The trick is that the answer should not actually change as a result
>> of the sneaky memory access.  I accomplish this by shifting rdx left
>> by 32 bits, twice, to generate the number zero.  (I can't imagine
>> that any CPU can break that dependency.)  Then I use "zero" as an
>
> is not particularly future-proof. Yes, i doubt any CPU will bother to figure
> out the data dependency across such a sequence, but synthetic CPUs might and
> who knows what the far future brings.

That's fixable with a bit more work.  Imagine (whitespace damanged):

     asm volatile ("rdtsc\n\t"
                   "shl $0x20,%%rdx\n\t"
                   "or %%rdx,%%rax\n\t"
                   "shr $0x3f,%%rdx"
                   : "=a" (ret), "=d" (zero_or_one) : : "cc");

    last = VVAR(vsyscall_gtod_data).clock.cycle_last[zero_or_one];

For this to work, cycle_last would have to be an array containing two
identical values, and we'd want to be a little careful to keep the
whole mess in one cacheline.  Now I think it's really safe because
zero_or_one isn't constant at all, so the CPU has to wait for its
value no matter how clever it is.

>
> Also, do we *really* have RDTSC SMP-coherency guarantees on multi-socket CPUs
> today? It now works on multi-core, but on bigger NUMA i strongly doubt it. So
> this hack tries to preserve something that we wont be able to offer anyway.
>
> So the much better optimization would be to give up on exact GTOD coherency and
> just make sure the same task does not see time going backwards. If user-space
> wants precise coherency it can use synchronization primitives itsef. By default
> it would get the fast and possibly off by a few cycles thing instead. We'd
> never be seriously jump in time - only small jumps would happen in practice,
> depending on CPU parallelism effects.
>
> If we do that then the optimization would be to RDTSC and not use *any* of the
> barriers, neither the hardware ones nor your tricky software data-dependency
> obfuscation barrier.

IIRC I measured 200ns time warps on Sandy Bridge when I tried that.
(I think you won't see them that easily with time-warp-test in TSC
mode, because there's a locking instruction before the rdtsc and very
close to it.)  It would save about 4ns more, I think, which isn't bad.

Personally, I'm working on this code because I'm migrating a bunch of
code that likes to timestamp itself from Windows to Linux, and one of
the really big attractions to Linux is that it has clock_gettime,
which is fast, pretty much warp-free, and actually shows *wall* time
with high precision.  The closest thing that Windows has is
QueryPerformanceCounter, which is a giant PITA because it doesn't
track wall time (although it's still slightly faster than
clock_gettime even with this patch).  If I have to re-add
software-enforced clock coherency to the Linux version, I'll be sad.

--Andy

>
> Note that doing this will also have other advantages: we wont really need
> alternatives patching, thus we could more easily move this code into .S - which
> would allow further optimizations, such as the elimination of this GCC
> inflicted slowdown:
>
>> +     /*
>> +      * This doesn't multiply 'zero' by anything, which *should*
>> +      * generate nicer code, except that gcc cleverly embeds the
>> +      * dereference into the cmp and the cmovae.  Oh, well.
>> +      */
>> +     last = *( (cycle_t *)
>> +               ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
>> +
>> +     return ret >= last ? ret : last;
>
> Thanks,
>
>        Ingo
>
