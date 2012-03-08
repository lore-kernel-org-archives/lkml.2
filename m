Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2CHSyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:54:01 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab2CHSx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:53:58 -0500
Message-ID: <4F59003F.4050709@nod.at>
Date: Thu, 08 Mar 2012 19:53:51 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RTC regression
References: <4F4E9B71.2010407@nod.at> <1331076961.2191.165.camel@work-vm>
In-Reply-To: <1331076961.2191.165.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.03.2012 00:36, John Stultz wrote:
> On Wed, 2012-02-29 at 22:41 +0100, Richard Weinberger wrote:
>> Hi!
>>
>> hwclock calls the RTC_UIE_ON ioctl to wait for a timer tick.
>> If RTC_UIE_ON was successful it opens /dev/rtcX and waits up to 5 seconds using select()
>> for a tick.
>> Some RTC drivers have no support for RTC_UIE_ON and ioctl just returns -EINVAL.
>> Drivers indicated this by setting rtc_class_ops->update_irq_enable to NULL.
>> In this case hwclock waits in a busy loop for the next timer tick.
>>
>> These two commits changed this behavior:
>> 6610e08 (RTC: Rework RTC code to use timerqueue for events)
>> 51ba60c (RTC: Cleanup rtc_class_ops->update_irq_enable())
>>
>> rtc_class_ops->update_irq_enable was removed and rtc_update_irq_enable()
>> is now using rtc_class_ops->set_alarm instead of rtc_class_ops->update_irq_enable.
>>
>> Some RTC devices (like mpc515x) don't support intervals smaller than one
>> minute.
>> rtc-mpc5121.c deals with this by rounding up to one minute.
>> But now after commit 6610e08 RTC_UIE_ON will no longer return -EINVAL and
>> the next tick comes somewhen within the next 60 seconds, because the driver rounded up...
>> hwclock's select() is not happy about this and timeouts in most cases.
>
> Thanks for diagnosing and pointing out this issue! I hadn't been aware
> of such hardware.
>
> Would something like the following be a better generic interface?
> Basically allow the RTC drivers to flag that UIE is unsupported (much as
> setting the update_irq_enable to null did prior).
>
> Let me know if this works for you, and I'll look to see what other
> drivers might be affected here.
>
> thanks
> -john
>
> Add generic infrastructure to handle rtc devices that don't support UIE
> mode.
>
> Signed-off-by: John Stultz<john.stultz@linaro.org>

Tested-by: Richard Weinberger <richard@nod.at>

> diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
> index 9d3cacc..be6d4f4 100644
> --- a/drivers/rtc/rtc-mpc5121.c
> +++ b/drivers/rtc/rtc-mpc5121.c
> @@ -360,6 +360,8 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
>   						&mpc5200_rtc_ops, THIS_MODULE);
>   	}
>
> +	rtc->rtc.uie_unsupported = 1;
> +

Please replace this line by:
rtc->rtc->uie_unsupported = 1;

Thanks,
//richard
