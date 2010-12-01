Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab0LAFOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:14:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39567 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0LAFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:14:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CF5D990.7070407@jp.fujitsu.com>
Date: Wed, 01 Dec 2010 14:13:52 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] dmar: fix fault interrupt setup
References: <4CF4B597.4030708@jp.fujitsu.com>	 <4CF4B628.7060903@jp.fujitsu.com> <1291148304.5836.1.camel@sbsiddha-MOBL3>
In-Reply-To: <1291148304.5836.1.camel@sbsiddha-MOBL3>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/01 5:18), Suresh Siddha wrote:
> On Tue, 2010-11-30 at 00:30 -0800, Kenji Kaneshige wrote:
>> Fix the problem dmar fault event is not notified in x2apic cluster mode.
>>
>> In the current code, dmar fault event is configured before setting up
>> the x86_cpu_to_logical_apicid percpu variable in x2apic cluster
>> mode. Because of this, invalid apic ID is used for dmar fault
>> interrupt and this cuases the problem.
>>
>> To fix the problem, do dmar fault event configuration after local apic
>> setup (after end_local_APIC_setup()).
>>
>> Signed-off-by: Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>
>>
>>
>> ---
>>   arch/x86/kernel/apic/apic.c     |    9 +++++++++
>>   arch/x86/kernel/apic/probe_64.c |    7 -------
>>   2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> Index: linux-next-20101125/arch/x86/kernel/apic/apic.c
>> ===================================================================
>> --- linux-next-20101125.orig/arch/x86/kernel/apic/apic.c
>> +++ linux-next-20101125/arch/x86/kernel/apic/apic.c
>> @@ -1745,6 +1745,15 @@ int __init APIC_init_uniprocessor(void)
>>
>>   	end_local_APIC_setup();
>>
>> +#ifdef CONFIG_INTR_REMAP
>> +	/*
>> +	 * Now that local APIC setup is completed, configure the fault
>> +	 * handling for interrupt remapping.
>> +	 */
>> +	if (intr_remapping_enabled)
>> +		enable_drhd_fault_handling();
>> +#endif
> 
> BTW, this is wrong. APIC_init_uniprocessor() gets called only for UP
> kernel. I will move it to the end_local_APIC_setup()
> 

Oh, it's totally wrong. I'm sorry about that.

Maybe even with my wrong patch, dmar interrupt is configured in the
intel_iommu_init()->init_dmars()->dmar_set_interrupt() code path. I
think this is why I could not noticed my badness in my test.

By the way, why do we need to try to configure dmar interrupt in the
intel_iommu_init() code path again?

Regards,
Kenji Kaneshige

