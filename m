Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0GNWVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:21:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55890 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755883Ab0GNWVS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:21:18 -0400
Date: Wed, 14 Jul 2010 18:21:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714222115.GA30122@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714203940.GC22096@Krystal> <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:43:42 up 173 days, 20 min,  3 users,  load average: 0.02,
	0.05, 0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, Jul 14, 2010 at 1:39 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> >>  - load percpu NMI stack frame pointer
> >>  - if non-zero we know we're nested, and should ignore this NMI:
> >>     - we're returning to kernel mode, so return immediately by using
> >> "popf/ret", which also keeps NMI's disabled in the hardware until the
> >> "real" NMI iret happens.
> >
> > Maybe incrementing a per-cpu missed NMIs count could be appropriate here so we
> > know how many NMIs should be replayed at iret ?
> 
> No. As mentioned, there is no such counter in real hardware either.
> 
> Look at what happens for the not-nested case:
> 
>  - NMI1 triggers. The CPU takes a fault, and runs the NMI handler with
> NMI's disabled
> 
>  - NMI2 triggers. Nothing happens, the NMI's are disabled.
> 
>  - NMI3 triggers. Again, nothing happens, the NMI's are still disabled
> 
>  - the NMI handler returns.
> 
>  - What happens now?
> 
> How many NMI interrupts do you get? ONE. Exactly like my "emulate it
> in software" approach. The hardware doesn't have any counters for
> pending NMI's either. Why should the software emulation have them?

So I figure that given Maciej's response, we can get at most 2 nested nmis, no
more, no less. So I was probably going too far with the counter, but we need 2.
However, failure to deliver the second NMI in this case would not match the
hardware expectations (see below).

> 
> >>     - before the popf/iret, use the NMI stack pointer to make the NMI
> >> return stack be invalid and cause a fault
> >
> > I assume you mean "popf/ret" here.
> 
> Yes, that was as typo. The whole point of using popf was obviously to
> _avoid_ the iret ;)
> 
> > So assuming we use a frame copy, we should
> > change the nmi stack pointer in the nesting 0 nmi stack copy, so the nesting 0
> > NMI iret will trigger the fault
> >
> >>   - set the NMI stack pointer to the current stack pointer
> >
> > That would mean bringing back the NMI stack pointer to the (nesting - 1) nmi
> > stack copy.
> 
> I think you're confused. Or I am by your question.
> 
> The NMI code would literally just do:
> 
>  - check if the NMI was nested, by looking at whether the percpu
> nmi-stack-pointer is non-NULL
> 
>  - if it was nested, do nothing, an return with a popf/ret. The only
> stack this sequence might needs is to save/restore the register that
> we use for the percpu value (although maybe we can just co a "cmpl
> $0,%_percpu_seg:nmi_stack_ptr" and not even need that), and it's
> atomic because at this point we know that NMI's are disabled (we've
> not _yet_ taken any nested faults)
> 
>  - if it's a regular (non-nesting) NMI, we'd basically do
> 
>      6* pushq 48(%rsp)
> 
>    to copy the five words that the NMI pushed (ss/esp/eflags/cs/eip)
> and the one we saved ourselves (if we needed any, maybe we can make do
> with just 5 words).

Ah, right, you only need to do the copy and use the copy for the nesting level 0
NMI handler. The nested NMI can work on the "real" nmi stack because we never
expect it to fault.

> 
>  - then we just save that new stack pointer to the percpu thing with a simple
> 
>      movq %rsp,%__percpu_seg:nmi_stack_ptr
> 
> and we're all done. The final "iret" will do the right thing (either
> fault or return), and there are no races that I can see exactly
> because we use a single nmi-atomic instruction (the "iret" itself) to
> either re-enable NMI's _or_ test whether we should re-do an NMI.
> 
> There is a single-instruction window that is interestign in the return
> path, which is the window between the two final instructions:
> 
>     movl $0,%__percpu_seg:nmi_stack_ptr
>     iret
> 
> where I wonder what happens if we have re-enabled NMI (due to a fault
> in the NMI handler), but we haven't actually taken the NMI itself yet,
> so now we _will_ re-use the stack. Hmm. I suspect we need another of
> those horrible "if the NMI happens at this particular %rip" cases that
> we already have for the sysenter code on x86-32 for the NMI/DEBUG trap
> case of fixing up the stack pointer.

Yes, this was this exact instruction window I was worried about. I see another
possible failure mode:

- NMI
 - page fault
   - iret
 - NMI
   - set nmi_stack_ptr to 0, popf/lret.
 - page fault (yep, another one!)
   - iret
 - movl $0,%__percpu_seg:nmi_stack_ptr
 - iret

So in this case, movl/iret are executed with NMIs enabled. So if an NMI comes in
after the movl instruction, it will not detect that it is nested and will re-use
the percpu "nmi_stack_ptr" stack, squashing the "faulty" stack ptr with a brand
new one which won't trigger a fault. I'm afraid that in this case, the last NMI
handler will iret to the "nesting 0" handler at the iret instruction, which will
in turn return to itself, breaking all hell loose in the meantime (endless iret
loop).

So this also calls for special-casing an NMI nested on top of the following iret

 - movl $0,%__percpu_seg:nmi_stack_ptr
 - iret   <-----

instruction. At the beginning of the NMI handler, we could detect if we are
either nested over an NMI (checking nmi_stack_ptr != NULL) or if we are at this
specifica %rip, and assume we are nested in both cases.

> 
> And maybe I missed something else. But it does look reasonably simple.
> Subtle, but not a lot of code. And the code is all very much about the
> NMI itself, not about other random sequences. No?

If we can find a clean way to handle this NMI vs iret problem outside of the
entry_*.S code, within NMI-specific code, I'm indeed all for it. entry_*.s is
already complicated enough as it is. I think checking the %rip at NMI entry
could work out.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
