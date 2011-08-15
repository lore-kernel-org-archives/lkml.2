Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1HOTMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:12:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57520 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HOTMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <3175fc05afa1c2b0defd935d0fec22d5.squirrel@www.skyhub.de>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <4E493449.70907@mit.edu> <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
 <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com>
 <9022c7d6f1724a37245fd744c8c16140.squirrel@www.skyhub.de> <CAObL_7ExSmbucefJ386LhK9UccVn5wKRvxHdLq0j__5bG2apwA@mail.gmail.com>
 <3175fc05afa1c2b0defd935d0fec22d5.squirrel@www.skyhub.de>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 15 Aug 2011 15:11:40 -0400
X-Google-Sender-Auth: V0Ej7ZVK3wOBnD8I-aCNij1g_T0
Message-ID: <CAObL_7HPssPSaMMKdc-9LFKQXUnreFxMy4g8g2b7KdiRkBPW7w@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: Borislav Petkov <bp@alien8.de>
Cc: melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 2:49 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, 15 August, 2011 7:04 pm, Andrew Lutomirski wrote:
>>> Or, if we want to use SSE stuff in the kernel, we might think of
>>> allocating its own FPU context(s) and handle those...
>>
>> I'm thinking of having a stack of FPU states to parallel irq stacks
>> and IST stacks.
>
> ... I'm guessing with the same nesting as hardirqs? Making FPU
> instructions usable in irq contexts too.
>
>> It gets a little hairy when code inside kernel_fpu_begin traps for a
>> non-irq non-IST reason, though.
>
> How does that happen? You're in the kernel with preemption disabled and
> TS cleared, what would cause the #NM? I think that if you need to switch
> context, you simply "push" the current FPU context, allocate a new one
> and clts as part of the FPU context switching, no?

Not #NM, but page faults can happen too (even just accessing vmalloc space).

>
>> Fortunately, those are rare and all of the EX_TABLE users could mark
>> xmm regs as clobbered (except for copy_from_user...).
>
> Well, copy_from_user... does a bunch of rep; movsq - if the SSE version
> shows reasonable speedup there, we might need to make those work too.

I'm a little surprised that SSE beats fast string operations, but I
guess benchmarking always wins.

>
>> Keeping kernel_fpu_begin non-preemptable makes it less bad because the
>> extra FPU state can be per-cpu and not per-task.
>
> Yep.
>
>> This is extra fun on 32 bit, which IIRC doesn't have IST stacks.
>>
>> The major speedup will come from saving state in kernel_fpu_begin but
>> not restoring it until the code in entry_??.S restores registers.
>
> But you'd need to save each kernel FPU state when nesting, no?
>

Yes.  But we don't nest that much, and the save/restore isn't all that
expensive.  And we don't have to save/restore unless kernel entries
nest and both entries try to use kernel_fpu_begin at the same time.

This whole project may take awhile.  The code in there is a
poorly-documented mess, even after Hans' cleanups.  (It's a lot worse
without them, though.)

--Andy
