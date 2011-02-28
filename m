Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1B1CVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:21:10 -0500
Received: from relais.videotron.ca ([24.201.245.36]:41349 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1B1CVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:21:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 27 Feb 2011 21:21:08 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
In-reply-to: <8yahbbp2x4l.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1102272118240.440@xanadu.home>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
 <1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
 <1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
 <8yapqqe3bs3.fsf@huya.qualcomm.com>
 <alpine.LFD.2.00.1102261439590.22034@xanadu.home>
 <8yahbbp2x4l.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Feb 2011, David Brown wrote:

> On Sat, Feb 26 2011, Nicolas Pitre wrote:
> 
> > On Sat, 26 Feb 2011, David Brown wrote:
> >
> >> On Fri, Feb 25 2011, Will Deacon wrote:
> >> 
> >> > On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
> >> >> We don't want the compiler to remove these asm statements or
> >> >> reorder them in any way. Mark them as volatile to be sure.
> >> >> 
> >> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> >> ---
> >> >>  arch/arm/mach-msm/scm.c |    4 ++--
> >> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >> >> 
> >> >> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
> >> >> index f4b9bc9..ba57b5a 100644
> >> >> --- a/arch/arm/mach-msm/scm.c
> >> >> +++ b/arch/arm/mach-msm/scm.c
> >> >> @@ -174,7 +174,7 @@ static u32 smc(u32 cmd_addr)
> >> >>         register u32 r0 asm("r0") = 1;
> >> >>         register u32 r1 asm("r1") = (u32)&context_id;
> >> >>         register u32 r2 asm("r2") = cmd_addr;
> >> >> -       asm(
> >> >> +       asm volatile(
> >> >>                 __asmeq("%0", "r0")
> >> >>                 __asmeq("%1", "r0")
> >> >>                 __asmeq("%2", "r1")
> >> >> @@ -271,7 +271,7 @@ u32 scm_get_version(void)
> >> >>                 return version;
> >> >> 
> >> >>         mutex_lock(&scm_lock);
> >> >> -       asm(
> >> >> +       asm volatile(
> >> >>                 __asmeq("%0", "r1")
> >> >>                 __asmeq("%1", "r0")
> >> >>                 __asmeq("%2", "r1")
> >> >
> >> > These asm blocks all have sensible looking output constraints. Why
> >> > do they need to be marked volatile?
> >> 
> >> Without the volatile, the compiler is free to assume the only side
> >> effects of the asm are to modify the output registers.  The volatile is
> >> needed to indicate to the compiler that the asm has other side effects.
> >> There isn't enough optimization, yet, in gcc to change the generated
> >> code in this case, so it happens to generate the correct code without
> >> it.
> >> 
> >> The second probably doesn't need it, unless we are expecting the version
> >> to change dynamically.  The volatile makes the scm_get_version()
> >> function clearly a call to scm, though, so is probably useful to
> >> document the intent.
> >
> > If the inline asm does have side effects which are not obvious other 
> > than producing a result for the output operand then it is a good idea to 
> > add a comment to that effect.  Otherwise it is always best to omit the 
> > volatile and let gcc move the inline asm around or even delete it 
> > entirely when possible.
> 
> Would this be better as a comment by the assembly or for the whole file
> or function?  The entire purpose of this file is to communicate with
> another logical processor, so it's all about producing side effects
> other than just modifying the registers or the memory.  Maybe a file
> comment briefly explaining that SCM runs in TrustZone and a short
> comment by each asm stating that it traps to the other logical cpu?

Now that I've looked more closely at the actual code, I think it is 
obvious enough that the volatile is needed and no extra comment should 
be required.


Nicolas
