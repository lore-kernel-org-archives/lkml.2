Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2DPPm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:42:26 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:34399 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2DPPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:42:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAgEjBFEBEAsUBAICBRYLAgIJAwIBAgFFBg0BBQIBAYgFrB+KGIEvjhOBGASpJYE4Fg
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174604664"
Message-ID: <4F8C3DDF.8030103@teksavvy.com>
Date: Mon, 16 Apr 2012 11:42:23 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com>
In-Reply-To: <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-16 10:23 AM, richard -rw- weinberger wrote:
> On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord <kernel@teksavvy.com> wrote:
>> On 12-04-16 12:36 AM, Mark Lord wrote:
>>> Something recent has killed suspend-to-ram on a number of machines here.
>>> The symptom is that they suspend, but immediately wake up and panic,
>>> with just a black screen so no visible messages to go by.
>>>
>>> The patch below works around the issue -- making things work as they used to work.
>>>
>>> +++ linux/drivers/rtc/interface.c     2012-04-16 00:09:14.105387382 -0400
>>> @@ -773,7 +773,7 @@
>>>       if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>>>               return;
>>>
>>> -     rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>>> +     //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
>>>  }


How about the line above -- that's the commit that breaks things here.
Thanks!

>> Speaking of which -- that batch of RTC updates is riddled with bugs.
>> For example, this beauty from rtc-mpc5121.c in the same update:
>>
>>        ...
>>        rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
>>                                        &mpc5200_rtc_ops, THIS_MODULE);
>>        ...
>>
>>        rtc->rtc->uie_unsupported = 1;    // <<<< Ooops NULL pointer >>>>
>>
>>        if (IS_ERR(rtc->rtc)) {           // <<<< this needs to be earlier >>>>
>>                err = PTR_ERR(rtc->rtc);
>>                goto out_free_irq;
>>        }
>>        ...
..
> ---
> commit 4a649903f91232d02284d53724b0a45728111767
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Tue Mar 6 17:16:09 2012 -0800
> 
>     rtc: Provide flag for rtc devices that don't support UIE
..
>     CC: stable@vger.kernel.org
>     Reported-by: Richard Weinberger <richard@nod.at>
>     Tested-by: Richard Weinberger <richard@nod.at>
>     Signed-off-by: John Stultz <john.stultz@linaro.org>
..

That commit is visibly buggy, but at least the fix is simple enough.
It's not what's breaking the systems here though.

Thanks again!


