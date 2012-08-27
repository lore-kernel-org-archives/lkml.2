Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2H0Skj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:40:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60848 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2H0Skh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:40:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6817"; a="229949681"
Message-ID: <503BBF24.2010107@codeaurora.org>
Date: Mon, 27 Aug 2012 11:40:36 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Cyril Chemparathy <cyril@ti.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        marc.zyngier@arm.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: local timers: add timer support using IO mapped
 register
References: <1344635921-5147-1-git-send-email-rvaswani@codeaurora.org> <5025C62B.10407@ti.com>
In-Reply-To: <5025C62B.10407@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2012 7:40 PM, Cyril Chemparathy wrote:
> On 8/10/2012 5:58 PM, Rohit Vaswani wrote:
>> The current arch_timer only support accessing through CP15 interface.
>> Add support for ARM processors that only support IO mapped register
>> interface
>>
>
> It looks like this patch attempts to address both (a) non-percpu arch 
> timers, and (b) memory mapped arch timers in one go.  These should 
> probably be broken out into two distinct logical changes.
>
Will split them.

> More below...
>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> ---
>>   .../devicetree/bindings/arm/arch_timer.txt         |    7 +
>>   arch/arm/kernel/arch_timer.c                       |  259 
>> ++++++++++++++++----
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
>>   - clock-frequency : The frequency of the main counter, in Hz. 
>> Optional.
>>
>> +- irq-is-not-percpu: Specify is the timer irq is *NOT* a percpu 
>> (PPI) interrupt
>> +  In the default case i.e without this property, the timer irq is 
>> treated as a
>> +  PPI interrupt. Optional.
>> +
>
> The handling of non-percpu IRQs looks broken.  The code does 
> (enable/disable)_percpu_irq() on IRQs that may no longer be percpu.
I am thinking of adding a wrapper function (function pointer in the 
timer_ops) that will call  (enable/disable)_percpu_irq() based on if the 
said property is defined or not.
>
>> +- If the node address and reg is specified, the arch_timer will try 
>> to use the memory
>> +  mapped timer. Optional.
>> +
>>   Example:
>>
>>       timer {
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
>
> Are percpu memory mapped arch timers an impossibility?
I will make sure to keep this open , as in add memory mapped timers as 
well as the possibility of percpu timer interrupts for both memory 
mapped and the cp15 interface.
>
>> +struct arch_timer_operations {
>> +    void (*reg_write)(int, u32);
>> +    u32 (*reg_read)(int);
>> +    cycle_t (*get_cntpct)(void);
>> +    cycle_t (*get_cntvct)(void);
>> +};
>>
>>   /*
>>    * Architected system timer support.
>> @@ -44,7 +54,29 @@ static struct clock_event_device __percpu 
>> **arch_timer_evt;
>>   #define ARCH_TIMER_REG_FREQ        1
>>   #define ARCH_TIMER_REG_TVAL        2
>>
>> -static void arch_timer_reg_write(int reg, u32 val)
>> +/* Iomapped Register Offsets */
>> +#define ARCH_TIMER_CNTP_LOW_REG        0x000
>> +#define ARCH_TIMER_CNTP_HIGH_REG    0x004
>> +#define ARCH_TIMER_CNTV_LOW_REG        0x008
>> +#define ARCH_TIMER_CNTV_HIGH_REG    0x00C
>> +#define ARCH_TIMER_CTRL_REG        0x02C
>> +#define ARCH_TIMER_FREQ_REG        0x010
>> +#define ARCH_TIMER_CNTP_TVAL_REG    0x028
>> +#define ARCH_TIMER_CNTV_TVAL_REG    0x038
>> +
>
> ARCH_TIMER_CNTV_TVAL_REG appears to be unused here.
>
>> +static void timer_reg_write_mem(int reg, u32 val)
>> +{
>> +    switch (reg) {
>> +    case ARCH_TIMER_REG_CTRL:
>> +        __raw_writel(val, timer_base + ARCH_TIMER_CTRL_REG);
>> +        break;
>> +    case ARCH_TIMER_REG_TVAL:
>> +        __raw_writel(val, timer_base + ARCH_TIMER_CNTP_TVAL_REG);
>> +        break;
>> +    }
>> +}
>> +
>
> Wouldn't an array of offsets to map from ARCH_TIMER_REG_* to these 
> memory mapped registers eliminate the need to switch-case your way 
> through each register?
Done.
>
>> +static void timer_reg_write_cp15(int reg, u32 val)
>>   {
>>       switch (reg) {
>>       case ARCH_TIMER_REG_CTRL:
>> @@ -58,7 +90,28 @@ static void arch_timer_reg_write(int reg, u32 val)
>>       isb();
>>   }
>>
>> -static u32 arch_timer_reg_read(int reg)
>> +static u32 timer_reg_read_mem(int reg)
>> +{
>> +    u32 val;
>> +
>> +    switch (reg) {
>> +    case ARCH_TIMER_REG_CTRL:
>> +        val = __raw_readl(timer_base + ARCH_TIMER_CTRL_REG);
>> +        break;
>> +    case ARCH_TIMER_REG_FREQ:
>> +        val = __raw_readl(timer_base + ARCH_TIMER_FREQ_REG);
>> +        break;
>> +    case ARCH_TIMER_REG_TVAL:
>> +        val = __raw_readl(timer_base + ARCH_TIMER_CNTP_TVAL_REG);
>> +        break;
>> +    default:
>> +        BUG();
>> +    }
>> +
>> +    return val;
>> +}
>> +
>
> Same as above.
>
>> +static u32 timer_reg_read_cp15(int reg)
>>   {
>>       u32 val;
>>
>> @@ -79,6 +132,103 @@ static u32 arch_timer_reg_read(int reg)
>>       return val;
>>   }
>>
>> +static cycle_t arch_counter_get_cntpct_mem(void)
>> +{
>> +    u32 cvall, cvalh, thigh;
>> +
>> +    do {
>> +        cvalh = __raw_readl(timer_base + ARCH_TIMER_CNTP_HIGH_REG);
>> +        cvall = __raw_readl(timer_base + ARCH_TIMER_CNTP_LOW_REG);
>> +        thigh = __raw_readl(timer_base + ARCH_TIMER_CNTP_HIGH_REG);
>> +    } while (cvalh != thigh);
>> +
>> +    return ((cycle_t) cvalh << 32) | cvall;
>> +}
>> +
>> +static cycle_t arch_counter_get_cntpct_cp15(void)
>> +{
>> +    u32 cvall, cvalh;
>> +
>> +    asm volatile("mrrc p15, 0, %0, %1, c14" : "=r" (cvall), "=r" 
>> (cvalh));
>> +
>> +    return ((cycle_t) cvalh << 32) | cvall;
>> +}
>> +
>> +static cycle_t arch_counter_get_cntvct_mem(void)
>> +{
>> +    u32 cvall, cvalh, thigh;
>> +
>> +    do {
>> +        cvalh = __raw_readl(timer_base + ARCH_TIMER_CNTV_HIGH_REG);
>> +        cvall = __raw_readl(timer_base + ARCH_TIMER_CNTV_LOW_REG);
>> +        thigh = __raw_readl(timer_base + ARCH_TIMER_CNTV_HIGH_REG);
>> +    } while (cvalh != thigh);
>> +
>> +    return ((cycle_t) cvalh << 32) | cvall;
>> +}
>> +
>
> Repetitive - the logic is identical to arch_counter_get_cntpct_mem() 
> above.
>
>> +static cycle_t arch_counter_get_cntvct_cp15(void)
>> +{
>> +    u32 cvall, cvalh;
>> +
>> +    asm volatile("mrrc p15, 1, %0, %1, c14" : "=r" (cvall), "=r" 
>> (cvalh));
>> +
>> +    return ((cycle_t) cvalh << 32) | cvall;
>> +}
>> +
>> +static struct arch_timer_operations arch_timer_ops_cp15 = {
>> +    .reg_read = &timer_reg_read_cp15,
>> +    .reg_write = &timer_reg_write_cp15,
>> +    .get_cntpct = &arch_counter_get_cntpct_cp15,
>> +    .get_cntvct = &arch_counter_get_cntvct_cp15,
>> +};
>> +
>> +static struct arch_timer_operations arch_timer_ops_mem = {
>> +    .reg_read = &timer_reg_read_mem,
>> +    .reg_write = &timer_reg_write_mem,
>> +    .get_cntpct = &arch_counter_get_cntpct_mem,
>> +    .get_cntvct = &arch_counter_get_cntvct_mem,
>> +};
>> +
>> +static struct arch_timer_operations *arch_specific_timer = 
>> &arch_timer_ops_cp15;
>> +
>> +static inline void arch_timer_reg_write(int reg, u32 val)
>> +{
>> +    arch_specific_timer->reg_write(reg, val);
>> +}
>> +
>> +static inline u32 arch_timer_reg_read(int reg)
>> +{
>> +    return arch_specific_timer->reg_read(reg);
>> +}
>> +
>> +static inline cycle_t arch_counter_get_cntpct(void)
>> +{
>> +    return arch_specific_timer->get_cntpct();
>> +}
>> +
>> +static inline cycle_t arch_counter_get_cntvct(void)
>> +{
>> +    return arch_specific_timer->get_cntvct();
>> +}
>> +
>
> The 4 pointer chasers above could lose some verbosity by being #defines.
I am rebasing this patch on top of Marc's similar patch to add support 
for virtual timers and will fix up the problems you have mentioned.
Thanks for your feedback.
>
> <snip>


Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

