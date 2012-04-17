Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2DQMwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:52:16 -0400
Received: from [206.248.143.162] ([206.248.143.162]:28623 "EHLO
	ironport-out.teksavvy.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab2DQMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:52:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQECASMEUQEFCwsYAgIFFgsCAgkDAgECAUUGDQEHAQGIBawfihiBL44TgRgEqSWBOBY
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174884638"
Message-ID: <4F8D6769.7080504@teksavvy.com>
Date: Tue, 17 Apr 2012 08:51:53 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com> <4F8C76EB.20709@linaro.org> <4F8C926D.2040503@linaro.org> <4F8CD5D3.8060006@teksavvy.com> <4F8CFC12.6050700@linaro.org>
In-Reply-To: <4F8CFC12.6050700@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-17 01:13 AM, John Stultz wrote:
> On 04/16/2012 07:30 PM, Mark Lord wrote:
..
>> And.. on some of the systems I'm testing on, the BIOS setup has
>> the RTC Alarm "enabled", which means "under BIOS control",
>> as opposed to "disabled" which means "under software control".
>>
>> It's the "under BIOS control" systems that the above patch breaks.
..
> Thanks for the extra info. Although I'm still a little perplexed why that's causing trouble.
> When "under BIOS control" is the RTC unusable by the kernel? Will any access cause problems? Or just
> the extra disable path?

Not totally clear yet, but I have noticed failures just reading
the RTC alarm setting when it is "under BIOS control",
so it does seem to cause issues.

I've further isolated it down to one specific revision of motherboard here.
The later rev of the same mobo doesn't exhibit the problem (I have both revs).
Interesting, that.  But if this board does it, then there probably are others
out there which could also be affected.

> On a hunch, I wonder if your tripping over the alarmtimer initialization issue that was recently fixed.
> Have you also seen this issue w/ 3.4-rc2+ ?

These boxes aren't ready for 3.4-xx yet.  :)

> I guess I'm curious why you're hitting the rtc_alarm_disable if you're not using the alarm. If you
> use the following diff, can you provide the resulting stack traces?


Yeah, excellent suggestion.  I'm very curious who calls this and when.

> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index eb415bd..4c98ee5 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -786,7 +786,8 @@ static void rtc_alarm_disable(struct rtc_device *rtc)
>      if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>          return;
> 
> -    rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> +    //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> +    dump_stack();
>  }
..

> Then un-comment/re-add the alarm_irq_enable() call above, and try the following, to see if the
> behavior changes? Then re-add each line one by one to see if you can isolate where things go wrong
> in the cmos code?
> 
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 7d5f56e..c500bce 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -318,9 +318,9 @@ static void cmos_irq_disable(struct cmos_rtc *cmos, unsigned char mask)
>      rtc_control = CMOS_READ(RTC_CONTROL);
>      rtc_control&= ~mask;
>      CMOS_WRITE(rtc_control, RTC_CONTROL);
> -    hpet_mask_rtc_irq_bit(mask);
> +    //hpet_mask_rtc_irq_bit(mask);
> 
> -    cmos_checkintr(cmos, rtc_control);
> +    //cmos_checkintr(cmos, rtc_control);
..

Ack.  Will do.  Probably not for 12-24 hours though.

Cheers

