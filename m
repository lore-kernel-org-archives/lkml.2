Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2HEVFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:05:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42738 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab2HEVFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:05:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RTC: Avoid races between RTC alarm wakeup and suspend.
Date: Sun, 5 Aug 2012 23:11:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Fox <pgf@laptop.org>
References: <20120730113547.2c425ea9@notabene.brown> <201207302301.49972.rjw@sisk.pl> <20120731125104.7a07f251@notabene.brown>
In-Reply-To: <20120731125104.7a07f251@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208052311.28823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 31, 2012, NeilBrown wrote:
> On Mon, 30 Jul 2012 23:01:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday, July 30, 2012, NeilBrown wrote:
> > > 
> > > If an RTC alarm fires just as suspend is happening, it is possible for
> > > suspend to complete and the alarm to be missed.
> > > 
> > > To avoid the race, we must register the event with the PM core.
> > > 
> > > As the event is made visible to userspace through a thread which is
> > > only scheduled by the interrupt, we need a pm_stay_awake/pm_relax
> > > pair preventing suspend from the interrupt until the thread completes
> > > its work.
> > > 
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > 
> > > --
> > > This makes the pm_wakeup_event() call in cmos_interrupt unnecessary as it
> > > provides suspend protection for all RTCs that use rtc_update_irq.
> > 
> > Care to remove the call in cmos_interrupt(), then?
> > 
> > > I think the pm_stay_awake//pm_relax is needed - just pm_wakup_event() is 
> > > theoretically not sufficient.
> > > 
> > > This is because there is no guarantee (that I know of) that the workqueue
> > > thread will actually get scheduled before 'suspend' takes over.
> > 
> > I think you are right.
> 
> Thanks.
> Here is the revised patch.
> 
> NeilBrown
> 
> 
> ==========
> Subject: [PATCH] RTC: Avoid races between RTC alarm wakeup and suspend.
> 
> If an RTC alarm fires just as suspend is happening, it is possible for
> suspend to complete and the alarm to be missed.
> 
> To avoid the race, we must register the event with the PM core.
> 
> As the event is made visible to userspace through a thread which is
> only scheduled by the interrupt, we need a pm_stay_awake/pm_relax
> pair preventing suspend from the interrupt until the thread completes
> its work.
> 
> This makes the pm_wakeup_event() call in cmos_interrupt unnecessary as
> it provides suspend protection for all RTCs that use rtc_update_irq.
> 
> Cc: Paul Fox <pgf@laptop.org>
> Signed-off-by: NeilBrown <neilb@suse.de>

Applied to the linux-next branch of the linux-pm.git tree.  I'm going to
push it as a fix for v3.6.

Thanks,
Rafael


> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index eb415bd..9592b93 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -582,6 +582,7 @@ enum hrtimer_restart rtc_pie_update_irq(struct hrtimer *timer)
>  void rtc_update_irq(struct rtc_device *rtc,
>  		unsigned long num, unsigned long events)
>  {
> +	pm_stay_awake(rtc->dev.parent);
>  	schedule_work(&rtc->irqwork);
>  }
>  EXPORT_SYMBOL_GPL(rtc_update_irq);
> @@ -844,6 +845,7 @@ void rtc_timer_do_work(struct work_struct *work)
>  
>  	mutex_lock(&rtc->ops_lock);
>  again:
> +	pm_relax(rtc->dev.parent);
>  	__rtc_read_time(rtc, &tm);
>  	now = rtc_tm_to_ktime(tm);
>  	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 132333d..4267789 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -568,7 +568,6 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
>  		hpet_mask_rtc_irq_bit(RTC_AIE);
>  
>  		CMOS_READ(RTC_INTR_FLAGS);
> -		pm_wakeup_event(cmos_rtc.dev, 0);
>  	}
>  	spin_unlock(&rtc_lock);
>  
> 

