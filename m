Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0F1OQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:16:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55688 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752772Ab0F1OQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:16:54 -0400
Date: Mon, 28 Jun 2010 10:16:53 -0400 (EDT)
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
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being
 lost
In-Reply-To: <201006280159.10885.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006281006360.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:

> > > +bool pm_get_wakeup_count(unsigned long *count)
> > > +{
> > > +	bool ret;
> > > +
> > > +	spin_lock_irq(&events_lock);
> > > +	if (capable(CAP_SYS_ADMIN))
> > > +		events_check_enabled = false;
> > > +
> > > +	if (events_in_progress) {
> > > +		DEFINE_WAIT(wait);
> > > +
> > > +		do {
> > > +			prepare_to_wait(&events_wait_queue, &wait,
> > > +					TASK_INTERRUPTIBLE);
> > > +			if (!events_in_progress)
> > > +				break;
> > > +			spin_unlock_irq(&events_lock);
> > > +
> > > +			schedule();
> > > +
> > > +			spin_lock_irq(&events_lock);
> > > +		} while (!signal_pending(current));
> > > +		finish_wait(&events_wait_queue, &wait);
> > > +	}
> > > +	*count = event_count;
> > > +	ret = !events_in_progress;
> > > +	spin_unlock_irq(&events_lock);
> > > +	return ret;
> > > +}
> > 
> > Here's a thought.  Presumably pm_relax() will end up getting called a 
> > lot more often than pm_get_wakeup_count().  Instead of using a wait 
> > queue, you could make pm_get_wakeup_count() poll at 100-ms intervals.  
> > The total overhead would be smaller.
> 
> For that I'd need a separate kernel thread or a work item that would reschedule
> itself periodically, because pm_get_wakeup_count() is only called via
> /sys/power/wakeup_count.  It would complicate things quite a bit which I'm not
> sure is worth it at this point.

What?  All I'm saying is that the do-while loop above should be
replaced by a loop that sleeps for 100 ms instead of waiting on a
wait_queue.  That is:

	while (events_in_progress) {
		if (signal_pending(current))
			break;
		spin_unlock_irq(&events_lock);

		schedule_timeout_interruptible(msecs_to_jiffies(100));

		spin_lock_irq(&events_lock);
	}

And of course, get rid of events_wait_queue.

Alan Stern

