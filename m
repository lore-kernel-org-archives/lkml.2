Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0FXPoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:44:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47626 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754241Ab0FXPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:44:53 -0400
Date: Thu, 24 Jun 2010 11:44:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006241513.06116.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006241111110.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Rafael J. Wysocki wrote:

> > > And what happens if the device gets a second wakeup event before the timer
> > > for the first one expires?
> > 
> > Good question.  I don't have an answer to it at the moment, but it seems to
> > arise from using a single timer for all events.
> > 
> > It looks like it's simpler to make pm_wakeup_event() allocate a timer for each
> > event and make the timer function remove it.  That would cause suspend to
> > be blocked until the timer expires without a way to cancel it earlier, though.
> 
> So, I decided to try this after all.
> 
> Below is a new version of the patch.  It introduces pm_stay_awake(dev) and
> pm_relax() that play the roles of the "old" pm_wakeup_begin() and
> pm_wakeup_end().
> 
> pm_wakeup_event() now takes an extra timeout argument and uses it for
> deferred execution of pm_relax().  So, one can either use the
> pm_stay_awake(dev) / pm_relax() pair, or use pm_wakeup_event(dev, timeout)
> if the ending is under someone else's control.
> 
> In addition to that, pm_get_wakeup_count() blocks until events_in_progress is
> zero.
> 
> Please tell me what you think.

This is slightly different from the wakelock design.  Each call to
pm_stay_awake() must be paired with a call to pm_relax(), allowing one
device to have multiple concurrent critical sections, whereas calls to
pm_wakeup_event() must not be paired with anything.  With wakelocks,
you couldn't have multiple pending events for the same device.  I'm not
sure which model is better in practice.  No doubt the Android people 
will prefer their way.

This requires you to define an explicit PCI_WAKEUP_COOLDOWN delay.  I 
think that's okay; I had to do something similar with USB and SCSI.  
(And I still think it would be a good idea to prevent workqueue threads 
from freezing until their queues are empty.)

Instead of allocating the work structures dynamically, would you be 
better off using a memory pool?

Alan Stern

