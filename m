Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2H0SeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:34:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58614 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2H0SeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:34:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6817"; a="229947028"
Message-ID: <503BBDAE.7020302@codeaurora.org>
Date: Mon, 27 Aug 2012 11:34:22 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: local timers: add timer support using IO mapped
 register
References: <1344635921-5147-1-git-send-email-rvaswani@codeaurora.org> <6e478bc5efb598b4a15ff9d534b94001@localhost>
In-Reply-To: <6e478bc5efb598b4a15ff9d534b94001@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/2012 3:04 AM, Marc Zyngier wrote:
> Hi Rohit,
>
> On Fri, 10 Aug 2012 14:58:41 -0700, Rohit Vaswani
> <rvaswani@codeaurora.org>
> wrote:
>> The current arch_timer only support accessing through CP15 interface.
>> Add support for ARM processors that only support IO mapped register
>> interface
> This is quite a departure from the current implementation, which raises a
> couple of questions:
> - What does CP15 ID_PFR1[19:16] report? Can we easily detect that we do
> not have the CP15 interface?
> - What about HYP mode? Is there any way to control the access of the
> physical timer at PL1?
Yes - we can easily detect if CP15 interface is not present. The PFR1 
[19:16] are 0 for this implementation.
How is the access control managed currently for the Physical timer ?
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> ---
>>   .../devicetree/bindings/arm/arch_timer.txt         |    7 +
>>   arch/arm/kernel/arch_timer.c                       |  259
>>   ++++++++++++++++----
>>   2 files changed, 223 insertions(+), 43 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt
>> b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> index 52478c8..1c71799 100644
>> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
>> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> @@ -14,6 +14,13 @@ The timer is attached to a GIC to deliver its
>> per-processor interrupts.
>>   
>>   - clock-frequency : The frequency of the main counter, in Hz. Optional.
>>   
>> +- irq-is-not-percpu: Specify is the timer irq is *NOT* a percpu (PPI)
>> interrupt
>> +  In the default case i.e without this property, the timer irq is
> treated
>> as a
>> +  PPI interrupt. Optional.
> Ouch! How do you specify the various interrupts for all CPUs? Do you end
> up with 4 SPIs per CPU?
>
>> +- If the node address and reg is specified, the arch_timer will try to
>> use the memory
>> +  mapped timer. Optional.
>> +
>>   Example:
>>   
>>   	timer {
>> diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
>> index 1d0d9df..09604b7 100644
>> --- a/arch/arm/kernel/arch_timer.c
>> +++ b/arch/arm/kernel/arch_timer.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/clockchips.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/of_irq.h>
>> +#include <linux/of_address.h>
>>   #include <linux/io.h>
>>   
>>   #include <asm/cputype.h>
>> @@ -29,8 +30,17 @@
>>   static unsigned long arch_timer_rate;
>>   static int arch_timer_ppi;
>>   static int arch_timer_ppi2;
>> +static int is_irq_percpu;
>>   
>>   static struct clock_event_device __percpu **arch_timer_evt;
>> +static void __iomem *timer_base;
>> +
>> +struct arch_timer_operations {
>> +	void (*reg_write)(int, u32);
>> +	u32 (*reg_read)(int);
>> +	cycle_t (*get_cntpct)(void);
>> +	cycle_t (*get_cntvct)(void);
>> +};
> I already have something similar in a patch series that I'd like to get
> merged in 3.7, implementing support for the virtual timers (needed for
> virtualisation). Have a look at:
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> timers-next
I am working on a patch based on this and will send this out soon.
> <snip> 


Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

