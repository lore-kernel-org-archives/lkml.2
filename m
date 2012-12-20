Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2LTNcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:32:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40050 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2LTNc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:32:26 -0500
Message-ID: <50D31365.9000009@arm.com>
Date: Thu, 20 Dec 2012 13:32:21 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
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
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com> <1355996654-6579-6-git-send-email-hdoyu@nvidia.com> <50D2EFFB.8030702@arm.com> <20121220.135758.1347753620353343245.hdoyu@nvidia.com> <50D2FF19.4060600@arm.com> <20121220122246.GA6819@tbergstrom-lnx.Nvidia.com> <50D305A6.2080904@arm.com> <20121220125507.GB6819@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20121220125507.GB6819@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 20 Dec 2012 13:32:23.0002 (UTC) FILETIME=[714EDBA0:01CDDEB6]
X-MC-Unique: 112122013322402401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/12 12:55, Peter De Schrijver wrote:
> On Thu, Dec 20, 2012 at 01:33:42PM +0100, Marc Zyngier wrote:
>> On 20/12/12 12:22, Peter De Schrijver wrote:
>>>>>>> +
>>>>>>> +	/* CNTFRQ */
>>>>>>> +	asm("mcr p15, 0, %0, c14, c0, 0\n" : : "r" (freq));
>>>>>>> +	asm("mrc p15, 0, %0, c14, c0, 0\n" : "=r" (val));
>>>>>>> +	BUG_ON(val != freq);
>>>>>>
>>>>>> This is scary. CNTFRQ is only writable from secure mode, and will
>>>>>> explode in any other situation.
>>>>>>
>>>>>> Also, writing to CNTFRQ doesn't change the timer frequency! This is just
>>>>>> a way for secure mode to tell the rest of the world the frequency the
>>>>>> timer is ticking at. Unless you've wired the input clock to be able to
>>>>>> change the frequency?
>>>>>
>>>>> ATM, our upstream kernel is expected in secure mode. This situation
>>>>> may be changed later, though....
>>>>
>>>> I appreciate this. But I expect this kernel to be also used on the
>>>> non-secure side if someone tried to run KVM with it. And this would go
>>>> bang right away.
>>>>
>>>
>>> But the guest wouldn't necessarily have this peripheral, or any other Tegra114
>>> peripheral for that matter?
>>
>> The problem is not so much the guest but the host. The host has to be
>> booted in non-secure, so just saying "we do not support non-secure" is
>> not a very convincing argument.
>>
>> Unless of course you've already decided that you don't want to support
>> KVM on this SoC...
>>
> 
> I guess that means we can't support KVM yet. Tegra does not have a secure
> monitor by default. It all depends on what that system integrator does.

VExpress doesn't have a secure monitor either, and yet we run KVM on it
(by switching to non-secure before loading the kernel). Same for Exynos5.

What I'm trying to say is that this code is rather pointless (this
should be done by the firmware/bootloader, not the kernel, or the
information should be provided in DT if CNTFRQ is not set).

This way, no breakage, no dependency on the security level.

	M.
-- 
Jazz is not dead. It just smells funny...

