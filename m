Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0F3T6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:58:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42296 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755582Ab0F3T6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:58:39 -0400
Date: Wed, 30 Jun 2010 15:58:36 -0400 (EDT)
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
In-Reply-To: <201006302127.37432.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006301535450.1707-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Rafael J. Wysocki wrote:

> > Since there's no longer any way to cancel a call to pm_wakeup_event()  
> > or close the "no suspend" period early, there is no need to use
> > dynamically-allocated delayed_work structures.  You can make do with a
> > single static timer; always keep it set to expire at the latest time
> > passed to pm_wakeup_event().
> 
> The decremenations of events_in_progress wouldn't be balanced with
> incrementations this way.  Or do you have any clever way of dealing with
> that in mind?

Keep track of the current expiration time in a static variable called
wakeup_timeout, and use 0 to indicate there is no timeout.

In pm_wakeup_event() (everything protected by the spinlock):

	unsigned long new_timeout = jiffies + msecs_to_jiffies(msecs);
	if (new_timeout == 0)
		new_timeout = 1;

	++event_count;
	if (!wakeup_timeout || time_after(new_timeout, wakeup_timeout)) {
		if (!wakeup_timeout)
			++events_in_progress;
		wakeup_timeout = new_timeout;
		mod_timer(&wakeup_timer, wakeup_timeout);
	}

In the timer routine:

	if (wakeup_timeout && time_before_eq(wakeup_timeout, jiffies)) {
		--events_in_progres;
		wakeup_timeout = 0;
	}

Alan Stern

