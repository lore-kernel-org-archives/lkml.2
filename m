Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2GKDpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:45:51 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:4904
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737Ab2GKDpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:45:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z37d4lz98dI1432Izz1202hzz8275dhz2dh87h2a8h668h839h944hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 11 Jul 2012 11:46:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] alarmtimer: add .remove_dev hook to put device
Message-ID: <20120711034613.GA16212@S2101-09.ap.freescale.net>
References: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Is this patch a valid fix or just a noise?

Regards,
Shawn

On Thu, Jul 05, 2012 at 12:13:07AM +0800, Shawn Guo wrote:
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
>  kernel/time/alarmtimer.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index aa27d39..39e8773 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -96,6 +96,17 @@ static int alarmtimer_rtc_add_device(struct device *dev,
>  	return 0;
>  }
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
>  static inline void alarmtimer_rtc_timer_init(void)
>  {
>  	rtc_timer_init(&rtctimer, NULL, NULL);
> @@ -103,6 +114,7 @@ static inline void alarmtimer_rtc_timer_init(void)
>  
>  static struct class_interface alarmtimer_rtc_interface = {
>  	.add_dev = &alarmtimer_rtc_add_device,
> +	.remove_dev = &alarmtimer_rtc_remove_device,
>  };
>  
>  static int alarmtimer_rtc_interface_setup(void)
> -- 
> 1.7.5.4
> 
> 

