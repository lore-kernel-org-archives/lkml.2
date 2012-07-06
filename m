Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2GFU7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:59:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44032 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2GFU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <1341607713.7709.68.camel@twins>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org> <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins> <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com> <1341607713.7709.68.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 13:59:29 -0700
X-Google-Sender-Auth: Y8--WplLv6VtRIEUu-whlaEe0rE
Message-ID: <CA+55aFwbji562dZ0X0B6aDvO_JkvsCpJmVa_S56PDiapoL0agA@mail.gmail.com>
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

On Fri, Jul 6, 2012 at 1:48 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-07-06 at 11:34 -0700, Linus Torvalds wrote:
>> Also, somebody should check. Is the PEBS information *actually* the
>> instruction pointer (address within the code segment), or is it the
>> "linear address" (segment base + rip)? I hope it is the latter,
>> because in the absense of CS, the segment-based address is very
>> unclear indeed.
>
> I _think_ it is just the RIP since its part of a more general register
> dump (which does not include the segment registers).

Ugh. That would be really sad if true (and I would not be at all
surprised if it *is* true). Sure, flat segments are standard, and once
you get into 64-bit mode I don't think you can even do any CS base,
but afaik the code there is supposed to work on x86-32 too, no?

> Supposing the worst case and Intel simply provides the RIP as is, what
> should we do then?

Well, if the RIP is all you have, the RIP is all you can use, and you
have to just assume flat segments. That will be true in practice, and
if it means that you can't sanely profile vm86 mode etc on x86-32,
that's sad but you have to blame the hardware for that.

And I don't have any huge problems with assuming flat segments and
just "work in the simple cases".

What I reacted negatively to is literally that

    kernel_ip(regs->ip)

test, because once you have "regs", that's absolutely the wrong thing
to do. That kind of test just shows that somebody filled in "regs"
incorrectly. So if you have a pt_regs pointer, that kind of test is
simply crap, and indicates a bug somewhere.

             Linus
