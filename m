Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0INHq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:46:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:61060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab0INHq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,363,1280732400"; 
   d="scan'208";a="657060295"
Message-ID: <4C8F2863.5070003@linux.intel.com>
Date: Tue, 14 Sep 2010 15:46:43 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: fix module init		for		hotplug-but-no-device-found
 case
References: <4C8E139F0200007800015AA5@vpn.id2.novell.com>	<4C8F167E.40506@linux.intel.com> <4C8F36B40200007800015E6B@vpn.id2.novell.com>
In-Reply-To: <4C8F36B40200007800015E6B@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 9/14/2010 2:47 PM, Jan Beulich 写道:
>>>> On 14.09.10 at 08:30, Chen Gong<gong.chen@linux.intel.com>  wrote:
>> 于 9/13/2010 6:05 PM, Jan Beulich 写道:
>>> In commit 0dca94baeab4a1a514841b0a4c8e3a51dfb4d5ae the call to
>>> platform_driver_unregister() was made conditional upon !HOTPLUG_CPU,
>>> but the return value from coretemp_init() was left to indicate an
>>> error. This isn't correct, as the negative return value indicates to
>>> the module loader that initialization failed, which isn't intended
>>
>> only !HOTPLUG_CPU can remove the driver. That is what we need to do
>> because under the hotplug condition, we need to consider those "offline"
>> cpus. I don't understand what you are afraid. Can you give me a scinario ?
>
> If the driver's init routine returns -ENODEV (like is the case without this
> change when HOTPLUG_CPU is enabled and there is no device found),
> the platform driver will remain registered, yet the driver memory will
> get freed (leaving dangling pointers into the driver's former image). Or

Under this condition, I can't fine who frees the memory of the platform
driver

> in other words - when leaving the driver registered, the return value
> of the init function must be zero.

Is it mandotary or just some kind of convention ?

>
> Jan
>
>>> here and results in dangling pointers.
>>>
>>> Signed-off-by: Jan Beulich<jbeulich@novell.com>
>>> Cc: Chen Gong<gong.chen@linux.intel.com>
>>>
>>> ---
>>>    drivers/hwmon/coretemp.c |    5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> --- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000
>> +0200
>>> +++
>> 2.6.36-rc4-x86-coretemp-hotplug-init-return/drivers/hwmon/coretemp.c	2010-
>> 09-03 17:54:14.000000000 +0200
>>> @@ -541,16 +541,19 @@ static int __init coretemp_init(void)
>>>    				" has no thermal sensor.\n", c->x86_model);
>>>    		}
>>>    	}
>>> +
>>> +#ifndef CONFIG_HOTPLUG_CPU
>>>    	if (list_empty(&pdev_list)) {
>>>    		err = -ENODEV;
>>>    		goto exit_driver_unreg;
>>>    	}
>>> +#endif
>>>
>>>    	register_hotcpu_notifier(&coretemp_cpu_notifier);
>>>    	return 0;
>>>
>>> -exit_driver_unreg:
>>>    #ifndef CONFIG_HOTPLUG_CPU
>>> +exit_driver_unreg:
>>>    	platform_driver_unregister(&coretemp_driver);
>>>    #endif
>>>    exit:
>>>
>>>
>>>
>>>
