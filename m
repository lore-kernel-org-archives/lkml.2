Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2DQULg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:11:36 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:57274 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2DQULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:11:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQECASMEUQEFCwsaAgUWCwICCQMCAQIBRQYNAQcBAYgFrB+KGIEvjhOBGASpJYE4Fg
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174927248"
Message-ID: <4F8DCE74.2020906@teksavvy.com>
Date: Tue, 17 Apr 2012 16:11:32 -0400
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
..
> -    rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> +    //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> +    dump_stack();
..

Okay, the call into here is coming from a "hwclock -w -u" line
in the system suspend script.

Since that command isn't touching the hardware Alarm,
then neither should the Linux kernel.  Yet it is touching it.

>      CMOS_WRITE(rtc_control, RTC_CONTROL);
> -    hpet_mask_rtc_irq_bit(mask);
> +    //hpet_mask_rtc_irq_bit(mask);
> 
> -    cmos_checkintr(cmos, rtc_control);
> +    //cmos_checkintr(cmos, rtc_control); 
...

The problem still occurs (lockup on suspend)
with both lines above commented out.

Note that it's not 100% in any case, more like 8/10,
indicating a possible strong race condition somewhere.

I think all that should be done here, is to change the kernel
to NOT enable/disable the Alarm unless told to do so by
an explicit userspace action.  Eg. writing to /sys/../wakealarm
and/or /proc/acpi/alarm.

If userspace leaves the alarm alone, then so should the kernel when possible.
That's the old behaviour before the new alarm_irq_enable() stuff.

Cheers
