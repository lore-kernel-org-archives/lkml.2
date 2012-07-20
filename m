Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2GTBAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:00:22 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50754 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GTBAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:00:21 -0400
Date: Thu, 19 Jul 2012 18:00:19 -0700
From: Todd Poynor <toddpoynor@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, arve@android.com
Subject: Re: [PATCH] PM / Sleep: Print name of wakeup source that aborts
 suspend
Message-ID: <20120720010019.GA15701@google.com>
References: <1342637519-22355-1-git-send-email-toddpoynor@google.com>
 <201207182147.34750.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207182147.34750.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 09:47:34PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 18, 2012, Todd Poynor wrote:
...
> > +{
> > +	struct wakeup_source *ws;
> > +	int active = 0;
> > +	struct wakeup_source *last_activity_ws = NULL;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(ws, &wakeup_sources, entry) {
> > +		if (ws->active) {
> > +			pr_info("active wakeup source: %s\n", ws->name);
> > +			active = 1;
> 
> Can we do a break here?  Or do we want to get all of them?

I haven't seen more than 3 activated during suspend entry at a time, but
could just list one.  I haven't made that change yet but will if it's
preferred.

> 
> > +		} else if (!active &&
> > +			   (!last_activity_ws ||
> > +			    ws->last_time.tv64 >
> > +			    last_activity_ws->last_time.tv64)) {
> 
> ktime_to_ns() anyone?

Sure, I avoided it because some configs do math on each of these, but
perhaps most implementations implement it as a NOP.

> 
> > +			last_activity_ws = ws;
> > +		}
> > +	}
> > +
> > +	if (!active && last_activity_ws)
> > +		pr_info("last active wakeup source: %s\n",
> > +			last_activity_ws->name);
> > +	rcu_read_unlock();
> > +}
> > +
> >  /**
> >   * pm_wakeup_pending - Check if power transition in progress should be aborted.
> >   *
> > @@ -671,6 +696,10 @@ bool pm_wakeup_pending(void)
> >  		events_check_enabled = !ret;
> >  	}
> >  	spin_unlock_irqrestore(&events_lock, flags);
> > +
> > +	if (ret)
> > +		print_active_wakeup_sources();
> > +
> >  	return ret;
> >  }
> 
> There is no way this or equivalent can go into v3.6.  It may go into v3.7,
> but there's a plenty of time for that.

Sounds fine, thanks.

> 
> Thanks,
> Rafael

Todd

