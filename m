Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HOSuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:50:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44551 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1HOSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:50:00 -0400
Message-ID: <3175fc05afa1c2b0defd935d0fec22d5.squirrel@www.skyhub.de>
In-Reply-To: <CAObL_7ExSmbucefJ386LhK9UccVn5wKRvxHdLq0j__5bG2apwA@mail.gmail.com>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
    <4E493449.70907@mit.edu>
    <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
    <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com>
    <9022c7d6f1724a37245fd744c8c16140.squirrel@www.skyhub.de>
    <CAObL_7ExSmbucefJ386LhK9UccVn5wKRvxHdLq0j__5bG2apwA@mail.gmail.com>
Date: Mon, 15 Aug 2011 20:49:56 +0200 (CEST)
Subject: Re: x86 memcpy performance
From: "Borislav Petkov" <bp@alien8.de>
To: "Andrew Lutomirski" <luto@mit.edu>
Cc: "Borislav Petkov" <bp@alien8.de>, "melwyn lobo" <linux.melwyn@gmail.com>,
        "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 August, 2011 7:04 pm, Andrew Lutomirski wrote:
>> Well, I had a SSE memcpy which saved/restored the XMM regs on the stack.
>> This would obviate the need to muck with contexts but that could get
>> expensive wrt stack operations. The advantage is that I'm not dealing
>> with the whole FPU state but only with 16 XMM regs. I should probably
>> dust off that version again and retest.
>
> I bet it won't be a significant win.  On Sandy Bridge, clts/stts takes
> 80 ns and a full state save+restore is only ~60 ns.
> Without infrastructure changes, I don't think you can avoid the clts
> and stts.

Yeah, probably.

> You might be able to get away with turning off IRQs, reading CR0 to
> check TS, pushing XMM regs, and being very certain that you don't
> accidentally generate any VEX-coded instructions.

That's ok - I'm using movaps/movups. But, the problem is that I still
need to save FPU state if the task I'm interrupting has been using FPU
instructions. So, I can't get away without saving the context in which
case I don't need to save the XMM regs anyway.

>> Or, if we want to use SSE stuff in the kernel, we might think of
>> allocating its own FPU context(s) and handle those...
>
> I'm thinking of having a stack of FPU states to parallel irq stacks
> and IST stacks.

... I'm guessing with the same nesting as hardirqs? Making FPU
instructions usable in irq contexts too.

> It gets a little hairy when code inside kernel_fpu_begin traps for a
> non-irq non-IST reason, though.

How does that happen? You're in the kernel with preemption disabled and
TS cleared, what would cause the #NM? I think that if you need to switch
context, you simply "push" the current FPU context, allocate a new one
and clts as part of the FPU context switching, no?

> Fortunately, those are rare and all of the EX_TABLE users could mark
> xmm regs as clobbered (except for copy_from_user...).

Well, copy_from_user... does a bunch of rep; movsq - if the SSE version
shows reasonable speedup there, we might need to make those work too.

> Keeping kernel_fpu_begin non-preemptable makes it less bad because the
> extra FPU state can be per-cpu and not per-task.

Yep.

> This is extra fun on 32 bit, which IIRC doesn't have IST stacks.
>
> The major speedup will come from saving state in kernel_fpu_begin but
> not restoring it until the code in entry_??.S restores registers.

But you'd need to save each kernel FPU state when nesting, no?

>>> (*) kernel_fpu_begin is a bad name. It's only safe to use integer
>>> instructions inside a kernel_fpu_begin section because MXCSR (and the
>>> 387 equivalent) could contain garbage.
>>
>> Well, do we want to use floating point instructions in the kernel?
>
> The only use I could find is in staging.

Exactly my point - I think we should do it only when it's really worth
the trouble.

-- 
Regards/Gruss,
Boris.

