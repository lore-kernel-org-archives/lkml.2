Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1B0Rlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:41:32 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16089 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1B0Rla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:41:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6270"; a="76756789"
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	<1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
	<1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
	<8yapqqe3bs3.fsf@huya.qualcomm.com>
	<alpine.LFD.2.00.1102261439590.22034@xanadu.home>
X-Hashcash: 1:20:110227:will.deacon@arm.com::4N1siiskvE1KLmoW:0000000000000000000000000000000000000000000JiV
X-Hashcash: 1:20:110227:nico@fluxnic.net::R0ln3C5wIlhPjklL:00KH1
X-Hashcash: 1:20:110227:linux-arm-msm@vger.kernel.org::ONni0DWhBnhIswFw:000000000000000000000000000000001yeE
X-Hashcash: 1:20:110227:linux-arm-kernel@lists.infradead.org::Hb06a9YXaBiZvP/Q:00000000000000000000000003z1x
X-Hashcash: 1:20:110227:sboyd@codeaurora.org::x/PcDCMGR9OCZaPl:000000000000000000000000000000000000000007ZC3
X-Hashcash: 1:20:110227:linux-kernel@vger.kernel.org::mWpSr1onqNk4qO5I:0000000000000000000000000000000009lXj
Date: Sun, 27 Feb 2011 09:41:30 -0800
In-Reply-To: <alpine.LFD.2.00.1102261439590.22034@xanadu.home> (Nicolas
	Pitre's message of "Sat, 26 Feb 2011 14:43:16 -0500 (EST)")
Message-ID: <8yahbbp2x4l.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26 2011, Nicolas Pitre wrote:

> On Sat, 26 Feb 2011, David Brown wrote:
>
>> On Fri, Feb 25 2011, Will Deacon wrote:
>> 
>> > On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
>> >> We don't want the compiler to remove these asm statements or
>> >> reorder them in any way. Mark them as volatile to be sure.
>> >> 
>> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> >> ---
>> >>  arch/arm/mach-msm/scm.c |    4 ++--
>> >>  1 files changed, 2 insertions(+), 2 deletions(-)
>> >> 
>> >> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
>> >> index f4b9bc9..ba57b5a 100644
>> >> --- a/arch/arm/mach-msm/scm.c
>> >> +++ b/arch/arm/mach-msm/scm.c
>> >> @@ -174,7 +174,7 @@ static u32 smc(u32 cmd_addr)
>> >>         register u32 r0 asm("r0") = 1;
>> >>         register u32 r1 asm("r1") = (u32)&context_id;
>> >>         register u32 r2 asm("r2") = cmd_addr;
>> >> -       asm(
>> >> +       asm volatile(
>> >>                 __asmeq("%0", "r0")
>> >>                 __asmeq("%1", "r0")
>> >>                 __asmeq("%2", "r1")
>> >> @@ -271,7 +271,7 @@ u32 scm_get_version(void)
>> >>                 return version;
>> >> 
>> >>         mutex_lock(&scm_lock);
>> >> -       asm(
>> >> +       asm volatile(
>> >>                 __asmeq("%0", "r1")
>> >>                 __asmeq("%1", "r0")
>> >>                 __asmeq("%2", "r1")
>> >
>> > These asm blocks all have sensible looking output constraints. Why
>> > do they need to be marked volatile?
>> 
>> Without the volatile, the compiler is free to assume the only side
>> effects of the asm are to modify the output registers.  The volatile is
>> needed to indicate to the compiler that the asm has other side effects.
>> There isn't enough optimization, yet, in gcc to change the generated
>> code in this case, so it happens to generate the correct code without
>> it.
>> 
>> The second probably doesn't need it, unless we are expecting the version
>> to change dynamically.  The volatile makes the scm_get_version()
>> function clearly a call to scm, though, so is probably useful to
>> document the intent.
>
> If the inline asm does have side effects which are not obvious other 
> than producing a result for the output operand then it is a good idea to 
> add a comment to that effect.  Otherwise it is always best to omit the 
> volatile and let gcc move the inline asm around or even delete it 
> entirely when possible.

Would this be better as a comment by the assembly or for the whole file
or function?  The entire purpose of this file is to communicate with
another logical processor, so it's all about producing side effects
other than just modifying the registers or the memory.  Maybe a file
comment briefly explaining that SCM runs in TrustZone and a short
comment by each asm stating that it traps to the other logical cpu?

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
