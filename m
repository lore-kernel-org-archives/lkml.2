Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2IYBMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:12:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57784 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2IYBMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:12:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7f726d000000ec7-be-506105042906
Message-id: <50610504.7050706@samsung.com>
Date: Tue, 25 Sep 2012 10:12:36 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Zhang Rui <rui.zhang@intel.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>
Subject: Re: [PATCH] Thermal: Fix bug on generic thermal framework.
References: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
 <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
 <1348477068.10877.180.camel@rui.sh.intel.com>
In-reply-to: <1348477068.10877.180.camel@rui.sh.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jQV0W1sQAg84rFhaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsEroyvZxeyFLwXq3jbv5u5gfGJUBcjJ4eEgInE2cMTWCBs
	MYkL99azdTFycQgJTGeUuDe7iwkkwSsgKPFj8j2gIg4OZgF5iSOXskHCzALqEpPmLWKGqH/J
	KDFh9mU2iHotiSN/5rOD2CwCqhJHVq8Fi7MJyEm8bfrGCDJHVCBC4lc/B0hYREBZYtG5rYwg
	c5gF3jFJfNz9nRWkRljAWWLO6yiI+fsZJRYcfsAI0sApYCXR/OY3ywRGgVlIzpuFcN4sJOct
	YGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREciM+kdjCubLA4xCjAwajEw8uxISFAiDWx
	rLgy9xCjBAezkgjvlS6gEG9KYmVValF+fFFpTmrxIUZpDhYlcV7hT4EBQgLpiSWp2ampBalF
	MFkmDk6pBsbTnK7Ty1lrC1P7d4jXtqmesi0Nf3TJdMKsKaaTeAuDFkS69cyU5fzxmTt/u9hh
	lRV3lrC732Od9E2whvf5o3WLpDY4mR520l03Z4Ukw2qGD1z+76al3Y5Rt2HPk+Dd230zydbT
	v+mplVZvo5LkSt3vByyduErEV2lbPnWyfTUlSSLgfMf9JCWW4oxEQy3mouJEAEIWeAZAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 09월 24일 17:57, Zhang Rui wrote:
> On 一, 2012-09-24 at 02:08 -0600, R, Durgadoss wrote:
>> Hi,
>>
>> Patch is fine, but I think you have to re-base on top of
>> Rui's -next branch here:
>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
>>
>> Also, adding Rui to this mail, not sure whether he is in LKML/pm.
>>
>> Thanks,
>> Durga
>>
>>> -----Original Message-----
>>> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
>>> Sent: Monday, September 24, 2012 7:36 AM
>>> To: linux-pml@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org; Brown, Len; Rafael J. Wysocki; Andrew
>>> Morton; Amit Kachhap; R, Durgadoss; Jonghwa Lee
>>> Subject: [PATCH] Thermal: Fix bug on generic thermal framework.
>>>
>>> When system fails to bind cooling devices to thermal zone device during
>>> registering thermal zone device, it leaves registering without canceling
>>> delayed work. It probably makes panic if polling rate is not enough to release
>>> that work from workqueue. So it is better to ignore initialization of polling
>>> work to prevent that unexpected state.
>>>
> Hi, Jonghwa,
>
> I still do not understand what the problem is.
> Say if a cooling device fails to bind, the thermal zone device would
> still work properly, just like the failure cooling device is not
> referenced in this thermal zone.
>
> thanks,
> rui
Hi rui,
No, it doesn't work properly. If it fails to bind some cool dev to
thermal zone device, it frees thermal zone
device without canceling delayed work. After freeing thermal zone
device, system may call work function
pointed NULL as the timer expired. Thus it requires skipping the
initialization of polling work or canceling before
the unregister.

Thanks,
Jonghwa

>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> ---
>>>  drivers/thermal/thermal_sys.c |    6 ++++--
>>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>>> index 2ab31e4..744e69d 100644
>>> --- a/drivers/thermal/thermal_sys.c
>>> +++ b/drivers/thermal/thermal_sys.c
>>> @@ -1351,12 +1351,14 @@ struct thermal_zone_device
>>> *thermal_zone_device_register(const char *type,
>>>  		}
>>>  	mutex_unlock(&thermal_list_lock);
>>>
>>> +	if (result)
>>> +		goto unregister;
>>> +
>>>  	INIT_DELAYED_WORK(&(tz->poll_queue),
>>> thermal_zone_device_check);
>>>
>>>  	thermal_zone_device_update(tz);
>>>
>>> -	if (!result)
>>> -		return tz;
>>> +	return tz;
>>>
>>>  unregister:
>>>  	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
>>> --
>>> 1.7.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

