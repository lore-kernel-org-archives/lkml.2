Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0GNUgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:36:35 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48050 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab0GNUge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:36:34 -0400
Date: Wed, 14 Jul 2010 21:36:32 +0100 (BST)
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
In-Reply-To: <20100714195840.GA14904@Krystal>
Message-ID: <alpine.LFD.2.00.1007142121010.11778@eddie.linux-mips.org>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <alpine.LFD.2.00.1007141732200.11778@eddie.linux-mips.org> <20100714181220.GA32279@Krystal> <alpine.LFD.2.00.1007142009280.11778@eddie.linux-mips.org>
 <20100714195840.GA14904@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Mathieu Desnoyers wrote:

> It tests it too. When it detects that the return path is about to return to a
> NMI handler, it checks if the TF flag is set. If it is set, then "iret" is
> really needed, because TF can only single-step an instruction when set by
> "iret". The popf/ret scheme would otherwise trap at the "ret" instruction that
> follows popf. Anyway, single-stepping is really discouraged in nmi handlers,
> because there is no way to go around the iret.

 Hmm, with Pentium Pro and more recent processors there is actually a 
nasty hack that will let you get away with POPF/RET and TF set. ;)  You 
can try it if you like and can arrange for an appropriate scenario.

> In the case of temporary bypass, the int3 is only there to divert the
> instruction execution flow to somewhere else, and we come back to the original
> code at the address following the instruction which has the breakpoint. So
> basically, we never come back to the original instruction, ever. We might as
> well just clear the RF flag from the EFLAGS image before popf.

 Yes, if you return to elsewhere, then that's actually quite desirable 
IMHO.

 This RF flag is quite complicated to handle and there are some errata 
involved too.  If I understand it correctly, all fault-class exception 
handlers are expected to set it manually in the image to be restored if 
they return to the original faulting instruction (that includes the debug 
exception handler if it was invoked as a fault, i.e. in response to an 
instruction breakpoint).  Then all trap-class exception handlers are 
expected to clear the flag (and that includes the debug exception handler 
if it was invoked as a trap, e.g. in response to a data breakpoint or a 
single step).  I haven't checked if Linux gets these bits right, but it 
may be worth doing so.

 For the record -- GDB hardly cares, because it removes any instruction 
breakpoints before it is asked to resume execution of an instruction that 
has a breakpoint set at, single-steps the instruction with all the other 
threads locked out and then reinserts the breakpoints so that they can hit 
again.  Then it proceeds with whatever should be done next to fulfil the 
execution request.

  Maciej
