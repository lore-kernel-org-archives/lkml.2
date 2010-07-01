Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0GAN6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:58:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56870 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755912Ab0GAN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:58:16 -0400
Date: Thu, 1 Jul 2010 09:58:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <201007010152.03869.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1007010953060.1596-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Rafael J. Wysocki wrote:

> I invented a slightly different version in the meantime, which is appended
> as a patch on top of the original one (I don't want to modify the original
> patch, since it's been reviewed already by several people and went to my
> linux-next branch).

>  /**
> - * pm_wakeup_work_fn - Deferred closing of a wakeup event.
> + * pm_wakeup_timer_fn - Deferred closing of a wakeup event.
>   *
>   * Execute pm_relax() for a wakeup event detected in the past and free the
>   * work item object used for queuing up the work.
>   */
> -static void pm_wakeup_work_fn(struct work_struct *work)
> +static void pm_wakeup_timer_fn(unsigned long data)
>  {
> -	struct delayed_work *dwork = to_delayed_work(work);
> +	unsigned long flags;
>  
> -	pm_relax();
> -	kfree(dwork);
> +	spin_lock_irqsave(&events_lock, flags);
> +	if (events_timer_expires && time_after(jiffies, events_timer_expires)) {

Should be time_after_eq.

> +		events_in_progress -= delayed_count;
> +		event_count += delayed_count;
> +		delayed_count = 0;
> +		events_timer_expires = 0;
> +	}
> +	spin_unlock_irqrestore(&events_lock, flags);
>  }
>  
>  /**
> @@ -132,19 +145,31 @@ static void pm_wakeup_work_fn(struct wor
>  void pm_wakeup_event(struct device *dev, unsigned int msec)
>  {
>  	unsigned long flags;
> -	struct delayed_work *dwork;
> -
> -	dwork = msec ? kzalloc(sizeof(*dwork), GFP_ATOMIC) : NULL;
>  
>  	spin_lock_irqsave(&events_lock, flags);
>  	if (dev)
>  		dev->power.wakeup_count++;
>  
> -	if (dwork) {
> -		INIT_DELAYED_WORK(dwork, pm_wakeup_work_fn);
> -		schedule_delayed_work(dwork, msecs_to_jiffies(msec));
> +	if (msec) {
> +		ktime_t kt;
> +		struct timespec ts;
> +		unsigned long expires;
> +
> +		kt = ktime_get();
> +		kt = ktime_add_ns(kt, msec * NSEC_PER_MSEC);
> +		ts = ktime_to_timespec(kt);
> +		expires = timespec_to_jiffies(&ts);

Is this somehow better than jiffies + msecs_to_jiffies(msec)?

> +		if (!expires)
> +			expires = 1;
> +
> +		if (!events_timer_expires
> +		    || time_after(expires, events_timer_expires)) {
> +			mod_timer(&events_timer, expires);
> +			events_timer_expires = expires;
> +		}
>  
>  		events_in_progress++;
> +		delayed_count++;
>  	} else {
>  		event_count++;
>  	}

Alan Stern

