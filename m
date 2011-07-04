Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1GDI4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:56:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab1GDI4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:56:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 1/3] PM: Introduce DEVFREQ: generic DVFS framework with device-specific OPPs
Date: Mon, 4 Jul 2011 10:57:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Chanwoo Choi <cw00.choi@samsung.com>
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com> <201107022356.24952.rjw@sisk.pl> <CAJ0PZbSBCK96uw5x_o6ZsMtvFo4U5Hexe10JoaJfPQisLbAshg@mail.gmail.com>
In-Reply-To: <CAJ0PZbSBCK96uw5x_o6ZsMtvFo4U5Hexe10JoaJfPQisLbAshg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041057.43744.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 04, 2011, MyungJoo Ham wrote:
> 2011/7/3 Rafael J. Wysocki <rjw@sisk.pl>:
> > Hi,
> >
> > I'm not sure if spelling DEVFREQ in the kerneldoc comments with capitals is
> > a good idea, it looks kind of odd.  I'm not sure what would be look better,
> > though.
> 
> Umm.. what about "devfreq" using all non-capitals? It looks fine to me as well.

Works for me.

> >
> > On Friday, May 27, 2011, MyungJoo Ham wrote:
> >
> > ...
> >> +/**
> >> + * devfreq_monitor() - Regularly run devfreq_do() and support device DEVFREQ tickle.
> >
> > I'd say "periodically" istead of "regularly".
> 
> Yes, that is the proper term. Thanks.
> 
> >
> >> + * @work: the work struct used to run devfreq_monitor periodically.
> >
> > Also please say something more about the "tickle" thinkg here.
> 
> Sure.
> 
> >
> >> + */
> >> +static void devfreq_monitor(struct work_struct *work)
> >> +{
> >> +     struct devfreq *devfreq;
> >> +     int error;
> >> +     bool continue_polling = false;
> >> +     struct devfreq *to_remove = NULL;
> >> +
> >> +     mutex_lock(&devfreq_list_lock);
> >> +
> >> +     list_for_each_entry(devfreq, &devfreq_list, node) {
> >> +             /* Remove the devfreq entry that failed */
> >> +             if (to_remove) {
> >> +                     list_del(&to_remove->node);
> >> +                     kfree(to_remove);
> >> +                     to_remove = NULL;
> >> +             }
> >> +
> >> +             /*
> >> +              * If the device is tickled and the tickle duration is left,
> >> +              * do not change the frequency for a while
> >> +              */
> >> +             if (devfreq->tickle) {
> >> +                     continue_polling = true;
> >> +                     devfreq->tickle--;
> >> +
> >> +                     /*
> >> +                      * If the tickle is ending and the device is not going
> >> +                      * to poll, force the device to poll next time so that
> >> +                      * it can return to the original frequency afterwards.
> >> +                      * However, non-polling device will have 0 polling_ms,
> >> +                      * it will not poll again later.
> >> +                      */
> >> +                     if (devfreq->tickle == 0 && devfreq->next_polling == 0)
> >> +                             devfreq->next_polling = 1;
> >> +
> >> +                     continue;
> >> +             }
> >> +
> >> +             /* This device does not require polling */
> >> +             if (devfreq->next_polling == 0)
> >> +                     continue;
> >> +
> >> +             continue_polling = true;
> >> +
> >> +             if (devfreq->next_polling == 1) {
> >> +                     /* This device is polling this time */
> >
> > I'd remove this comment, it's confusing IMO.  Besides, it may be better
> > to structure the code like this:
> >
> > if (devfreq->next_polling-- == 1) {
> > }
> >
> > and then you wouldn't need the "else" at all.
> 
> Ok, I'll try that style.
> 
> >
> >> +                     error = devfreq_do(devfreq);
> >> +                     if (error && error != -EAGAIN) {
> >> +                             /*
> >> +                              * Remove a devfreq with error. However,
> >> +                              * We cannot remove it right here because the
> >
> > Comma after "here", please.
> 
> "We" should be "we" here, but no comma there though:
> http://owl.english.purdue.edu/owl/resource/607/02/

OK, whatever.

> However, "However, because the ..... above, we cannot remove it right
> here" is correct.

Yes, it is.

> >
> >> +                              * devfreq pointer is going to be used by
> >> +                              * list_for_each_entry above. Thus, it is
> >> +                              * removed afterwards.
> >
> > Why don't you use list_for_each_entry_safe(), then?
> 
> Ah.. that's a good idea. Thanks! Now, I can reorganize this one.
> 
> >
> >> +                              */
> >> +                             to_remove = devfreq->dev;
> >> +                             dev_err(devfreq->dev, "devfreq_do error(%d). "
> >> +                                     "DEVFREQ is removed from the device\n",
> >> +                                     error);
> >> +                             continue;
> >> +                     }
> >> +                     devfreq->next_polling = DIV_ROUND_UP(
> >> +                                             devfreq->profile->polling_ms,
> >> +                                             DEVFREQ_INTERVAL);
> >> +             } else {
> >> +                     /* The device will poll later when next_polling = 1 */
> >> +                     devfreq->next_polling--;
> >> +             }
> >> +     }
> >> +
> >> +     if (to_remove) {
> >> +             list_del(&to_remove->node);
> >> +             kfree(to_remove);
> >> +             to_remove = NULL;
> >> +     }
> >> +
> >> +     if (continue_polling) {
> >> +             polling = true;
> >> +             queue_delayed_work(devfreq_wq, &devfreq_work,
> >> +                                msecs_to_jiffies(DEVFREQ_INTERVAL));
> >> +     } else {
> >> +             polling = false;
> >> +     }
> >
> > OK, so why exactly continue_polling is needed?  It seems you might siply use
> > "polling" instead of it above.
> 
> The purpose of continue_polling seems to disappear in the middle of
> development. I'll remove it.
> 
> >
> >> +
> >> +     mutex_unlock(&devfreq_list_lock);
> >> +}
> > ...
> >> +/**
> >> + * devfreq_update() - Notify that the device OPP has been changed.
> >> + * @dev:     the device whose OPP has been changed.
> >> + * @may_not_exist:   do not print error message even if the device
> >> + *                   does not have devfreq entry.
> >
> > This argument isn't used any more.
> 
> Ah.. yes. sure.
> 
> >
> >> + */
> >> +int devfreq_update(struct device *dev)
> >> +{
> >> +     struct devfreq *devfreq;
> >> +     int err = 0;
> >> +
> >> +     mutex_lock(&devfreq_list_lock);
> >> +
> >> +     devfreq = find_device_devfreq(dev);
> >> +     if (IS_ERR(devfreq)) {
> >> +             err = PTR_ERR(devfreq);
> >> +             goto out;
> >> +     }
> >> +
> >> +     if (devfreq->tickle) {
> >> +             /* If the max freq available is changed, re-tickle */
> >
> > It would be good to explain what "re-tickle" means.
> 
> Of course. I'll explain that.
> 
> >
> >> +             unsigned long freq = devfreq->profile->max_freq;
> >> +             struct opp *opp = opp_find_freq_floor(devfreq->dev, &freq);
> >> +
> >> +             if (IS_ERR(opp)) {
> >> +                     err = PTR_ERR(opp);
> >> +                     goto out;
> >> +             }
> >> +
> >> +             /* Max freq available is not changed */
> >> +             if (devfreq->previous_freq == freq)
> >> +                     goto out;
> >> +
> >> +             err = devfreq->profile->target(devfreq->dev, opp);
> >> +             if (!err)
> >> +                     devfreq->previous_freq = freq;
> >
> > Why don't we run devfreq_do() in this case?
> 
> When the list of available frequencies is updated and the device is to
> be kept at its maximum frequency, we do not need to reevaluate the
> device's activities to setup the new frequency. In such cases, we only
> need to keep it at its maximum freuqency. If the maximum frequency is
> not changed, we don't need anything to do (when "tickling" is
> completed, devfreq_do() will reevaluate automatically); otherwise,
> tickling again at the new frequency is needed (re-tickle).

OK

> >> +     } else {
> >> +             /* Reevaluate the proper frequency */
> >> +             err = devfreq_do(devfreq);
> >> +     }
> >> +
> >> +out:
> >> +     mutex_unlock(&devfreq_list_lock);
> >> +     return err;
> >> +}
> >> +
> >
> > Add a kerneldoc comment here, please.
> 
> Yes. I'll add one. (and for any other functions missing kerneldoc comments)

Well, if the function is a static one-liner, you can skip the kerneldoc IMHO
However, that one below is not really a one-liner.. :-)

> >> +static int _devfreq_tickle_device(struct devfreq *df, unsigned long delay)
> >> +{
> >> +     int err = 0;
> >> +     unsigned long freq;
> >> +     struct opp *opp;
> >> +
> >> +     freq = df->profile->max_freq;
> >> +     opp = opp_find_freq_floor(df->dev, &freq);
> >> +     if (IS_ERR(opp))
> >> +             return PTR_ERR(opp);
> >> +
> >> +     if (df->previous_freq != freq) {
> >> +             err = df->profile->target(df->dev, opp);
> >> +             if (!err)
> >> +                     df->previous_freq = freq;
> >> +     }
> >> +     if (err) {
> >> +             dev_err(df->dev, "%s: Cannot set frequency.\n", __func__);
> >> +     } else {
> >> +             df->tickle = delay;
> >> +             df->num_tickle++;
> >> +     }
> >> +
> >> +     if (devfreq_wq && !polling) {
> >> +             polling = true;
> >> +             queue_delayed_work(devfreq_wq, &devfreq_work,
> >> +                             msecs_to_jiffies(DEVFREQ_INTERVAL));
> >> +     }
> >> +
> >> +     return err;
> >> +}
> >
> > Thanks,
> > Rafael
> >
> 
> Thank you so much for the comments!

You're welcome.

Thanks,
Rafael
