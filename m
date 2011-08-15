Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1HOREx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:04:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49113 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1HOREw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <9022c7d6f1724a37245fd744c8c16140.squirrel@www.skyhub.de>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <4E493449.70907@mit.edu> <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
 <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com> <9022c7d6f1724a37245fd744c8c16140.squirrel@www.skyhub.de>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 15 Aug 2011 13:04:32 -0400
X-Google-Sender-Auth: wvlJ6OggwloatAZBI-QgEqa3hrY
Message-ID: <CAObL_7ExSmbucefJ386LhK9UccVn5wKRvxHdLq0j__5bG2apwA@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: Borislav Petkov <bp@alien8.de>
Cc: melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:12 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, 15 August, 2011 5:36 pm, Andrew Lutomirski wrote:
>>> But still, irq_fpu_usable() still checks !in_interrupt() which means
>>> that we don't want to run SSE instructions in IRQ context. OTOH, we
>>> still are fine when running with CR0.TS. So what happens when we get an
>>> #NM as a result of executing an FPU instruction in an IRQ handler? We
>>> will have to do init_fpu() on the current task if the last hasn't used
>>> math yet and do the slab allocation of the FPU context area (I'm looking
>>> at math_state_restore, btw).
>>
>> IIRC kernel_fpu_begin does clts, so #NM won't happen.  But if we're in
>> an interrupt and TS=1, when we know that we're not in a
>> kernel_fpu_begin section, so it's safe to start one (and do clts).
>
> Doh, yes, I see it now. This way we save the math state of the current
> process if needed and "disable" #NM exceptions until kernel_fpu_end() by
> clearing CR0.TS, sure. Thanks.
>
>> IMO this code is not very good, and I plan to fix it sooner or later.
>
> Yep. Also, AFAIR, Hans did some FPU cleanup as part of his xsave rework.
> You could probably reuse some bits from there. The patchset should be in
> tip/x86/xsave.
>
>> I want kernel_fpu_begin (or its equivalent*) to be very fast and
>> usable from any context whatsoever.  Mucking with TS is slower than a
>> complete save and restore of YMM state.
>
> Well, I had a SSE memcpy which saved/restored the XMM regs on the stack.
> This would obviate the need to muck with contexts but that could get
> expensive wrt stack operations. The advantage is that I'm not dealing
> with the whole FPU state but only with 16 XMM regs. I should probably
> dust off that version again and retest.

I bet it won't be a significant win.  On Sandy Bridge, clts/stts takes
80 ns and a full state save+restore is only ~60 ns.  Without
infrastructure changes, I don't think you can avoid the clts and stts.

You might be able to get away with turning off IRQs, reading CR0 to
check TS, pushing XMM regs, and being very certain that you don't
accidentally generate any VEX-coded instructions.

>
> Or, if we want to use SSE stuff in the kernel, we might think of
> allocating its own FPU context(s) and handle those...

I'm thinking of having a stack of FPU states to parallel irq stacks
and IST stacks.  It gets a little hairy when code inside
kernel_fpu_begin traps for a non-irq non-IST reason, though.
Fortunately, those are rare and all of the EX_TABLE users could mark
xmm regs as clobbered (except for copy_from_user...).  Keeping
kernel_fpu_begin non-preemptable makes it less bad because the extra
FPU state can be per-cpu and not per-task.

This is extra fun on 32 bit, which IIRC doesn't have IST stacks.

The major speedup will come from saving state in kernel_fpu_begin but
not restoring it until the code in entry_??.S restores registers.

>
>> (*) kernel_fpu_begin is a bad name. It's only safe to use integer
>> instructions inside a kernel_fpu_begin section because MXCSR (and the
>> 387 equivalent) could contain garbage.
>
> Well, do we want to use floating point instructions in the kernel?

The only use I could find is in staging.

--Andy
