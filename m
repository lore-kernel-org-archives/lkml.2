Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1EZRPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:15:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44267 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757898Ab1EZRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:15:43 -0400
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
 CONFIG_ALIGNMENT_TRAP
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sam@ravnborg.org, ak@linux.intel.com
In-Reply-To: <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
References: <20110523111648.10474.78396.stgit@e102109-lin.cambridge.arm.com>
	 <20110523132124.GI17672@n2100.arm.linux.org.uk>
	 <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com>
	 <yw1xipt0p4i9.fsf@unicorn.mansr.com>
	 <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>
	 <20110524171331.GA2941@arm.com>
	 <20110525111405.GA12010@e102109-lin.cambridge.arm.com>
	 <20110525124348.GA2340@arm.com>	<yw1xaaeanbxe.fsf@unicorn.mansr.com>
	 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 18:10:54 +0100
Message-ID: <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right... [adding bunch of people to CC],


On Wed, 2011-05-25 at 15:50 +0100, Catalin Marinas wrote:
> 2011/5/25 Måns Rullgård <mans@mansr.com>:
> > Dave Martin <dave.martin@linaro.org> writes:
> >
> >> On Wed, May 25, 2011 at 12:14:08PM +0100, Catalin Marinas wrote:
> >>> On Tue, May 24, 2011 at 06:13:31PM +0100, Dave Martin wrote:
> >>> > On Tue, May 24, 2011 at 04:26:35PM +0100, Catalin Marinas wrote:
> >>> > > BTW, are we sure that the code generated with unaligned accesses is
> >>> > > better? AFAIK, while processors support unaligned accesses, they may
> >>> > > not always be optimal.
> >>> >
> >>> > The code gcc generates to synthesise an unaligned access using aligned
> >>> > accesses is pretty simplistic:
> >>> ...
> >>> > For code which natively needs to read unaligned fields from data structures,
> >>> > I sincerely doubt that the CPU will not beat the above code for efficiency...
> >>> >
> >>> > So if there's code doing unaligned access to data structures for a good
> >>> > reason, building with unaligned access support turned on in the compiler
> >>> > seems a good idea, if that code might performance-critical for anything.
> >>>
> >>> gcc generates unaligned accesses in the the pcpu_dump_alloc_info()
> >>> function. We have a local variable like below (9 bytes):
> >>>
> >>>      char empty_str[] = "--------";
> >>>
> >>> and it looks like other stack accesses are unaligned:
> >>>
> >>> c0082ba0 <pcpu_dump_alloc_info>:
> >>> c0082ba0:   e92d4ff0    push    {r4, r5, r6, r7, r8, r9, sl, fp, lr}
> >>> c0082ba4:   e3074118    movw    r4, #28952  ; 0x7118
> >>> c0082ba8:   e24dd04c    sub sp, sp, #76 ; 0x4c
> >>> c0082bac:   e34c402a    movt    r4, #49194  ; 0xc02a
> >>> c0082bb0:   e58d1014    str r1, [sp, #20]
> >>> c0082bb4:   e58d0020    str r0, [sp, #32]
> >>> c0082bb8:   e8b40003    ldm r4!, {r0, r1}
> >>> c0082bbc:   e58d003f    str r0, [sp, #63]   <----------- !!!!!
> >>> c0082bc0:   e59d0014    ldr r0, [sp, #20]
> >>> c0082bc4:   e5d43000    ldrb    r3, [r4]
> >>>
> >>> I haven't tried with -mno-unaligned-access, I suspect the variables on
> >>> the stack would be aligned.
> >>
> >> So, it looks like empty_str may be misaligned on the stack, and the compiler
> >> is doing a misaligned store when initialising it.
> >
> > empty_str has type char[] so there are no alignment requirements.
> 
> I think the local variables after char empty_str[] are unaligned (int
> alloc). Changing the array size to 16 solves the issue.
> 
> The gcc guys here in ARM will have a look and I'll get back to you.

This issue seems to be caused by passing -fconserve-stack to GCC. This
was added in 8f7f5c9f ("kbuild: set -fconserve-stack option for gcc
4.5") and as you can see from the archive:

http://lkml.org/lkml/2009/9/20/39

it was thought to only have an impact on inlining decisions. Looking at
the documentation for GCC 4.6:

-fconserve-stack
          Attempt to minimize stack usage. The compiler will attempt to
use less stack space, even if that makes the program slower. This option
implies setting the ‘large-stack-frame’ parameter to 100 and the
‘large-stack-frame-growth’ parameter to 400.

So it sounds like we might not want to enable this blindly across all
architectures. Indeed, on ARM, it encourages the compiler to pack
variables on the stack which leads to the weird and wonderful alignment
situation that has been encountered in this thread.

Can we remove -fconserve-stack from the top-level Makefile (or at least
make it conditional by architecture)?

Will

