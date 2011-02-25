Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab1BYTWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:22:21 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5862 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab1BYTWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:22:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6268"; a="76529070"
Message-ID: <4D68015B.1050409@codeaurora.org>
Date: Fri, 25 Feb 2011 11:22:03 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>	 <1298573085-23217-3-git-send-email-sboyd@codeaurora.org> <1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 05:23 AM, Will Deacon wrote:
> On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
>> Assign the registers used in the inline assembly immediately
>> before the inline assembly block. This ensures the compiler
>> doesn't optimize away dead register assignments when it
>> shouldn't.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/scm.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
>> index ba57b5a..5eddf54 100644
>> --- a/arch/arm/mach-msm/scm.c
>> +++ b/arch/arm/mach-msm/scm.c
>> @@ -264,13 +264,16 @@ u32 scm_get_version(void)
>>  {
>>         int context_id;
>>         static u32 version = -1;
>> -       register u32 r0 asm("r0") = 0x1 << 8;
>> -       register u32 r1 asm("r1") = (u32)&context_id;
>> +       register u32 r0 asm("r0");
>> +       register u32 r1 asm("r1");
>>
>>         if (version != -1)
>>                 return version;
>>
>>         mutex_lock(&scm_lock);
>> +
>> +       r0 = 0x1 << 8;
>> +       r1 = (u32)&context_id;
>>         asm volatile(
>>                 __asmeq("%0", "r1")
>>                 __asmeq("%1", "r0")
>
>
> Whoa, have you seen the compiler `optimise' the original assignments
> away? Since there is a use in the asm block, the definition shouldn't
> be omitted. What toolchain are you using

Yes I've seen the r0 and r1 assignments get optimized away. I'm
suspecting it's because the mutex_lock() is between the assignments and
usage. I'm guessing the assignment to r0 and r1 are actually generated,
but then they're optimized away because the mutex_lock() isn't inlined
and thus r0 and r1 assigned to something that isn't &scm_lock can be
"safely" removed (dead register assignments). I can't confirm any of
this since I don't know what gcc is doing internally or even how to
probe what it's doing (yeah I know I could go read gcc sources).
Suggestions?

I've seen it with two different compilers so far:

gcc (Sourcery G++ Lite 2010.09-50) 4.5.1
arm-eabi-gcc (GCC) 4.4.0

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

