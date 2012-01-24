Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2AXAb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:31:29 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:51226 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2AXAb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:31:27 -0500
Message-ID: <1327365073.11738.2.camel@work-vm>
Subject: Re: REGRESSION 3.2-rcX: RTC auto poweron after 5 minutes
From: John Stultz <john.stultz@linaro.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Andreas Friedrich <afrie@gmx.net>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Date: Mon, 23 Jan 2012 16:31:13 -0800
In-Reply-To: <CAH+eYFBuK+-md-9QPQ8Z4DSNvKbyOEHg0EyRa2-DaVOZFi=hYQ@mail.gmail.com>
References: <20111226145841.GA26578@upset.ux.pdb.fsc.net>
	 <20111227105708.GA29960@upset.ux.pdb.fsc.net>
	 <CAH+eYFBuK+-md-9QPQ8Z4DSNvKbyOEHg0EyRa2-DaVOZFi=hYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012400-7408-0000-0000-0000021CE136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-27 at 20:07 +0530, Rabin Vincent wrote:
> Perhaps we can avoid your five-minute problem by just attempting
> to disable the irq without setting a new alarm time (not yet tested):
> 
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index 3bcc7cf..54a3b5e 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -778,16 +778,10 @@ static int rtc_timer_enqueue(struct rtc_device
> *rtc, struct rtc_timer *timer)
> 
>  static void rtc_alarm_disable(struct rtc_device *rtc)
>  {
> -	struct rtc_wkalrm alarm;
> -	struct rtc_time tm;
> -
> -	__rtc_read_time(rtc, &tm);
> -
> -	alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
> -				     ktime_set(300, 0)));
> -	alarm.enabled = 0;
> +	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
> +		return;
> 
> -	___rtc_set_alarm(rtc, &alarm);
> +	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>  }
> 

Hey Rabin,
	Just wanted to close out on this. I know this change worked for
Andreas, but did it also resolve the original issue for you? I'm trying
to get this ready to be queued.

thanks
-john


