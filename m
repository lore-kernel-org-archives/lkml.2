Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031618Ab2I1Too (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:44:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63128 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031598Ab2I1Toe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:44:34 -0400
Date: Fri, 28 Sep 2012 12:41:52 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 52/57] power: abx500_chargalg: Use hrtimer
Message-ID: <20120928194152.GA29115@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-53-git-send-email-mathieu.poirier@linaro.org>
 <20120928024747.GK5040@lizard>
 <5065ED8F.7030403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5065ED8F.7030403@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:33:51PM -0600, Mathieu Poirier wrote:
[...]
> >> @@ -413,11 +428,10 @@ static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
> >>  	}
> >>  
> >>  	di->events.safety_timer_expired = false;
> >> -	di->safety_timer.expires = timer_expiration;
> >> -	if (!timer_pending(&di->safety_timer))
> >> -		add_timer(&di->safety_timer);
> >> -	else
> >> -		mod_timer(&di->safety_timer, timer_expiration);
> >> +	hrtimer_set_expires_range(&di->safety_timer,
> >> +		ktime_set(timer_expiration * ONE_HOUR_IN_SECONDS, 0),
> >> +		ktime_set(FIVE_MINUTES_IN_SECONDS, 0));
> >> +	hrtimer_start_expires(&di->safety_timer, HRTIMER_MODE_REL);
> > 
> > OK, now we're chaning from timers to hrtimers, and their behaviour
> > might be different. I guess in this case you should check whether
> > old value 'before' new value, and if so, do nothing.
> 
> Would you mind being more descriptive - I'm affraid that I don't
> understand your suggestion.

I was partly referencing to my answer here
http://lkml.org/lkml/2012/9/27/678

There I was suggesting how to make abx500_chargalg_check_safety_timer()
simpler, but since in this patch you switching code to hrtimers, the logic
have to change too.

So, to put it even simpler, in this patch you don't even need to check for
time values, in abx500_chargalg_start_safety_timer(), you can just write

	if (hrtimer_active(&di->safety_timer))
		return;

	dev_dbg(di->dev, "starting safety timer\n");

	hrtimer_set_expires_range(&di->safety_timer,
		ktime_set(timer_expiration * ONE_HOUR_IN_SECONDS, 0),
		ktime_set(FIVE_MINUTES_IN_SECONDS, 0));
	hrtimer_start_expires(&di->safety_timer, HRTIMER_MODE_REL);

And you don't have to check for hrtimer_active() anywhere else...

[...]
> >> @@ -910,11 +918,11 @@ static void abx500_chargalg_check_safety_timer(struct abx500_chargalg *di)
> >>  	 * and charging will be stopped to protect the battery.
> >>  	 */
> >>  	if (di->batt_data.percent == 100 &&
> >> -		!timer_pending(&di->safety_timer)) {
> >> +		!hrtimer_active(&di->safety_timer)) {
> >>  		abx500_chargalg_start_safety_timer(di);
> >>  		dev_dbg(di->dev, "start safety timer\n");
> >>  	} else if (di->batt_data.percent != 100 &&
> >> -		timer_pending(&di->safety_timer)) {
> >> +		hrtimer_active(&di->safety_timer)) {
> >>  		abx500_chargalg_stop_safety_timer(di);
> >>  		dev_dbg(di->dev, "stop safety timer\n");
> >>  	}

..so with the above suggestion, this code will turn into just

	if (di->batt_data.percent < 100) {
		abx500_chargalg_stop_safety_timer(di);
		return;
	}
	abx500_chargalg_start_safety_timer(di);

Thanks,
Anton.
