Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab1ITN1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:27:07 -0400
Received: from relais.videotron.ca ([24.201.245.36]:9328 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1ITN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:27:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 20 Sep 2011 09:27:01 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division functions
In-reply-to: <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
Message-id: <alpine.LFD.2.00.1109200922281.12663@xanadu.home>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Laura Abbott wrote:

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
> saved on the stack.

I suppose the debug infrastructure always assume the same stack frame 
for the whole function, hence you can't put that .pad and .save right 
before the call to __div0 without the .fnstart and have it effective 
only there?

If so then:

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>


Nicolas
