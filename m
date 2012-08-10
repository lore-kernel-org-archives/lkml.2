Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab2HJXhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:37:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59268 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2HJXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:37:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6799"; a="221875821"
Message-ID: <50259B46.1040402@codeaurora.org>
Date: Fri, 10 Aug 2012 16:37:42 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: marc.zyngier@arm.com, Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: local timers: add timer support using IO mapped
 register
References: <1344635921-5147-1-git-send-email-rvaswani@codeaurora.org> <502586DB.2000609@gmail.com>
In-Reply-To: <502586DB.2000609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your feedback Rob.

On 8/10/2012 3:10 PM, Rob Herring wrote:
> On 08/10/2012 04:58 PM, Rohit Vaswani wrote:
>> The current arch_timer only support accessing through CP15 interface.
>> Add support for ARM processors that only support IO mapped register
>> interface
>>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> ---
>>   .../devicetree/bindings/arm/arch_timer.txt         |    7 +
>>   arch/arm/kernel/arch_timer.c                       |  259 ++++++++++++++++----
>>   2 files changed, 223 insertions(+), 43 deletions(-)
> The original file is 360 lines. It doesn't really seem like there's a
> lot of overlap and I wonder if it is worth the extra overhead.
>
>> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> index 52478c8..1c71799 100644
>> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
>> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> @@ -14,6 +14,13 @@ The timer is attached to a GIC to deliver its per-processor interrupts.
>>   
>>   - clock-frequency : The frequency of the main counter, in Hz. Optional.
>>   
>> +- irq-is-not-percpu: Specify is the timer irq is *NOT* a percpu (PPI) interrupt
>> +  In the default case i.e without this property, the timer irq is treated as a
>> +  PPI interrupt. Optional.
> The first field in the gic interrupts binding already defines this.
Is there a generic way to extract that information from the interrupts 
binding. I saw Chris Smith's patch that adds irq_is_per_cpu function. 
Perhaps we can use that once it is merged ?
>
>> +
>> +- If the node address and reg is specified, the arch_timer will try to use the memory
>> +  mapped timer. Optional.
> This timer is fundamentally different h/w. You need a new compatible string.
I think that the timer is the same, but it just has a different 
interface. Do you still think we need a new compatible string ?
>
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
>>   
>>   /*
>>    * Architected system timer support.
>> @@ -44,7 +54,29 @@ static struct clock_event_device __percpu **arch_timer_evt;
>>   #define ARCH_TIMER_REG_FREQ		1
>>   #define ARCH_TIMER_REG_TVAL		2
>>   
>> -static void arch_timer_reg_write(int reg, u32 val)
>> +/* Iomapped Register Offsets */
>> +#define ARCH_TIMER_CNTP_LOW_REG		0x000
>> +#define ARCH_TIMER_CNTP_HIGH_REG	0x004
>> +#define ARCH_TIMER_CNTV_LOW_REG		0x008
>> +#define ARCH_TIMER_CNTV_HIGH_REG	0x00C
>> +#define ARCH_TIMER_CTRL_REG		0x02C
>> +#define ARCH_TIMER_FREQ_REG		0x010
>> +#define ARCH_TIMER_CNTP_TVAL_REG	0x028
>> +#define ARCH_TIMER_CNTV_TVAL_REG	0x038
>> +
>> +static void timer_reg_write_mem(int reg, u32 val)
>> +{
>> +	switch (reg) {
>> +	case ARCH_TIMER_REG_CTRL:
>> +		__raw_writel(val, timer_base + ARCH_TIMER_CTRL_REG);
>> +		break;
>> +	case ARCH_TIMER_REG_TVAL:
>> +		__raw_writel(val, timer_base + ARCH_TIMER_CNTP_TVAL_REG);
>> +		break;
> This whole function seems a bit pointless as it only adds timer_base.
>
> Rob
I tried to the keep the functions similar to the cp15 interface ones. Is 
there something else you suggest doing ?

Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

