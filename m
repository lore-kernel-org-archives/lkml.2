Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2ACUBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:01:34 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41675 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab2ACUBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:01:32 -0500
Message-ID: <1325620837.3037.8.camel@work-vm>
Subject: Re: REGRESSION 3.2-rcX: RTC auto poweron after 5 minutes
From: John Stultz <john.stultz@linaro.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Andreas Friedrich <afrie@gmx.net>, gregkh@suse.de, torvalds@osdl.org,
        Wolfgang Erig <Wolfgang.Erig@ts.fujitsu.com>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 03 Jan 2012 12:00:37 -0800
In-Reply-To: <CAH+eYFBuK+-md-9QPQ8Z4DSNvKbyOEHg0EyRa2-DaVOZFi=hYQ@mail.gmail.com>
References: <20111226145841.GA26578@upset.ux.pdb.fsc.net>
	 <20111227105708.GA29960@upset.ux.pdb.fsc.net>
	 <CAH+eYFBuK+-md-9QPQ8Z4DSNvKbyOEHg0EyRa2-DaVOZFi=hYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010320-1976-0000-0000-000009206462
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-27 at 20:07 +0530, Rabin Vincent wrote:
> On Tue, Dec 27, 2011 at 16:27, Andreas Friedrich <afrie@gmx.net> wrote:
> > On Mo, Dez 26, 2011 at 03:58:41 +0100, Andreas Friedrich wrote:
> > the 5 minutes auto-poweron problem was caused by the new function
> > drivers/rtc/interface.c -> rtc_alarm_disable():
> >   ...
> >   alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
> >                                        ktime_set(300, 0)));
> >   alarm.enabled = 0;
> >   ...
> >
> > In this function the RTC alarm shall be disabled. Why do you set up a
> > 5 minutes interval just before disabling the alarm?
> 
> The 5 minutes is taken from rtc-sysfs.c ("Provide a valid future alarm
> time" etc.).  Although perhaps the "future" part is just to get past the
> check in __rtc_set_alarm(), which we anyway don't use in
> rtc_alarm_disable().
> 
> >
> > I have changed
> >   ktime_set(300, 0)));
> > to
> >   ktime_set(0, 0)));
> > and all worked fine with my notebook.
> >
> > Please check if this could be a common solution of the problem.
> 
> Probably not, because if your hardware really doesn't disable the alarm
> then you could get the same problem if someone say changes the RTC time
> to a few minutes earlier after a call to rtc_alarm_disable().
> 
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
> btw, if you haven't done so yet, could you please confirm that it's not
> something in your userspace which is _asking_ for the alarm to be
> enabled?  You could add a printk() of the 'enabled' argument into
> cmos_alarm_irq_enable() to do this (and one in cmos_set_alarm()
> wouldn't hurt too).


Hey Rabin,
	Sorry to chime in late, just getting back from the holidays. Since it
sounds like the above patch would need more testing and we're way too
late in the -rc cycle, I'm suggesting we revert your original patch
c0afabd3d553c521e003779c127143ffde55a16f and we can try to get this
solved and tested properly for 3.3.

Linus: Could you revert c0afabd3d553c521e003779c127143ffde55a16f ? 

thanks
-john




