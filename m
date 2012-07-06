Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2GFSe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:34:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63015 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2GFSe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org> <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins> <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 11:34:35 -0700
X-Google-Sender-Auth: PTv-3Od8TRW9uGmo5gpv7aleCsY
Message-ID: <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 11:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If some code then changes the values in the pt_regs, it is *that* code
> that needs to think twice about what it does. Where is that code?

>From a quick grep it looks like it is __intel_pmu_pebs_event() that does this.

THAT is where you would possibly have a huge honking big comment about
how you have to fake the CS register contents because the PEBS
information is incomplete. But make it clear that it is a total hack.

Also, somebody should check. Is the PEBS information *actually* the
instruction pointer (address within the code segment), or is it the
"linear address" (segment base + rip)? I hope it is the latter,
because in the absense of CS, the segment-based address is very
unclear indeed.

And if it *is* the linear address, then at that point you could do

   regs->cs = kernel_ip(ip) ? __KERNEL_CS : __USER_CS;
   regs->eflags &= ~X86_EFLAGS_VM;

and document this as a "we fake the CS and vm86 mode, using the known
zero-based code segments". At that point it would be technically
correct.

But any code that does "kernel_ip(regs->ip)" is just terminally
confused and can never be sane.

                  Linus
