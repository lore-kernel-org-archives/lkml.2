Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1ITBzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 21:55:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56878 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1ITBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 21:55:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6474"; a="119949106"
Message-ID: <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
In-Reply-To: <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
    <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
Date: Mon, 19 Sep 2011 18:55:39 -0700 (PDT)
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division 
     functions
From: "Laura Abbott" <lauraa@codeaurora.org>
To: "Nicolas Pitre" <nico@fluxnic.net>
Cc: "Laura Abbott" <lauraa@codeaurora.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, September 19, 2011 4:22 pm, Nicolas Pitre wrote:
> On Mon, 19 Sep 2011, Laura Abbott wrote:
>
>> The 64bit division functions never had unwinding annotations
>> added. This prevents a backtrace from being printed within
>> the function and if a division by 0 occurs. Add the annotations.
>>
>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>> ---
>>  arch/arm/lib/div64.S |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/lib/div64.S b/arch/arm/lib/div64.S
>> index faa7748..e55c484 100644
>> --- a/arch/arm/lib/div64.S
>> +++ b/arch/arm/lib/div64.S
>> @@ -13,6 +13,7 @@
>>   */
>>
>>  #include <linux/linkage.h>
>> +#include <asm/unwind.h>
>>
>>  #ifdef __ARMEB__
>>  #define xh r0
>> @@ -44,6 +45,7 @@
>>   */
>>
>>  ENTRY(__do_div64)
>> +UNWIND(.fnstart)
>>
>>  	@ Test for easy paths first.
>>  	subs	ip, r4, #1
>> @@ -189,7 +191,12 @@ ENTRY(__do_div64)
>>  	moveq	yh, xh
>>  	moveq	xh, #0
>>  	moveq	pc, lr
>> +UNWIND(.fnend)
>>
>> +UNWIND(.fnstart)
>> +UNWIND(.pad #4)
>> +UNWIND(.save {lr})
>> +Ldiv0_64:
>
> Why this phony fnend+fnstart here?
>
If a division by 0 occurs, we need to be able to access the saved LR on
the stack which is setup right before calling the __div0 function. This
can't go at the top of __do_div64 because if we try to do a backtrace from
within __do_div64 the annotation won't be correct as the LR was never
saved on the stack. (yes, __do_div64 is all register math but it's still
possible to take a prefetch abort in the middle of that function. Taking a
prefetch abort in the middle of __do_div64 is what found this issue in the
first place.) This setup handles both cases correctly.

>
> Nicolas
>

Laura

> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


