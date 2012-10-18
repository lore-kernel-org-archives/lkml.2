Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2JRGn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:43:58 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59351 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2JRGn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:43:57 -0400
Message-ID: <507FA4E5.3090604@linux.vnet.ibm.com>
Date: Thu, 18 Oct 2012 12:12:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v9 12/12] x86, topology: Debug CPU00 hotplug
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com> <1350058189-6769-13-git-send-email-fenghua.yu@intel.com> <507D1F2F.1010006@linux.vnet.ibm.com> <3E5A0FA7E9CA944F9D5414FEC6C7122030B196BC@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122030B196BC@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12101806-4790-0000-0000-0000052087C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 05:36 AM, Yu, Fenghua wrote:
>>> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
>  > +	case PM_RESTORE_PREPARE:
>>> +		/*
>>> +		 * When system resumes from hibernation, online CPU0
>> because
>>> +		 * 1. it's required for resume and
>>> +		 * 2. the CPU was online before hibernation
>>> +		 */
>>> +		if (!cpu_online(0))
>>> +			_debug_hotplug_cpu(0, 1);
>>
>> This won't work. CPU hotplug is disabled by cpu_hotplug_pm_callback()
>> during
>> PM_HIBERNATION_PREPARE and is enabled back only during
>> PM_POST_HIBERNATION.
>>
>> So calls to cpu_up() or cpu_down() will fail in the meantime.
> 
> The code works just fine.
> 
> You are talking about hibernation/suspend phase. This piece of
> code is all about restore phase. Of course you can call cpu_up()
> and cpu_down() during restore phase.
> 
> So there is no problem here.
> 

I looked into it again, and actually you are right, it'll work fine;
but the reason *why* it will work fine is quite subtle.

Note that there is a difference between calling cpu_up() or cpu_down()
vs calling _cpu_up() or _cpu_down(). The former set of calls will return
-EBUSY if the 'cpu_hotplug_disabled' flag is set. The latter set of calls
don't care about that flag and hence proceed irrespective of the state of
that flag. The former set of calls are used when you echo 0/1 to the online
file from userspace. Whereas the latter set of calls are used by the
disable/enable_nonboot_cpus() functions. This is how you can disable
cpu hotplug by userspace, but continue to do cpu hotplug yourself from
within the kernel in the suspend/hibernation/restore phases.

Now, coming to the notifications part, earlier, I was referring to the
entire hibernate->restore phase, not just the hibernate phase. The relevant
notifications that are sent out during this entire (successful) sequence are:

-> PM_HIBERNATION_PREPARE
-> PM_RESTORE_PREPARE
-> PM_POST_HIBERNATION

cpu_hotplug_pm_callback() will set the cpu_hotplug_disabled flag during
PM_HIBERNATION_PREPARE and clears it only during PM_POST_HIBERNATION.
So in-between, if you invoke cpu_up() or cpu_down(), it should return -EBUSY.

Then how is it that this patch can work fine? The answer is, during the
restore phase, you are not yet in the kernel-to-be-restored. IOW, that
cpu_hotplug_disabled flag is clear in that kernel. That's why cpu_up() and
cpu_down() will continue to work at that point. But once you resume execution
from the saved hibernation image, you won't be able to do cpu_up() and
cpu_down() until that flag is cleared by cpu_hotplug_pm_callback() during
PM_POST_HIBERNATION.

All in all, its tricky, and luckily this patch uses cpu_up()/cpu_down()
at the right moment...

I don't actually see why cpu_hotplug_pm_callback() should not clear the
cpu_hotplug_disabled flag during PM_RESTORE_PREPARE itself.. if we do that,
we don't have to be *this* careful about -when- we can invoke -which-
function.. 

Regards,
Srivatsa S. Bhat

