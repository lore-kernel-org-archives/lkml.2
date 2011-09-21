Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1IULjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 07:39:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47186 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1IULjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 07:39:19 -0400
Date: Wed, 21 Sep 2011 12:39:09 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
Message-ID: <20110921113906.GB2872@arm.com>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 06:55:39PM -0700, Laura Abbott wrote:
> 
> On Mon, September 19, 2011 4:22 pm, Nicolas Pitre wrote:
> > On Mon, 19 Sep 2011, Laura Abbott wrote:
> >
> >> The 64bit division functions never had unwinding annotations
> >> added. This prevents a backtrace from being printed within
> >> the function and if a division by 0 occurs. Add the annotations.
> >>
> >> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> >> ---
> >>  arch/arm/lib/div64.S |    8 ++++++++
> >>  1 files changed, 8 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/lib/div64.S b/arch/arm/lib/div64.S
> >> index faa7748..e55c484 100644
> >> --- a/arch/arm/lib/div64.S
> >> +++ b/arch/arm/lib/div64.S
> >> @@ -13,6 +13,7 @@
> >>   */
> >>
> >>  #include <linux/linkage.h>
> >> +#include <asm/unwind.h>
> >>
> >>  #ifdef __ARMEB__
> >>  #define xh r0
> >> @@ -44,6 +45,7 @@
> >>   */
> >>
> >>  ENTRY(__do_div64)
> >> +UNWIND(.fnstart)
> >>
> >>  	@ Test for easy paths first.
> >>  	subs	ip, r4, #1
> >> @@ -189,7 +191,12 @@ ENTRY(__do_div64)
> >>  	moveq	yh, xh
> >>  	moveq	xh, #0
> >>  	moveq	pc, lr
> >> +UNWIND(.fnend)
> >>
> >> +UNWIND(.fnstart)
> >> +UNWIND(.pad #4)
> >> +UNWIND(.save {lr})
> >> +Ldiv0_64:
> >
> > Why this phony fnend+fnstart here?
> >
> If a division by 0 occurs, we need to be able to access the saved LR on
> the stack which is setup right before calling the __div0 function. This
> can't go at the top of __do_div64 because if we try to do a backtrace from
> within __do_div64 the annotation won't be correct as the LR was never
> saved on the stack. (yes, __do_div64 is all register math but it's still
> possible to take a prefetch abort in the middle of that function. Taking a
> prefetch abort in the middle of __do_div64 is what found this issue in the
> first place.) This setup handles both cases correctly.

Talking to Catalin a bit more, it sounds like prefetch aborts should not
happen in kernel code, and data aborts should not happen when accessing
the kernel stack.  If either of these happens, there's no guarantee that
the kernel will be able to recover from the situation fully, so
backtracing may not be the primary concern.

The kinds of situation that the backtracer _can_ cope with are:

a) explicit, synchonous backtrace requests (BUG() etc. within C
   functions)

b) aborts when accessing random memory (but not the stack) outside the
   function progolgue/epilogue sequences (i.e., so that the state the
   unwind info described actually matches reality)

If you get a data abort when accessing the kernel stack, the backtracer
probably won't work at all, because it relies on the same stack.  Faults
during prologue/epilogue sequences can't be handled correctly because
the unwind annotations don't descirbe the interim state during these
sequences.  There is no general way to use the unwinder annotations to
describe fully how the state evolves during prologue/epilogue sequences.


So, having thought about it, it may be that having the extra .fnstart/
.fnend pair doesn't really help that much after all.

For this code, we do want the unwind state to be properly recorded for
the "bl __div0" call site after Ldiv0_64; but we probably don't need to
worry about backtracing from any other point in this code -- partly
becuase the probably of needing to do it is very low, and partly because
we will likely fail to produce a backtrace in this situation.  If this
is a reasonable assumption, then a single unwind annotation block should
be sufficient:

ENTRY(__do_div64)
UNWIND(.fnstart)
	subs	ip, r4, #1
	@ ...

	moveq	pc, lr

UNWIND(.pad #4)
UNWIND(.save {lr}
	stmfd	sp!, {r0, lr}
	@ ...

	bl	__div0

	@ ...
UNWIND(.fnend)

The location of the .pad and .save is of course not meaningful for the
unwind data: only their respective order, and the fact that they appear
between the .fnstart/.fnend directives.  Putting them next to the stmfd
just makes the code easier to read.


The extra annotations in the original patch are harmless, though.

Cheers
---Dave
