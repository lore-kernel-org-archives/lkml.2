Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2GIR4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:56:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38449 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2GIR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <1341832997.3462.41.camel@twins>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org> <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins> <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com> <1341832997.3462.41.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jul 2012 10:55:49 -0700
X-Google-Sender-Auth: JGy4GDxdVZkecfBpkovq0GFSZ-g
Message-ID: <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 4:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> How about something like the below?
>
> I've also modified perf_instruction_pointer() to account for the VM86
> and IA32 non-zero segment base cases. At least, I tried to do so, I've
> never had the 'pleasure' of poking at this segment descriptor stuff
> before.

The code base calculations look correct to me per se, although I'd put
the VM86 check into code_segment_base(). But whatever.

> Ingo didn't really like doing that though, his suggestion was to kill
> all those IPs by mapping them to a special value (~0UL or so).

Hmm. I don't care much one way or another, but I don't really see the
advantage of doing that.

The expensive part is the checking - since in all normal cases we'll
be using the standard CS and not be in vm86 mode. And you have to do
the checking whether you then map it to ~0ul or do a proper segment
base calculation. So why not just do it right? Your code seems sane
enough to me.

Now "regs" always contains a proper register state, and when the perf
code wants a linear address, perf_instruction_pointer() seems to do
the right translation. Looks good to me, although I didn't check all
the uses.

However, it is worth pointing out that sp/bp have exactly the same
segment base issue. So if you do stack tracing into user mode, you
should really do the same thing for those. And quite frankly, at that
point vm86 mode and the stack segment matters in other ways than just
the base pointer: a 16-bit stack segment acts fundamentally
differently from a 32-bit one. So at that point it may well make much
more sense to take the approach Ingo suggests, and simply not follow
stack frames at all.

Anyway, ACK for that patch from me. It may not solve all the problems,
but it looks ok.

                    Linus
