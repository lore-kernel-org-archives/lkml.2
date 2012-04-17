Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab2DQFOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:14:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48750 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2DQFOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:14:02 -0400
Message-ID: <4F8CFC12.6050700@linaro.org>
Date: Mon, 16 Apr 2012 22:13:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com> <4F8C76EB.20709@linaro.org> <4F8C926D.2040503@linaro.org> <4F8CD5D3.8060006@teksavvy.com>
In-Reply-To: <4F8CD5D3.8060006@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041705-4242-0000-0000-0000015D9A05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 07:30 PM, Mark Lord wrote:
>
> Thanks for looking into it, John.
>
> I also spent many more hours digging away at it here today,
> and I now understand (mostly) what is happening and why.
>
> The code above introduces a new access to the RTC that never existed before.
> For the case where the Alarm has never been enabled by software,
> I believe the code above will still try to "disable" it.
> That's the new behaviour we didn't have prior to this patch.
>
> And.. on some of the systems I'm testing on, the BIOS setup has
> the RTC Alarm "enabled", which means "under BIOS control",
> as opposed to "disabled" which means "under software control".
>
> It's the "under BIOS control" systems that the above patch breaks.
>
> So I think the code may just need to be slightly more clever,
> and not disable an Alarm that was never enabled by software in the first place.

Thanks for the extra info. Although I'm still a little perplexed why 
that's causing trouble.
When "under BIOS control" is the RTC unusable by the kernel? Will any 
access cause problems? Or just the extra disable path?

On a hunch, I wonder if your tripping over the alarmtimer initialization 
issue that was recently fixed.
Have you also seen this issue w/ 3.4-rc2+ ?

I still can't trigger anything similar playing with the BIOS options for 
my system. If its not too much trouble, could you try the following two 
changes?

thanks
-john

I guess I'm curious why you're hitting the rtc_alarm_disable if you're 
not using the alarm. If you use the following diff, can you provide the 
resulting stack traces?

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index eb415bd..4c98ee5 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -786,7 +786,8 @@ static void rtc_alarm_disable(struct rtc_device *rtc)
  	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
  		return;

-	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
+	//rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
+	dump_stack();
  }

  /**




Then un-comment/re-add the alarm_irq_enable() call above, and try the 
following, to see if the behavior changes? Then re-add each line one by 
one to see if you can isolate where things go wrong in the cmos code?

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 7d5f56e..c500bce 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -318,9 +318,9 @@ static void cmos_irq_disable(struct cmos_rtc *cmos, unsigned char mask)
  	rtc_control = CMOS_READ(RTC_CONTROL);
  	rtc_control&= ~mask;
  	CMOS_WRITE(rtc_control, RTC_CONTROL);
-	hpet_mask_rtc_irq_bit(mask);
+	//hpet_mask_rtc_irq_bit(mask);

-	cmos_checkintr(cmos, rtc_control);
+	//cmos_checkintr(cmos, rtc_control);
  }

  static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)

