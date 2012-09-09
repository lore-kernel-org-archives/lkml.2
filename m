Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2IIOyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 10:54:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:40752 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2IIOy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 10:54:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,394,1344236400"; 
   d="scan'208";a="219973045"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Topic: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Index: AQHNjpddEaLQ0dDCRmG5O7fBmMDyI5eCFmDw
Date: Sun, 9 Sep 2012 14:54:26 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335323599@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com>
 <5048AC08.5050100@redhat.com>
 <DE8DF0795D48FD4CA783C40EC8292335322311@SHSMSX101.ccr.corp.intel.com>
 <504CA787.2000905@redhat.com>
In-Reply-To: <504CA787.2000905@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 09/07/2012 03:07 PM, Liu, Jinsong wrote:
>> Avi Kivity wrote:
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 148ed66..0e64997 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -2210,7 +2210,11 @@ int kvm_dev_ioctl_check_extension(long ext)
>>>>  		r = kvm_has_tsc_control; break;
>>>>  	case KVM_CAP_TSC_DEADLINE_TIMER:
>>>> +#ifdef CONFIG_HIGH_RES_TIMERS
>>>>  		r = boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER); +#else +		r =
>>>> 0; +#endif
>>>>  		break;
>>> 
>>> I prefer a patch making kvm for x86 depend on hrtimers.  kvm already
>>> provides a high resolution timer to the guest in the local apic,
>>> backing it with the jiffies event source will likely cause some
>>> guests to malfunction.
>> 
>> Yep, I did a draft test for kvm lapic timer, it also worked fail
>> when CONFIG_HIGH_RES_TIMERS disabled. 
>> 
>> Attached is the udpated patch.
>> 
>> Thanks,
>> Jinsong
>> 
>> ====================
>> From 64d0458ec50a7d6917adf1e9735ba6e6ae6024ad Mon Sep 17 00:00:00
>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Sat, 8 Sep 2012 03:32:31 +0800
>> Subject: [PATCH] KVM: select HIGH_RES_TIMERS when KVM enabled
>> 
>> This is for 2 reasons:
>> 1. it's pointless for kvm lapic timer and tsc deadline timer
>> when kernel hrtimer not configured as high resolution, since
>> that would be not accurate based on wheel;
>> 2. kvm lapic timer and tsc deadline timer based on hrtimer,
>> setting a leftmost node to rb tree and then do hrtimer reprogram.
>> If hrtimer not configured as high resolution,
>> hrtimer_enqueue_reprogram 
>> do nothing and then make kvm lapic timer and tsc deadline timer fail.
>> 
>> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com> ---
>>  arch/x86/kvm/Kconfig |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index a28f338..5f861ca 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -24,6 +24,8 @@ config KVM
>>  	depends on PCI
>>  	# for TASKSTATS/TASK_DELAY_ACCT:
>>  	depends on NET
>> +	# for HIGH_RES_TIMERS
>> +	depends on !ARCH_USES_GETTIMEOFFSET
>>  	select PREEMPT_NOTIFIERS
>>  	select MMU_NOTIFIER
>>  	select ANON_INODES
>> @@ -37,6 +39,8 @@ config KVM
>>  	select TASK_DELAY_ACCT
>>  	select PERF_EVENTS
>>  	select HAVE_KVM_MSI
>> +	select GENERIC_CLOCKEVENTS
>> +	select HIGH_RES_TIMERS
> 
> hrtimers is an intrusive feature, I don't think we should force-enable
> it.  Please change it to a depends on.

Hmm, if it changed as
config KVM
	depends on HIGH_RES_TIMERS
The item 'Kernel-based Virtual Machine (KVM) support (NEW)' even didn't appear to user when make menuconfig (when HIGH_RES_TIMERS disable)

Is it good? I just have a little concern here:)

Thanks,
Jinsong