Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2LTSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:16:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:16:51 -0500
Message-ID: <50D3560E.7080802@linaro.org>
Date: Thu, 20 Dec 2012 19:16:46 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sivaram Nair <sivaramn@nvidia.com>, Russ Anderson <rja@sgi.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuox.liu@intel.com" <shuox.liu@intel.com>,
        "yanmin_zhang@intel.com" <yanmin_zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [regression] cpuidle_get_cpu_driver livelocks idle system
References: <20121217193612.GA28600@sgi.com> <50CF95AD.8030406@linaro.org> <2092099.bR8HA2X8Pe@vostro.rjw.lan>
In-Reply-To: <2092099.bR8HA2X8Pe@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 12:33 AM, Rafael J. Wysocki wrote:
> On Monday, December 17, 2012 10:59:09 PM Daniel Lezcano wrote:
>> On 12/17/2012 08:36 PM, Russ Anderson wrote:
>>> The 3.7 kernel grinds to a halt on boot of a system with
>>> 2048 cpus.  NMI showed most of the cpus in
>>> _raw_spin_lock in cpuidle_get_cpu_driver().  (backtrace below)
>>>
>>> A quick look at cpuidle_get_cpu_driver() shows the hot lock.
>>>
>>> In drivers/cpuidle/driver.c:
>>> --------------------------------------------------------
>>> /**
>>>  * cpuidle_get_cpu_driver - return the driver tied with a cpu
>>>  */
>>> struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
>>> {
>>>         struct cpuidle_driver *drv;
>>>
>>>         if (!dev)
>>>                 return NULL;
>>>
>>>         spin_lock(&cpuidle_driver_lock);
>>>         drv = __cpuidle_get_cpu_driver(dev->cpu);
>>>         spin_unlock(&cpuidle_driver_lock);
>>>
>>>         return drv;
>>> }
>>> --------------------------------------------------------
>>
>> Hi Russ,
>>
>> thanks for investigating the problem. You are right, there is a
>> bottleneck here.
>>
>> Regarding how is used the cpuidle code, I think it is safe to remove the
>> locks.
> 
> OK, a patch would be appreciated. :-)
> 
> If you prepare one, please explain in the changelog why it is safe to drop the
> locks.

Ok, sure. I have some troubles with my x86 hardware, so it could take a
couple of days before I can send a fix a bit tested.


>>> This change was added in on Nov 14th, 2012.
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92
>>>
>>> The patch says it adds support for cpus with different characteristics,
>>> but adds a big global lock.  The comment claims "no impact for the other
>>> platforms if the option is disabled", which leads me to believe the
>>> spin_lock was added inadvertently.  CPU_IDLE_MULTIPLE_DRIVERS is off
>>> in my config file.
>>>
>>> linux$ grep CPU_IDLE_MULTIPLE_DRIVERS .config
>>> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
>>>
>>> As more cpus become idle, more cpus fight over the lock until
>>> the system livelocks on the crushing weight of idle.
>>>
>>> The fix may be to move the spin_lock into __cpuidle_get_cpu_driver,
>>> which has different versions for CONFIG_CPU_IDLE_MULTIPLE_DRIVERS,
>>> to avoid impacting the disabled case, or get rid of the spin_lock
>>> all together.
>>>
>>>
>>> --------------------------------------------------------
>>> == UV NMI process trace cpu 12: ==
>>> CPU 12
>>> Pid: 0, comm: swapper/12 Tainted: G           O 3.7.0.rja-sgi+ #38
>>> RIP: 0010:[<ffffffff81614e45>]  [<ffffffff81614e45>] _raw_spin_lock+0x25/0x30
>>> [...]
>>> Call Trace:
>>>  [<ffffffff814c891c>] cpuidle_get_cpu_driver+0x1c/0x30
>>>  [<ffffffff814c871d>] cpuidle_idle_call+0x7d/0x1b0
>>>  [<ffffffff8101d08d>] cpu_idle+0xdd/0x130
>>>  [<ffffffff8160a3ea>] start_secondary+0xc6/0xcc
>>> --------------------------------------------------------
>>>
>>
>>
>>


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

