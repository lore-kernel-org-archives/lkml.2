Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2IXIUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:20:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34014 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2IXIUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:20:02 -0400
Date: Mon, 24 Sep 2012 17:20:00 +0900
From: jonghwa3.lee@samsung.com
Subject: Re: [PATCH] Thermal: Fix bug on generic thermal framework.
In-reply-to: <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pml@vger.kernel.org" <linux-pml@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Message-id: <506017B0.6000201@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-AuditID: cbfee61a-b7f726d000000ec7-77-506017b02ea2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jQd0N4gkBBg9fallc3jWHzWLzrR/s
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8/zONrWCGYMWz5TNZGhhn8HUxcnJICJhITL6/lgXC
	FpO4cG89WxcjF4eQwHRGiRebrzCDJHgFBCV+TL4HVMTBwSwgL3HkUjZImFlAXWLSvEXMEPUv
	GSVav/cyQdRrScxvP8EOYrMIqEos/NMKNodNQE7ibdM3RpA5ogIREr/6OUDCIkDl7Tt2MoLM
	YRZ4xSRxffoBsBphAWeJOa+jIOb3M0r8eP4cbD6nQIjE7ztt7BMYBWYhOW8WwnmzkJy3gJF5
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwID6T2sG4ssHiEKMAB6MSDy/n+fgAIdbEsuLK
	3EOMEhzMSiK8Ec+AQrwpiZVVqUX58UWlOanFhxilOViUxHmFPwUGCAmkJ5akZqemFqQWwWSZ
	ODilGhilW0VOF5UuUZv/gCN72absAnmF/TFHK+f7Gje2fC5T1VIK7btQvjflm7jP8djHt6ba
	nHgw2/qiJCPfnz6Xj1Nc783d2Sjuvum4/eqO8zv6Od1f5WsUdliU2x3kWXKUrzPO7qbU2T+z
	ZY082lQDW5MaX/5P8pjUJs1WtvbjJ7Pc+cHfZz51tVZiKc5INNRiLipOBACizAylQAIAAA==
References: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
 <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 09월 24일 17:08, R, Durgadoss wrote:
> Hi,
>
> Patch is fine, but I think you have to re-base on top of
> Rui's -next branch here:
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
>
> Also, adding Rui to this mail, not sure whether he is in LKML/pm.
>
> Thanks,
> Durga

I'll re-base and re-post it.
Thanks

>> -----Original Message-----
>> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
>> Sent: Monday, September 24, 2012 7:36 AM
>> To: linux-pml@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; Brown, Len; Rafael J. Wysocki; Andrew
>> Morton; Amit Kachhap; R, Durgadoss; Jonghwa Lee
>> Subject: [PATCH] Thermal: Fix bug on generic thermal framework.
>>
>> When system fails to bind cooling devices to thermal zone device during
>> registering thermal zone device, it leaves registering without canceling
>> delayed work. It probably makes panic if polling rate is not enough to release
>> that work from workqueue. So it is better to ignore initialization of polling
>> work to prevent that unexpected state.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/thermal/thermal_sys.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>> index 2ab31e4..744e69d 100644
>> --- a/drivers/thermal/thermal_sys.c
>> +++ b/drivers/thermal/thermal_sys.c
>> @@ -1351,12 +1351,14 @@ struct thermal_zone_device
>> *thermal_zone_device_register(const char *type,
>>  		}
>>  	mutex_unlock(&thermal_list_lock);
>>
>> +	if (result)
>> +		goto unregister;
>> +
>>  	INIT_DELAYED_WORK(&(tz->poll_queue),
>> thermal_zone_device_check);
>>
>>  	thermal_zone_device_update(tz);
>>
>> -	if (!result)
>> -		return tz;
>> +	return tz;
>>
>>  unregister:
>>  	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
>> --
>> 1.7.4.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

