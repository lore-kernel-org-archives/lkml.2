Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2JPQbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:31:53 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:49666 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2JPQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:31:51 -0400
Message-ID: <507D8BBD.3010306@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 22:00:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend
 or hibernate
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com> <10020874.9eDCB3ZAkx@vostro.rjw.lan> <507CF216.3010507@linux.vnet.ibm.com> <1586487.pWfqEJ2K11@vostro.rjw.lan>
In-Reply-To: <1586487.pWfqEJ2K11@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101616-3864-0000-0000-00000517A30E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 09:47 PM, Rafael J. Wysocki wrote:
> On Tuesday 16 of October 2012 11:05:18 Srivatsa S. Bhat wrote:
>> On 10/16/2012 02:20 AM, Rafael J. Wysocki wrote:
>>> On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
>>>> From: Fenghua Yu <fenghua.yu@intel.com>
>>>>
>>>> +
>>>> +/*
>>>> + * When bsp_check() is called in hibernate and suspend, cpu hotplug
>>>> + * is disabled already. So it's unnessary to handle race condition between
>>>> + * cpumask query and cpu hotplug.
>>>> + */
>>>> +static int bsp_check(void)
>>>> +{
>>>> +	if (cpumask_first(cpu_online_mask) != 0) {
>>>> +		pr_warn("CPU0 is offline.\n");
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int bsp_pm_callback(struct notifier_block *nb, unsigned long action,
>>>> +			   void *ptr)
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	switch (action) {
>>>> +	case PM_SUSPEND_PREPARE:
>>>> +	case PM_HIBERNATION_PREPARE:
>>>> +		ret = bsp_check();
>>>> +		break;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>> +	return notifier_from_errno(ret);
>>>> +}
>>>> +
>>>
>>> I wonder if there's anything preventing CPU0 from becoming offline after you've
>>> done this check and before user space is frozen?
>>>
>>
>> Hi Rafael,
>>
>> bsp_pm_callback runs as a low priority notifier callback, specifically with lower
>> priority than the cpu_hotplug_pm_callback (as mentioned in the comment below).
>> And cpu_hotplug_pm_callback disables regular CPU hotplug (till the suspend/resume
>> sequence is complete).. So there is no chance for CPU0 to become offline after that.
>>
>> Or, are you thinking of some other scenario where CPU0 can go offline?
> 
> No, that should be fine technically, but designs relying on notifier priority
> for correctness are kind of fragile.
> 

Hmm.. I agree.

> Would it be possible to make cpu_hotplug_pm_callback() do the BSP online check?
>

Good idea! I think that could be done quite easily. And while doing that, it would
be good to rethink what to do in patch 12/12 (Debug CPU0 hotplug) to fix the bug I
pointed out in my other mail.

Regards,
Srivatsa S. Bhat

>>>> +static int __init bsp_pm_check_init(void)
>>>> +{
>>>> +	/*
>>>> +	 * Set this bsp_pm_callback as lower priority than
>>>> +	 * cpu_hotplug_pm_callback. So cpu_hotplug_pm_callback will be called
>>>> +	 * earlier to disable cpu hotplug before bsp online check.
>>>> +	 */
>>>> +	pm_notifier(bsp_pm_callback, -INT_MAX);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +core_initcall(bsp_pm_check_init);
> 

