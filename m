Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2DPP5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:57:19 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:38488 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab2DPP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:57:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyMERgYGEAsVAwICBSECAg8CRgYNAQUCAQGIFawPihiBL4l9hBaBGASpJYE4CA4
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174606049"
Message-ID: <4F8C415C.80806@teksavvy.com>
Date: Mon, 16 Apr 2012 11:57:16 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com>
In-Reply-To: <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-16 11:49 AM, richard -rw- weinberger wrote:
> On Mon, Apr 16, 2012 at 5:42 PM, Mark Lord <kernel@teksavvy.com> wrote:
>> On 12-04-16 10:23 AM, richard -rw- weinberger wrote:
>>> On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord <kernel@teksavvy.com> wrote:
>>>> On 12-04-16 12:36 AM, Mark Lord wrote:
>>>>> Something recent has killed suspend-to-ram on a number of machines here.
>>>>> The symptom is that they suspend, but immediately wake up and panic,
>>>>> with just a black screen so no visible messages to go by.
>>>>>
>>>>> The patch below works around the issue -- making things work as they used to work.
>>>>>
>>>>> +++ linux/drivers/rtc/interface.c     2012-04-16 00:09:14.105387382 -0400
>>>>> @@ -773,7 +773,7 @@
>>>>>       if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>>>>>               return;
>>>>>
>>>>> -     rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>>>>> +     //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
>>>>>  }
>>
>>
>> How about the line above -- that's the commit that breaks things here.
> 
> Download Linus' GIT tree and use git blame. :-)

Too steep a learning curve for a casual user.
But google works:

http://www.mail-archive.com/stable@vger.kernel.org/msg04391.html



> [ 055/175] rtc: Disable the alarm in the hardware (v2)
> 
> Greg KH
> Fri, 30 Mar 2012 14:57:53 -0700
> 
> 3.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> commit 41c7f7424259ff11009449f87c95656f69f9b186 upstream.
> 
> Currently, the RTC code does not disable the alarm in the hardware.
> 
> This means that after a sequence such as the one below (the files are in the
> RTC sysfs), the box will boot up after 2 minutes even though we've
> asked for the alarm to be turned off.
> 
>         # echo $((`cat since_epoch`)+120) > wakealarm
>         # echo 0 > wakealarm
>         # poweroff
> 
> Fix this by disabling the alarm when there are no timers to run.
> 
> The original version of this patch was reverted. This version
> disables the irq directly instead of setting a disabled timer
> in the future.
> 
> Cc: John Stultz <john.stu...@linaro.org>
> Signed-off-by: Rabin Vincent <rabin.vinc...@stericsson.com>
> [Merged in the second revision from Rabin]
> Signed-off-by: John Stultz <john.stu...@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gre...@linuxfoundation.org>
> 
> ---
>  drivers/rtc/interface.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -763,6 +763,14 @@ static int rtc_timer_enqueue(struct rtc_
>         return 0;
>  }
>  
> +static void rtc_alarm_disable(struct rtc_device *rtc)
> +{
> +       if (!rtc->ops || !rtc->ops->alarm_irq_enable)
> +               return;
> +
> +       rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> +}
> +
>  /**
>   * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
>   * @rtc rtc device
> @@ -784,8 +792,10 @@ static void rtc_timer_remove(struct rtc_
>                 struct rtc_wkalrm alarm;
>                 int err;
>                 next = timerqueue_getnext(&rtc->timerqueue);
> -               if (!next)
> +               if (!next) {
> +                       rtc_alarm_disable(rtc);
>                         return;
> +               }
>                 alarm.time = rtc_ktime_to_tm(next->expires);
>                 alarm.enabled = 1;
>                 err = __rtc_set_alarm(rtc, &alarm);
> @@ -847,7 +857,8 @@ again:
>                 err = __rtc_set_alarm(rtc, &alarm);
>                 if (err == -ETIME)
>                         goto again;
> -       }
> +       } else
> +               rtc_alarm_disable(rtc);
>  
>         mutex_unlock(&rtc->ops_lock);
>  }
> 


