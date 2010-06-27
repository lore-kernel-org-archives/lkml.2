Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0F1ABE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 20:01:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0F1ABA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 20:01:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Mon, 28 Jun 2010 01:59:10 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Pine.LNX.4.44L0.1006271142190.3772-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006271142190.3772-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006280159.10885.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 27, 2010, Alan Stern wrote:
> On Sat, 26 Jun 2010, Rafael J. Wysocki wrote:
> 
> > +void pm_relax(void)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&events_lock, flags);
> > +	if (events_in_progress) {
> > +		event_count++;
> > +		if (!--events_in_progress)
> > +			wake_up_all(&events_wait_queue);
> > +	}
> > +	spin_unlock_irqrestore(&events_lock, flags);
> > +}
> 
> > +bool pm_get_wakeup_count(unsigned long *count)
> > +{
> > +	bool ret;
> > +
> > +	spin_lock_irq(&events_lock);
> > +	if (capable(CAP_SYS_ADMIN))
> > +		events_check_enabled = false;
> > +
> > +	if (events_in_progress) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		do {
> > +			prepare_to_wait(&events_wait_queue, &wait,
> > +					TASK_INTERRUPTIBLE);
> > +			if (!events_in_progress)
> > +				break;
> > +			spin_unlock_irq(&events_lock);
> > +
> > +			schedule();
> > +
> > +			spin_lock_irq(&events_lock);
> > +		} while (!signal_pending(current));
> > +		finish_wait(&events_wait_queue, &wait);
> > +	}
> > +	*count = event_count;
> > +	ret = !events_in_progress;
> > +	spin_unlock_irq(&events_lock);
> > +	return ret;
> > +}
> 
> Here's a thought.  Presumably pm_relax() will end up getting called a 
> lot more often than pm_get_wakeup_count().  Instead of using a wait 
> queue, you could make pm_get_wakeup_count() poll at 100-ms intervals.  
> The total overhead would be smaller.

For that I'd need a separate kernel thread or a work item that would reschedule
itself periodically, because pm_get_wakeup_count() is only called via
/sys/power/wakeup_count.  It would complicate things quite a bit which I'm not
sure is worth it at this point.

> Here's another thought.  If event_count and events_in_progress were 
> atomic_t then the new spinlock wouldn't be needed at all.  (But you 
> would need an appropriate pair of memory barriers, to guarantee that 
> when a writer decrements events_in_progress to 0 and increments 
> event_count, a reader won't see events_in_progress == 0 without also 
> seeing the incremented event_count.)  Overall, this may not be a
> significant improvement.

No, I don't think it would be significant.  Still, we can go back to this
if the spinlock turns out to be a problem in future.

Rafael
