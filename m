Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1HOPhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:37:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35381 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1HOPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:37:03 -0400
MIME-Version: 1.0
In-Reply-To: <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <4E493449.70907@mit.edu> <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 15 Aug 2011 11:36:42 -0400
X-Google-Sender-Auth: gQly18FGZh503vZqPcsL3M63PEw
Message-ID: <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com>
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

On Mon, Aug 15, 2011 at 11:29 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, 15 August, 2011 4:59 pm, Andy Lutomirski wrote:
>>>> So what is the reason we cannot use sse_memcpy in interrupt context.
>>>> (fpu registers not saved ? )
>>>
>>> Because, AFAICT, when we handle an #NM exception while running
>>> sse_memcpy in an IRQ handler, we might need to allocate FPU save state
>>> area, which in turn, can sleep. Then, we might get another IRQ while
>>> sleeping and we should be deadlocked.
>>>
>>> But let me stress on the "AFAICT" above, someone who actually knows the
>>> FPU code should correct me if I'm missing something.
>>
>> I don't think you ever get #NM as a result of kernel_fpu_begin, but you
>> can certainly have problems when kernel_fpu_begin nests by accident.
>> There's irq_fpu_usable() for this.
>>
>> (irq_fpu_usable() reads cr0 sometimes and I suspect it can be slow.)
>
> Oh I didn't know about irq_fpu_usable(), thanks.
>
> But still, irq_fpu_usable() still checks !in_interrupt() which means
> that we don't want to run SSE instructions in IRQ context. OTOH, we
> still are fine when running with CR0.TS. So what happens when we get an
> #NM as a result of executing an FPU instruction in an IRQ handler? We
> will have to do init_fpu() on the current task if the last hasn't used
> math yet and do the slab allocation of the FPU context area (I'm looking
> at math_state_restore, btw).

IIRC kernel_fpu_begin does clts, so #NM won't happen.  But if we're in
an interrupt and TS=1, when we know that we're not in a
kernel_fpu_begin section, so it's safe to start one (and do clts).

IMO this code is not very good, and I plan to fix it sooner or later.
I want kernel_fpu_begin (or its equivalent*) to be very fast and
usable from any context whatsoever.  Mucking with TS is slower than a
complete save and restore of YMM state.

(*)  kernel_fpu_begin is a bad name.  It's only safe to use integer
instructions inside a kernel_fpu_begin section because MXCSR (and the
387 equivalent) could contain garbage.

--Andy
