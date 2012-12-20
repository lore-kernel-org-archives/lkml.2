Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2LTMGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:06:02 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58620 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2LTMFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:05:52 -0500
Message-ID: <50D2FF19.4060600@arm.com>
Date: Thu, 20 Dec 2012 12:05:45 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/9] clocksource: tegra: Enable ARM arch_timer with TSC
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com><1355996654-6579-6-git-send-email-hdoyu@nvidia.com><50D2EFFB.8030702@arm.com> <20121220.135758.1347753620353343245.hdoyu@nvidia.com>
In-Reply-To: <20121220.135758.1347753620353343245.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 20 Dec 2012 12:05:46.0832 (UTC) FILETIME=[58263D00:01CDDEAA]
X-MC-Unique: 112122012054906401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/12 11:57, Hiroshi Doyu wrote:
> Marc Zyngier <marc.zyngier@arm.com> wrote @ Thu, 20 Dec 2012 12:01:15 +0100:
> 
>> On 20/12/12 09:44, Hiroshi Doyu wrote:
>>> Add platform enabler for ARM arch_timer(TSC). TSC is more fine grained
>>> timer than TMR0. If it's available, it will be used for clock source
>>> and sched_clock. Otherwise, TMR0 is used. In any case TMR0 is
>>> necessary for clock event.
>>>
>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>> ---
>>>  .../bindings/arm/tegra/nvidia,tegra114-tsc.txt     |   11 ++++
>>>  drivers/clocksource/tegra20_timer.c                |   64 +++++++++++++++++++-
>>>  2 files changed, 74 insertions(+), 1 deletion(-)
>>>  create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt
>>> new file mode 100644
>>> index 0000000..9de936a
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt
>>> @@ -0,0 +1,11 @@
>>> +NVIDIA Tegra Timer Stamp Counter(TSC)
>>> +
>>> +Required properties:
>>> +- compatible : "nvidia,tegra114-tsc
>>> +- reg : Should contain 1 register ranges(address and length)
>>> +
>>> +Example:
>>> +	tsc {
>>> +		compatible = "nvidia,tegra114-tsc";
>>> +		reg = <0x700f0000 0x20000>;
>>> +	};
>>> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
>>> index 1d25de8..285a6f1 100644
>>> --- a/drivers/clocksource/tegra20_timer.c
>>> +++ b/drivers/clocksource/tegra20_timer.c
>>> @@ -30,6 +30,7 @@
>>>  #include <asm/mach/time.h>
>>>  #include <asm/smp_twd.h>
>>>  #include <asm/sched_clock.h>
>>> +#include <asm/arch_timer.h>
>>>  
>>>  #define RTC_SECONDS            0x08
>>>  #define RTC_SHADOW_SECONDS     0x0c
>>> @@ -271,10 +272,71 @@ static void __init tegra20_init_tmr(void)
>>>  	clockevents_register_device(&tegra_clockevent);
>>>  }
>>>  
>>> +#define TSC_CNTCR		0		/* TSC control registers */
>>> +#define TSC_CNTCR_ENABLE	(1 << 0)	/* Enable */
>>> +#define TSC_CNTCR_HDBG		(1 << 1)	/* Halt on debug */
>>> +
>>> +#define TSC_CNTCV0		0x8		/* TSC counter (LSW) */
>>> +#define TSC_CNTCV1		0xc		/* TSC counter (MSW) */
>>> +#define TSC_CNTFID0		0x20		/* TSC freq id 0 */
>>> +
>>> +static const struct of_device_id tegra_tsc_match[] __initconst = {
>>> +	{ .compatible = "nvidia,tegra114-tsc" },
>>> +	{}
>>> +};
>>> +
>>> +static int tegra_arch_timer_init(void)
>>> +{
>>> +	int err;
>>> +	struct device_node *np;
>>> +	struct clk *clk;
>>> +	void __iomem *tsc_base;
>>> +	u32 freq, val;
>>> +
>>> +	np = of_find_matching_node(NULL, tegra_tsc_match);
>>> +	if (!np)
>>> +		return -ENODEV;
>>> +
>>> +	tsc_base = of_iomap(np, 0);
>>> +	if (!tsc_base)
>>> +		return -ENODEV;
>>> +
>>> +	clk = clk_get_sys("clk_m", NULL);
>>> +	if (IS_ERR(clk)) {
>>> +		freq = 12000000;
>>> +		pr_warn("Unable to get timer clock. Assuming 12Mhz input clock.\n");
>>> +	} else {
>>> +		freq = clk_get_rate(clk);
>>> +		clk_put(clk);
>>> +	}
>>> +	writel_relaxed(freq, tsc_base + TSC_CNTFID0);
>>> +
>>> +	/* CNTFRQ */
>>> +	asm("mcr p15, 0, %0, c14, c0, 0\n" : : "r" (freq));
>>> +	asm("mrc p15, 0, %0, c14, c0, 0\n" : "=r" (val));
>>> +	BUG_ON(val != freq);
>>
>> This is scary. CNTFRQ is only writable from secure mode, and will
>> explode in any other situation.
>>
>> Also, writing to CNTFRQ doesn't change the timer frequency! This is just
>> a way for secure mode to tell the rest of the world the frequency the
>> timer is ticking at. Unless you've wired the input clock to be able to
>> change the frequency?
> 
> ATM, our upstream kernel is expected in secure mode. This situation
> may be changed later, though....

I appreciate this. But I expect this kernel to be also used on the
non-secure side if someone tried to run KVM with it. And this would go
bang right away.

	M.

-- 
Jazz is not dead. It just smells funny...

