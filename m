Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab0GNT6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:58:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35498 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668Ab0GNT6n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:58:43 -0400
Date: Wed, 14 Jul 2010 15:58:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100714195840.GA14904@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <alpine.LFD.2.00.1007141732200.11778@eddie.linux-mips.org> <20100714181220.GA32279@Krystal> <alpine.LFD.2.00.1007142009280.11778@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.2.00.1007142009280.11778@eddie.linux-mips.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:23:31 up 172 days, 22:00,  6 users,  load average: 0.00, 0.02,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Maciej W. Rozycki (macro@linux-mips.org) wrote:
> On Wed, 14 Jul 2010, Mathieu Desnoyers wrote:
> 
> > >  How about only using the special return path when a nested exception is 
> > > about to return to the NMI handler?  You'd avoid all the odd cases then 
> > > that do not happen in the NMI context.
> > 
> > This is exactly what this patch does :-)
> 
>  Ah, OK then -- I understood you actually tested the value of TF in the 
> image to be restored.

It tests it too. When it detects that the return path is about to return to a
NMI handler, it checks if the TF flag is set. If it is set, then "iret" is
really needed, because TF can only single-step an instruction when set by
"iret". The popf/ret scheme would otherwise trap at the "ret" instruction that
follows popf. Anyway, single-stepping is really discouraged in nmi handlers,
because there is no way to go around the iret.

> 
> > It selects the return path with
> > 
> > +       testl $NMI_MASK,TI_preempt_count(%ebp)
> > +       jz resume_kernel                /* Not nested over NMI ? */
> > 
> > In addition, about int3 breakpoints use in the kernel, AFAIK the handler does
> > not explicitly set the RF flag, and the breakpoint instruction (int3) appears
> > not to set it. (from my understanding of Intel's
> > Intel Architecture Software Developer’s Manual Volume 3: System Programming
> > 15.3.1.1. INSTRUCTION-BREAKPOINT EXCEPTION C)
> 
>  The CPU only sets RF itself in the image saved in certain cases -- you'd 
> see it set in the page fault handler for example, so that once the handler 
> has finished any instruction breakpoint does not hit (presumably again, 
> because the instruction breakpoint debug exception has the highest 
> priority).  You mentioned the need to handle these faults.

Well, the only case where I think it might make sense to allow a breakpoint in
NMI handler code would be to temporarily replace a static branch, which should
in no way be able to trigger any other fault.

> 
> > So it should be safe to set a int3 breakpoint in a NMI handler with this patch.
> > 
> > It's just the "single-stepping" feature of kprobes which is problematic.
> > Luckily, only int3 is needed for code patching bypass.
> 
>  Actually the breakpoint exception handler should actually probably set RF 
> explicitly, but that depends on the exact debugging scenario, so I can't 
> comment on it further.  I don't know how INT3 is used in this context, so 
> I'm just noting this may be a danger zone.

In the case of temporary bypass, the int3 is only there to divert the
instruction execution flow to somewhere else, and we come back to the original
code at the address following the instruction which has the breakpoint. So
basically, we never come back to the original instruction, ever. We might as
well just clear the RF flag from the EFLAGS image before popf.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
