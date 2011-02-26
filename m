Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1BZSMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 13:12:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38719 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1BZSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 13:12:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6269"; a="76675034"
From: David Brown <davidb@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	<1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
	<1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
X-Hashcash: 1:20:110226:linux-arm-msm@vger.kernel.org::Ql/QkCEojUotjLBB:0000000000000000000000000000000003qi
X-Hashcash: 1:20:110226:will.deacon@arm.com::m1AYNnB5k1KSqHVT:0000000000000000000000000000000000000000001F3T
X-Hashcash: 1:20:110226:sboyd@codeaurora.org::ErP+ITVU8ppeJsMM:000000000000000000000000000000000000000001IB5
X-Hashcash: 1:20:110226:linux-kernel@vger.kernel.org::jrGbZQk2f7gzi0xO:00000000000000000000000000000000032Xw
X-Hashcash: 1:20:110226:linux-arm-kernel@lists.infradead.org::Ufwz7BX3KvJzBTAE:00000000000000000000000008Be4
Date: Sat, 26 Feb 2011 10:12:44 -0800
In-Reply-To: <1298635017.958.0.camel@e102144-lin.cambridge.arm.com> (Will
	Deacon's message of "Fri, 25 Feb 2011 11:56:57 +0000")
Message-ID: <8yapqqe3bs3.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25 2011, Will Deacon wrote:

> On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
>> We don't want the compiler to remove these asm statements or
>> reorder them in any way. Mark them as volatile to be sure.
>> 
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/scm.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
>> index f4b9bc9..ba57b5a 100644
>> --- a/arch/arm/mach-msm/scm.c
>> +++ b/arch/arm/mach-msm/scm.c
>> @@ -174,7 +174,7 @@ static u32 smc(u32 cmd_addr)
>>         register u32 r0 asm("r0") = 1;
>>         register u32 r1 asm("r1") = (u32)&context_id;
>>         register u32 r2 asm("r2") = cmd_addr;
>> -       asm(
>> +       asm volatile(
>>                 __asmeq("%0", "r0")
>>                 __asmeq("%1", "r0")
>>                 __asmeq("%2", "r1")
>> @@ -271,7 +271,7 @@ u32 scm_get_version(void)
>>                 return version;
>> 
>>         mutex_lock(&scm_lock);
>> -       asm(
>> +       asm volatile(
>>                 __asmeq("%0", "r1")
>>                 __asmeq("%1", "r0")
>>                 __asmeq("%2", "r1")
>
> These asm blocks all have sensible looking output constraints. Why
> do they need to be marked volatile?

Without the volatile, the compiler is free to assume the only side
effects of the asm are to modify the output registers.  The volatile is
needed to indicate to the compiler that the asm has other side effects.
There isn't enough optimization, yet, in gcc to change the generated
code in this case, so it happens to generate the correct code without
it.

The second probably doesn't need it, unless we are expecting the version
to change dynamically.  The volatile makes the scm_get_version()
function clearly a call to scm, though, so is probably useful to
document the intent.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
