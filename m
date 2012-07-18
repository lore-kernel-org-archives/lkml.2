Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2GRXQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 19:16:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45236 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab2GRXQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 19:16:51 -0400
Message-ID: <500743DD.5070600@linaro.org>
Date: Wed, 18 Jul 2012 16:16:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] alarmtimer: add .remove_dev hook to put device
References: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071823-5112-0000-0000-00000A338557
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 09:13 AM, Shawn Guo wrote:
> The following is a test sequence that installs a rtc module, remove it
> and installs it again.
>
> $ insmod rtc-snvs.ko
> snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp as rtc0
> $ hwclock
> Thu Jul  5 08:53:35 2012  0.000000 seconds
> $ rmmod rtc-snvs.ko
> $ insmod rtc-snvs.ko
> snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp as rtc1
> $ hwclock
> hwclock: can't open '/dev/misc/rtc': No such file or directory
> $
>
> The device is registered as rtc0 for the first time insmod, while it
> becomes rtc1 with the later insmod.
>
> It's root caused by alarmtimer which never puts the device even when
> the rtc is removed.  The patch adds a .remove_dev hook to have device
> properly put, so that above insmod/rmmod sequence can the rtc device
> registered in a consistent behavior.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>   kernel/time/alarmtimer.c |   12 ++++++++++++
>   1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index aa27d39..39e8773 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -96,6 +96,17 @@ static int alarmtimer_rtc_add_device(struct device *dev,
>   	return 0;
>   }
>
> +static void alarmtimer_rtc_remove_device(struct device *dev,
> +				struct class_interface *class_intf)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtcdev_lock, flags);
> +	rtcdev = NULL;
> +	put_device(dev);
> +	spin_unlock_irqrestore(&rtcdev_lock, flags);
> +}
> +

Looking at this a little closer, you need to validate that the device 
being removed is the actual rtcdev before setting it to null.

Otherwise if there's two rtc drivers, and the 1st is the current rtcdev, 
you'll clear rtcdev if the second rtc driver is removed.

I'll go ahead and fix this up for you.

thanks
-john

