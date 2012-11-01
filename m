Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483Ab2KAWzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:55:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:35618 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291Ab2KAWzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:55:37 -0400
Date: Thu, 1 Nov 2012 23:55:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
cc: john.stultz@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for all
 posix clock interface
In-Reply-To: <1351700583.15558.1573.camel@cliu38-desktop-build>
Message-ID: <alpine.LFD.2.02.1211012343120.2756@ionos>
References: <1351700455.15558.1571.camel@cliu38-desktop-build> <1351700583.15558.1573.camel@cliu38-desktop-build>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Chuansheng Liu wrote:
> 
> Some posix clock interface directly use the variable rtcdev,
> cleanup it here by alarmtimer_get_rtcdev().
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  kernel/time/alarmtimer.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index 4fc17cb..5490fa8 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -86,11 +86,10 @@ static int alarmtimer_rtc_add_device(struct device *dev,
>  		return -1;
>  
>  	mutex_lock(&rtcdev_mutex);
> -	if (!rtcdev) {
> -		rtcdev = rtc;
> -		/* hold a reference so it doesn't go away */
> -		get_device(dev);
> -	}
> +	rtcdev = rtc;
> +	/* hold a reference so it doesn't go away */
> +	get_device(dev);
> +

Brilliant. 

rtcdev = NULL

CPU0				CPU 1

alarmtimer_rtc_add_device(A)
	if (rtcdev)		alarmtimer_rtc_add_device(B)
	     return -EBUSY;		if (rtcdev)
	mutex_lock();				return -EBUSY;
	rtcdev = A;			mutex_lock();	
	mutex_unlock;

bla = alarmtimer_rtc_get_device()

So bla = A
      				  	mutex_lock() returns
      				  	rtcdev = B;
					mutex_unlock();

The next call to alarmtimer_rtc_get_device() will return B. Not what
you want. Maybe you want that, but then your patch is missing an
explanation why you want that and why this would be a desired
behaviour.

Thanks,

	tglx
