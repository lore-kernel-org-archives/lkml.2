Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0GNSMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:12:25 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37440 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757317Ab0GNSMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:12:23 -0400
Date: Wed, 14 Jul 2010 14:12:20 -0400
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
Message-ID: <20100714181220.GA32279@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <alpine.LFD.2.00.1007141732200.11778@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.2.00.1007141732200.11778@eddie.linux-mips.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:06:47 up 172 days, 20:43,  7 users,  load average: 0.00, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Maciej W. Rozycki (macro@linux-mips.org) wrote:
> On Wed, 14 Jul 2010, Mathieu Desnoyers wrote:
> 
> > This patch makes all faults, traps and exception safe to be called from NMI
> > context *except* single-stepping, which requires iret to restore the TF (trap
> > flag) and jump to the return address in a single instruction. Sorry, no kprobes
> 
>  Watch out for the RF flag too, that is not set correctly by POPFD -- that 
> may be important for faulting instructions that also have a hardware 
> breakpoint set at their address.
> 
> > support in NMI handlers because of this limitation. This cannot be emulated
> > with popf/lret, because lret would be single-stepped. It does not apply to
> > "immediate values" because they do not use single-stepping. This code detects if
> > the TF flag is set and uses the iret path for single-stepping, even if it
> > reactivates NMIs prematurely.
> 
>  What about the VM flag for VM86 tasks?  It cannot be changed by POPFD 
> either.
> 
>  How about only using the special return path when a nested exception is 
> about to return to the NMI handler?  You'd avoid all the odd cases then 
> that do not happen in the NMI context.

This is exactly what this patch does :-)

It selects the return path with

+       testl $NMI_MASK,TI_preempt_count(%ebp)
+       jz resume_kernel                /* Not nested over NMI ? */

In addition, about int3 breakpoints use in the kernel, AFAIK the handler does
not explicitly set the RF flag, and the breakpoint instruction (int3) appears
not to set it. (from my understanding of Intel's
Intel Architecture Software Developer’s Manual Volume 3: System Programming
15.3.1.1. INSTRUCTION-BREAKPOINT EXCEPTION C)

So it should be safe to set a int3 breakpoint in a NMI handler with this patch.
It's just the "single-stepping" feature of kprobes which is problematic.
Luckily, only int3 is needed for code patching bypass.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
