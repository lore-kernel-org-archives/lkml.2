Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0GNTVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:21:33 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:39706 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0GNTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:21:32 -0400
Date: Wed, 14 Jul 2010 20:21:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20100714181220.GA32279@Krystal>
Message-ID: <alpine.LFD.2.00.1007142009280.11778@eddie.linux-mips.org>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <alpine.LFD.2.00.1007141732200.11778@eddie.linux-mips.org> <20100714181220.GA32279@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Mathieu Desnoyers wrote:

> >  How about only using the special return path when a nested exception is 
> > about to return to the NMI handler?  You'd avoid all the odd cases then 
> > that do not happen in the NMI context.
> 
> This is exactly what this patch does :-)

 Ah, OK then -- I understood you actually tested the value of TF in the 
image to be restored.

> It selects the return path with
> 
> +       testl $NMI_MASK,TI_preempt_count(%ebp)
> +       jz resume_kernel                /* Not nested over NMI ? */
> 
> In addition, about int3 breakpoints use in the kernel, AFAIK the handler does
> not explicitly set the RF flag, and the breakpoint instruction (int3) appears
> not to set it. (from my understanding of Intel's
> Intel Architecture Software Developer’s Manual Volume 3: System Programming
> 15.3.1.1. INSTRUCTION-BREAKPOINT EXCEPTION C)

 The CPU only sets RF itself in the image saved in certain cases -- you'd 
see it set in the page fault handler for example, so that once the handler 
has finished any instruction breakpoint does not hit (presumably again, 
because the instruction breakpoint debug exception has the highest 
priority).  You mentioned the need to handle these faults.

> So it should be safe to set a int3 breakpoint in a NMI handler with this patch.
> 
> It's just the "single-stepping" feature of kprobes which is problematic.
> Luckily, only int3 is needed for code patching bypass.

 Actually the breakpoint exception handler should actually probably set RF 
explicitly, but that depends on the exact debugging scenario, so I can't 
comment on it further.  I don't know how INT3 is used in this context, so 
I'm just noting this may be a danger zone.

  Maciej
