Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0LIDlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:41:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31047 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0LIDls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:41:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6191"; a="65880910"
Message-ID: <4D004FFB.80100@codeaurora.org>
Date: Wed, 08 Dec 2010 19:41:47 -0800
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/6] msm: add SMP support for msm
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org>	<1291782501-3909-7-git-send-email-johlstei@codeaurora.org> <20101208152142.GH9777@n2100.arm.linux.org.uk>
In-Reply-To: <20101208152142.GH9777@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Tue, Dec 07, 2010 at 08:28:21PM -0800, Jeff Ohlstein wrote:
>> +int get_core_count(void)
>> +{
>> +#ifdef CONFIG_NR_CPUS
>> +	return CONFIG_NR_CPUS;
>> +#else
>> +	return 1;
>> +#endif
>>     
>
> When would CONFIG_NR_CPUS not be set when SMP is available?
>
> Note that linux/threads.h defines this to 1 if it's not already defined
> anyway.  Does this really need to be a separate function?
>
>   
Removed.
>> +int boot_secondary(unsigned int cpu, struct task_struct *idle)
>> +{
>> +	static int cold_boot_done;
>> +	int cnt = 0;
>> +	printk(KERN_DEBUG "Starting secondary CPU %d\n", cpu);
>> +
>> +	if (cold_boot_done == false) {
>> +		prepare_cold_cpu(cpu);
>> +		cold_boot_done = true;
>> +	}
>> +
>> +	pen_release = cpu;
>> +	dmac_flush_range((void *)&pen_release,
>> +			 (void *)(&pen_release + sizeof(pen_release)));
>>     
>
> Abuse of the DMA API.  See how other platforms deal with this.
>
>   
Fixed to use __cpuc_flush_dcache_area and outer_clean_range.
>> +	__asm__("sev");
>> +	dsb();
>> +
>> +	/* Use smp_cross_call() to send a soft interrupt to wake up
>> +	 * the other core.
>> +	 */
>> +	smp_cross_call(cpumask_of(cpu));
>> +
>> +	while (pen_release != 0xFFFFFFFF) {
>>     
>
> Why 0xFFFFFFFF rather than -1 like everyone else does?
>
>   
Removed due to below.
>> +		smp_rmb();
>> +		msleep_interruptible(1);
>> +		if (cnt++ >= SECONDARY_CPU_WAIT_MS)
>> +			break;
>> +	}
>>     
>
> And why not use the same loop as everyone else does?
>
>         timeout = jiffies + (1 * HZ);
>         while (time_before(jiffies, timeout)) {
>                 smp_rmb();
>                 if (pen_release == -1)
>                         break;
>
>                 udelay(10);
>         }
>
> IOW, what's the point of being different when you're trying to do the
> same task?
>
>   
Done.
>> +
>> +	return 0;
>> +}
>> +
>> +/* Mask for edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
>> +#define GIC_PPI_EDGE_MASK 0xFFFFD7FF
>> +
>> +/* Initialization routine for secondary CPUs after they are brought out of
>> + * reset.
>> +*/
>> +void platform_secondary_init(unsigned int cpu)
>> +{
>> +	printk(KERN_DEBUG "%s: cpu:%d\n", __func__, cpu);
>> +
>> +	trace_hardirqs_off();
>>     
>
> This has been moved into the generic SMP code.
>
>   
I've rebased onto your gic patches and your smp series, and removed this.
>> +	if (!machine_is_msm8x60_sim())
>> +		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
>>     
>
> The gic secondary CPU initialization now takes care of this in my tree.
>
>   
Removed.
>> +
>> +	/*
>> +	 * setup GIC (GIC number NOT CPU number and the base address of the
>> +	 * GIC CPU interface
>> +	 */
>> +	gic_cpu_init(0, MSM_QGIC_CPU_BASE);
>>     
>
> This has been renamed to gic_secondary_init() for 2.6.38.
>
>   
Done.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

