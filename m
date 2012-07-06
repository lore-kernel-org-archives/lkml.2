Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2GFUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:48:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:51671 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2GFUsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:48:45 -0400
Message-ID: <1341607713.7709.68.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Fri, 06 Jul 2012 22:48:33 +0200
In-Reply-To: <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 11:34 -0700, Linus Torvalds wrote:
> On Fri, Jul 6, 2012 at 11:16 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > If some code then changes the values in the pt_regs, it is *that* code
> > that needs to think twice about what it does. Where is that code?
> 
> From a quick grep it looks like it is __intel_pmu_pebs_event() that does this.

Correct, as well as perf_ibs_handle_irq() and I'll have to have a good
look at the BTS stuff.

> THAT is where you would possibly have a huge honking big comment about
> how you have to fake the CS register contents because the PEBS
> information is incomplete. But make it clear that it is a total hack.

OK.

> Also, somebody should check. Is the PEBS information *actually* the
> instruction pointer (address within the code segment), or is it the
> "linear address" (segment base + rip)? I hope it is the latter,
> because in the absense of CS, the segment-based address is very
> unclear indeed.

I _think_ it is just the RIP since its part of a more general register
dump (which does not include the segment registers).

I can't find anything in the SDM clarifying it one way or the other.
Stephane do you know?

> And if it *is* the linear address, then at that point you could do
> 
>    regs->cs = kernel_ip(ip) ? __KERNEL_CS : __USER_CS;
>    regs->eflags &= ~X86_EFLAGS_VM;
> 
> and document this as a "we fake the CS and vm86 mode, using the known
> zero-based code segments". At that point it would be technically
> correct.

OK, thanks.. At least the AMB IBS case provides the Linear address of
the instruction so the IBS code should do it this way. We'll need to
check with Intel to see what PEBS does.

Supposing the worst case and Intel simply provides the RIP as is, what
should we do then?
