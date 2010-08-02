Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0HBUse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:48:34 -0400
Received: from mail.atheros.com ([12.36.123.2]:50863 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0HBUsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:48:33 -0400
Date: Mon, 2 Aug 2010 13:48:27 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Doug Dahlby <Doug.Dahlby@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>, <davidn@davidnewall.com>,
        <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>,
        <jirislaby@gmail.com>
Subject: Re: Using unsigned int for loop counters - better performance for
 Architectures - urban hacker legend?
Message-ID: <20100802204827.GF8920@tux>
References: <AANLkTi=AuFBwT5AjRdjrkbe3=5d36TNr4Cp=r0VnEogH@mail.gmail.com>
 <4C53EF30.5020303@davidnewall.com>
 <B7132A25476D334D9130FE7532F2A563109FED150D@SC1EXMB-MBCL.global.atheros.com>
 <20100802193712.GB8920@tux>
 <B7132A25476D334D9130FE7532F2A563109FED151A@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <B7132A25476D334D9130FE7532F2A563109FED151A@SC1EXMB-MBCL.global.atheros.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug, I'm adding your response to lkml as its the best answer I've gotten so far.

On Mon, Aug 02, 2010 at 01:10:01PM -0700, Doug Dahlby wrote:
> Luis,
> 
> Just out of curiousity, I looked at what gcc does on my own x86 computer.
> When compiled regularly, the loop bodies are practically identical:
> 
> $ more loop_test1.c loop_test1.s loop_test2.c loop_test2.s
> ::::::::::::::
> loop_test1.c
> ::::::::::::::
> int foo(int limit)
> {
>     int i = 0;
>     for (; limit > 0; limit--) {
>         i += 1;
>     }
>     return i;
> }
> ::::::::::::::
> loop_test1.s
> ::::::::::::::
>         .file   "loop_test1.c"
>         .text
> .globl _foo
>         .def    _foo;   .scl    2;      .type   32;     .endef
> _foo:
>         pushl   %ebp
>         movl    %esp, %ebp
>         subl    $4, %esp
>         movl    $0, -4(%ebp)
> L2:
>         cmpl    $0, 8(%ebp)
>         jle     L3
>         leal    -4(%ebp), %eax
>         incl    (%eax)
>         decl    8(%ebp)
>         jmp     L2
> L3:
>         movl    -4(%ebp), %eax
>         leave
>         ret
> ::::::::::::::
> loop_test2.c
> ::::::::::::::
> int foo(unsigned limit)
> {
>     int i = 0;
>     for (; limit > 0; limit--) {
>         i += 1;
>     }
>     return i;
> }
> ::::::::::::::
> loop_test2.s
> ::::::::::::::
>         .file   "loop_test2.c"
>         .text
> .globl _foo
>         .def    _foo;   .scl    2;      .type   32;     .endef
> _foo:
>         pushl   %ebp
>         movl    %esp, %ebp
>         subl    $4, %esp
>         movl    $0, -4(%ebp)
> L2:
>         cmpl    $0, 8(%ebp)
>         je      L3
>         leal    -4(%ebp), %eax
>         incl    (%eax)
>         decl    8(%ebp)
>         jmp     L2
> L3:
>         movl    -4(%ebp), %eax
>         leave
>         ret
> 
> but when I compile with -O3, there is a little difference:
> 
> ::::::::::::::
> loop_test1.s
> ::::::::::::::
>         .file   "loop_test1.c"
>         .text
>         .p2align 4,,15
> .globl _foo
>         .def    _foo;   .scl    2;      .type   32;     .endef
> _foo:
>         pushl   %ebp
>         xorl    %eax, %eax
>         movl    %esp, %ebp
>         movl    8(%ebp), %edx
>         jmp     L10
>         .p2align 4,,7
> L12:
>         incl    %eax
>         decl    %edx
> L10:
>         testl   %edx, %edx
>         jg      L12
>         popl    %ebp
>         ret
> ::::::::::::::
> loop_test2.s
> ::::::::::::::
>         .file   "loop_test2.c"
>         .text
>         .p2align 4,,15
> .globl _foo
>         .def    _foo;   .scl    2;      .type   32;     .endef
> _foo:
>         pushl   %ebp
>         xorl    %eax, %eax
>         movl    %esp, %ebp
>         movl    8(%ebp), %edx
>         testl   %edx, %edx
>         jmp     L10
>         .p2align 4,,7
> L12:
>         incl    %eax
>         decl    %edx
> L10:
>         jne     L12
>         popl    %ebp
>         ret
> 
> Looks like the compiler is explicity testing the unsigned counter
> against zero, but uses the status bits set as a byproduct of the
> loop counter decrement for the unsigned case.  When I run these
> 2 functions repeatedly, the unsigned counter takes about 70% of
> the time of the signed counter.  This roughly matches the ratio
> of the 3 loop body statements in the unsigned case to the 4
> statements in the signed case.  This is not a rigorous test, and
> this may be specific to my architecture and my compiler settings
> (default + -O3), but it appears that there is some validity to
> make a general habit of using unsigned loop counters rather
> than signed. That being said, I'd be surprised if we have loops that
>
> (a) are dominated by the looping overhead rather than the operations
> in the loop body, and
> (b) iterate such a large number of times that they take up an non-negligible
> amount of the driver's CPU use. 
>
> So it looks to me like this is a good policy to recommend, but not one
> that needs across-the-board adherence.

Awesome, thanks!

  Luis
