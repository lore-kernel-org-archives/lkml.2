Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2LTRJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:09:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35260 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LTRJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:09:12 -0500
Message-ID: <50D34630.9020708@arm.com>
Date: Thu, 20 Dec 2012 17:09:04 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
References: <50D305A6.2080904@arm.com><20121220125507.GB6819@tbergstrom-lnx.Nvidia.com><50D31365.9000009@arm.com> <20121220.164230.292625215885249791.hdoyu@nvidia.com>
In-Reply-To: <20121220.164230.292625215885249791.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 20 Dec 2012 17:09:05.0606 (UTC) FILETIME=[B776C660:01CDDED4]
X-MC-Unique: 112122017090900201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/12 14:42, Hiroshi Doyu wrote:
> Marc Zyngier <marc.zyngier@arm.com> wrote @ Thu, 20 Dec 2012 14:32:21 +0100:
> 
>> On 20/12/12 12:55, Peter De Schrijver wrote:
>>> On Thu, Dec 20, 2012 at 01:33:42PM +0100, Marc Zyngier wrote:
>>>> On 20/12/12 12:22, Peter De Schrijver wrote:
>>>>>>>>> +
>>>>>>>>> +	/* CNTFRQ */
>>>>>>>>> +	asm("mcr p15, 0, %0, c14, c0, 0\n" : : "r" (freq));
>>>>>>>>> +	asm("mrc p15, 0, %0, c14, c0, 0\n" : "=r" (val));
>>>>>>>>> +	BUG_ON(val != freq);
>>>>>>>>
>>>>>>>> This is scary. CNTFRQ is only writable from secure mode, and will
>>>>>>>> explode in any other situation.
>>>>>>>>
>>>>>>>> Also, writing to CNTFRQ doesn't change the timer frequency! This is just
>>>>>>>> a way for secure mode to tell the rest of the world the frequency the
>>>>>>>> timer is ticking at. Unless you've wired the input clock to be able to
>>>>>>>> change the frequency?
>>>>>>>
>>>>>>> ATM, our upstream kernel is expected in secure mode. This situation
>>>>>>> may be changed later, though....
>>>>>>
>>>>>> I appreciate this. But I expect this kernel to be also used on the
>>>>>> non-secure side if someone tried to run KVM with it. And this would go
>>>>>> bang right away.
>>>>>>
>>>>>
>>>>> But the guest wouldn't necessarily have this peripheral, or any other Tegra114
>>>>> peripheral for that matter?
>>>>
>>>> The problem is not so much the guest but the host. The host has to be
>>>> booted in non-secure, so just saying "we do not support non-secure" is
>>>> not a very convincing argument.
>>>>
>>>> Unless of course you've already decided that you don't want to support
>>>> KVM on this SoC...
>>>>
>>>
>>> I guess that means we can't support KVM yet. Tegra does not have a secure
>>> monitor by default. It all depends on what that system integrator does.
>>
>> VExpress doesn't have a secure monitor either, and yet we run KVM on it
>> (by switching to non-secure before loading the kernel). Same for Exynos5.
>>
>> What I'm trying to say is that this code is rather pointless (this
>> should be done by the firmware/bootloader, not the kernel, or the
>> information should be provided in DT if CNTFRQ is not set).
> 
> "tegra114.dtsi" has the folloiwng "tsc" entry. So can we consider that
> if dts has this entry, CNTFRQ is not set, which implies it's in secure
> mode. kernel should set it up by itself? Otherwise, skip this setup
> and use it. For example:
> 
>  	tsc {
>  		compatible = "nvidia,tegra114-tsc";
>  		reg = <0x700f0000 0x20000>;
> +		setup-cntfrq;
>  	};
> 
> Is this what you explained in the above?
> At least, kernel can survive without bootloader/firmware support, ATM.

No. The DT should only describe the hardware, and not something that is
Linux specific.

Just use the "clock-frequency" attribute in the timer arch-timer node,
and get rid of this CNTFRQ setting. The driver already knows how to deal
with this situation if this attribute is set.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

