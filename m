Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0F0PuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:50:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36796 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755464Ab0F0PuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:50:07 -0400
Date: Sun, 27 Jun 2010 11:50:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being
 lost
In-Reply-To: <201006261514.13491.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006271142190.3772-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010, Rafael J. Wysocki wrote:

> +void pm_relax(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&events_lock, flags);
> +	if (events_in_progress) {
> +		event_count++;
> +		if (!--events_in_progress)
> +			wake_up_all(&events_wait_queue);
> +	}
> +	spin_unlock_irqrestore(&events_lock, flags);
> +}

> +bool pm_get_wakeup_count(unsigned long *count)
> +{
> +	bool ret;
> +
> +	spin_lock_irq(&events_lock);
> +	if (capable(CAP_SYS_ADMIN))
> +		events_check_enabled = false;
> +
> +	if (events_in_progress) {
> +		DEFINE_WAIT(wait);
> +
> +		do {
> +			prepare_to_wait(&events_wait_queue, &wait,
> +					TASK_INTERRUPTIBLE);
> +			if (!events_in_progress)
> +				break;
> +			spin_unlock_irq(&events_lock);
> +
> +			schedule();
> +
> +			spin_lock_irq(&events_lock);
> +		} while (!signal_pending(current));
> +		finish_wait(&events_wait_queue, &wait);
> +	}
> +	*count = event_count;
> +	ret = !events_in_progress;
> +	spin_unlock_irq(&events_lock);
> +	return ret;
> +}

Here's a thought.  Presumably pm_relax() will end up getting called a 
lot more often than pm_get_wakeup_count().  Instead of using a wait 
queue, you could make pm_get_wakeup_count() poll at 100-ms intervals.  
The total overhead would be smaller.

Here's another thought.  If event_count and events_in_progress were 
atomic_t then the new spinlock wouldn't be needed at all.  (But you 
would need an appropriate pair of memory barriers, to guarantee that 
when a writer decrements events_in_progress to 0 and increments 
event_count, a reader won't see events_in_progress == 0 without also 
seeing the incremented event_count.)  Overall, this may not be a
significant improvement.

Alan Stern

