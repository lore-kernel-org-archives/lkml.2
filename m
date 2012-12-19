Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2LSH40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:56:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:39649 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LSH4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:56:21 -0500
Message-ID: <50D1730D.7010108@ahsoftware.de>
Date: Wed, 19 Dec 2012 08:55:57 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vincent Palatin <vpalatin@chromium.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org> <20121218164659.a3d3655a.akpm@linux-foundation.org> <50D16EA3.8040803@ahsoftware.de> <20121218234543.786a2211.akpm@linux-foundation.org>
In-Reply-To: <20121218234543.786a2211.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.12.2012 08:45, schrieb Andrew Morton:
> On Wed, 19 Dec 2012 08:37:07 +0100 Alexander Holler <holler@ahsoftware.de> wrote:
>
>> Am 19.12.2012 01:46, schrieb Andrew Morton:
>>> On Thu,  2 Aug 2012 16:53:25 -0700
>>> Vincent Palatin <vpalatin@chromium.org> wrote:
>>>
>>>> When calling rtc_device_unregister, we are not freeing the id used by the
>>>> driver.
>>>> So when doing a unload/load cycle for a RTC driver (e.g. rmmod rtc_cmos
>>>> && modprobe rtc_cmos), its id is incremented by one. As a consequence,
>>>> we no longer have neither an rtc0 driver nor a /proc/driver/rtc (as it
>>>> only exists for the first driver).
>>>>
>>>> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
>>>> ---
>>>>    drivers/rtc/class.c |    1 +
>>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
>>>> index dc4c274..37b1d82 100644
>>>> --- a/drivers/rtc/class.c
>>>> +++ b/drivers/rtc/class.c
>>>> @@ -238,6 +238,7 @@ void rtc_device_unregister(struct rtc_device *rtc)
>>>>    		rtc_proc_del_device(rtc);
>>>>    		device_unregister(&rtc->dev);
>>>>    		rtc->ops = NULL;
>>>> +		ida_simple_remove(&rtc_ida, rtc->id);
>>>>    		mutex_unlock(&rtc->ops_lock);
>>>>    		put_device(&rtc->dev);
>>>>    	}
>>>
>>> Now I think about it, this shouldn't have been needed?
>>>
>>> That put_device() should call rtc_device_release(), which does the
>>> ida_simple_remove().  Isn't that working?
>>
>> It is, see the mini-thread, patch and my comment here:
>>
>> https://lkml.org/lkml/2012/12/6/152
>>
>> Maybe it would be better to move the ida_simple_remove from the
>> rtc_device_release to rt_device_unregister as I've hinted in the above
>> comment. That would make it easier to spot the ida_simple_remove().
>
> I'm all confused.
>
> Lothar's patch simply reverts Vincent's patch.  And that appears to be
> the correct thing to so, as the ida_simple_remove() in
> rtc_device_release() should be sufficient.
>
> But apparently that doesn't work, because Vincent was seeing the RTC
> ID's increment rather than getting reused.
>
> Is it the case that rtc_device_release() is not being called sometimes?
> If so, under what circumstances?

Maybe something (sysfs or whatever) still has a reference to it. Vincent 
should check that.

But I'm sure the ID will be recycled with that put_device() in 
unregister because I've got the same warning as Lothar did when 
(porperly) removing an RTC (with kernel 3.7).

Regards,

Alexander
