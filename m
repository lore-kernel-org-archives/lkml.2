Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2ACWrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:47:03 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45249 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2ACWq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:46:56 -0500
Message-ID: <1325630808.3037.44.camel@work-vm>
Subject: Re: [03/75] rtc: Expire alarms after the time is set.
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Date: Tue, 03 Jan 2012 14:46:48 -0800
In-Reply-To: <20120103223321.257216175@clark.kroah.org>
References: <20120103223321.257216175@clark.kroah.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010322-1780-0000-0000-0000020E6580
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000243; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00101841; UDB=6.00026006; UTC=2012-01-03
 22:46:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 14:32 -0800, Greg KH wrote:
> 3.1-stable review patch.  If anyone has any objections, please let me know.

Again, this one is having problems upstream. Please hold off.

thanks
-john


> ------------------
> 
> From: NeilBrown <neilb@suse.de>
> 
> commit 93b2ec0128c431148b216b8f7337c1a52131ef03 upstream.
> 
> If the alarm time programming in the rtc is ever in the past, it won't fire,
> and any other alarm will be queued after it so they won't fire either.
> 
> So any time that the alarm might be in the past, we need to trigger
> the irq handler to ensure the old alarm is cleared and the timer queue
> is fully in the future.
> 
> This can happen:
>  - when we first initialise the alarm
>  - when we set the time in the rtc.
> 
> so follow both of these by scheduling the timer work function.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> [Also catch set_mmss case -jstultz]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/rtc/interface.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -72,6 +72,8 @@ int rtc_set_time(struct rtc_device *rtc,
>  		err = -EINVAL;
> 
>  	mutex_unlock(&rtc->ops_lock);
> +	/* A timer might have just expired */
> +	schedule_work(&rtc->irqwork);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(rtc_set_time);
> @@ -111,6 +113,8 @@ int rtc_set_mmss(struct rtc_device *rtc,
>  		err = -EINVAL;
> 
>  	mutex_unlock(&rtc->ops_lock);
> +	/* A timer might have just expired */
> +	schedule_work(&rtc->irqwork);
> 
>  	return err;
>  }
> @@ -402,6 +406,8 @@ int rtc_initialize_alarm(struct rtc_devi
>  		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
>  	}
>  	mutex_unlock(&rtc->ops_lock);
> +	/* maybe that was in the past.*/
> +	schedule_work(&rtc->irqwork);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(rtc_initialize_alarm);
> 
> 


