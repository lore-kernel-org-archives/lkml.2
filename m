Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2DPOXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:23:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34429 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326Ab2DPOXi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F8C24E5.4020703@teksavvy.com>
References: <4F8BA1C1.4030804@teksavvy.com>
	<4F8C24E5.4020703@teksavvy.com>
Date: Mon, 16 Apr 2012 16:23:36 +0200
Message-ID: <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 12-04-16 12:36 AM, Mark Lord wrote:
>> Something recent has killed suspend-to-ram on a number of machines here.
>> The symptom is that they suspend, but immediately wake up and panic,
>> with just a black screen so no visible messages to go by.
>>
>> The patch below works around the issue -- making things work as they used to work.
>>
>> +++ linux/drivers/rtc/interface.c     2012-04-16 00:09:14.105387382 -0400
>> @@ -773,7 +773,7 @@
>>       if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>>               return;
>>
>> -     rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>> +     //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
>>  }
>>
>> Last known working kernel was 3.2.11.
>> The line above got added somewhere between it and 3.2.15,
>> and is also present (no surprise) in newer kernels.
>>
>> The highest kernel I've tested for this is 3.3.2,
>> which also fails until I nuke the line shown above.
>>
>> This is straight x86_64 (Atom) hardware, using rtc-cmos.
>> I can re-test if anyone has a fix for this.
>>
>> Meanwhile, whatever patch put this into -stable probably
>> ought to be reverted upstream and in -stable as well.
>
>
> Speaking of which -- that batch of RTC updates is riddled with bugs.
> For example, this beauty from rtc-mpc5121.c in the same update:
>
>        ...
>        rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
>                                        &mpc5200_rtc_ops, THIS_MODULE);
>        ...
>
>        rtc->rtc->uie_unsupported = 1;    // <<<< Ooops NULL pointer >>>>
>
>        if (IS_ERR(rtc->rtc)) {           // <<<< this needs to be earlier >>>>
>                err = PTR_ERR(rtc->rtc);
>                goto out_free_irq;
>        }
>        ...
>
> Can somebody show me how to identify the commit from the code?
> I know which lines got changed, but don't know how to find
> the corresponding commits in -git.

CC'in John.

---
commit 4a649903f91232d02284d53724b0a45728111767
Author: John Stultz <john.stultz@linaro.org>
Date:   Tue Mar 6 17:16:09 2012 -0800

    rtc: Provide flag for rtc devices that don't support UIE

    Richard Weinberger noticed that on some RTC hardware that
    doesn't support UIE mode, due to coarse granular alarms
    (like 1minute resolution), the current virtualized RTC
    support doesn't properly error out when UIE is enabled.

    Instead the current code queues an alarm for the next second,
    but it won't fire until up to a miniute later.

    This patch provides a generic way to flag this sort of hardware
    and fixes the issue on the mpc5121 where Richard noticed the
    problem.

    CC: stable@vger.kernel.org
    Reported-by: Richard Weinberger <richard@nod.at>
    Tested-by: Richard Weinberger <richard@nod.at>
    Signed-off-by: John Stultz <john.stultz@linaro.org>

-- 
Thanks,
//richard
