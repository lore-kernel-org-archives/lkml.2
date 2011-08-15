Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1HOPaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:30:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35238 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1HOPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:30:00 -0400
Message-ID: <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
In-Reply-To: <4E493449.70907@mit.edu>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
    <4E493449.70907@mit.edu>
Date: Mon, 15 Aug 2011 17:29:54 +0200 (CEST)
Subject: Re: x86 memcpy performance
From: "Borislav Petkov" <bp@alien8.de>
To: "Andy Lutomirski" <luto@MIT.EDU>
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

On Mon, 15 August, 2011 4:59 pm, Andy Lutomirski wrote:
>>> So what is the reason we cannot use sse_memcpy in interrupt context.
>>> (fpu registers not saved ? )
>>
>> Because, AFAICT, when we handle an #NM exception while running
>> sse_memcpy in an IRQ handler, we might need to allocate FPU save state
>> area, which in turn, can sleep. Then, we might get another IRQ while
>> sleeping and we should be deadlocked.
>>
>> But let me stress on the "AFAICT" above, someone who actually knows the
>> FPU code should correct me if I'm missing something.
>
> I don't think you ever get #NM as a result of kernel_fpu_begin, but you
> can certainly have problems when kernel_fpu_begin nests by accident.
> There's irq_fpu_usable() for this.
>
> (irq_fpu_usable() reads cr0 sometimes and I suspect it can be slow.)

Oh I didn't know about irq_fpu_usable(), thanks.

But still, irq_fpu_usable() still checks !in_interrupt() which means
that we don't want to run SSE instructions in IRQ context. OTOH, we
still are fine when running with CR0.TS. So what happens when we get an
#NM as a result of executing an FPU instruction in an IRQ handler? We
will have to do init_fpu() on the current task if the last hasn't used
math yet and do the slab allocation of the FPU context area (I'm looking
at math_state_restore, btw).

Thanks.

-- 
Regards/Gruss,
Boris.

