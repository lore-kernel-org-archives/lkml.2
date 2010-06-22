Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0FVUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:34:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58514 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752478Ab0FVUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:34:53 -0400
Date: Tue, 22 Jun 2010 16:34:49 -0400 (EDT)
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
Subject: Re: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006222159.28081.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006221623130.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:

> Anyway, below's an update that addresses this particular case.
> 
> It adds two more functions, pm_wakeup_begin() and pm_wakeup_end()
> that play similar roles to suspend_block() and suspend_unblock(), but they
> don't operate on suspend blocker objects.  Instead, the first of them increases
> a counter of events in progress and the other one decreases this counter.
> Together they have the same effect as pm_wakeup_event(), but the counter
> of wakeup events in progress they operate on is also checked by
> pm_check_wakeup_events().
> 
> Thus there are two ways kernel subsystems can signal wakeup events.  First,
> if the event is not explicitly handed over to user space and "instantaneous",
> they can simply call pm_wakeup_event() and be done with it.  Second, if the
> event is going to be delivered to user space, the subsystem that processes
> the event can call pm_wakeup_begin() right when the event is detected and
> pm_wakeup_end() when it's been handed over to user space.

Or if the event is going to be handled entirely in the kernel but over
a prolonged period of time.

> Please tell me what you think.

I like it a lot.  It addresses the main weakness in the earlier 
version.  With this, you could essentially duplicate the in-kernel part 
of the wakelocks/suspend blockers stuff.  All except the timed 
wakelocks -- you might want to consider adding a 
pm_wakeup_begin_timeout() convenience routine.

Here's another possible enhancement (if you can figure out a way to do
it without too much effort): After a suspend begins, keep track of the
first wakeup event you get.  Then when the suspend is aborted, print a
log message saying why and indicating which device was responsible for
the wakeup.

One little thing: You have the PCI subsystem call pm_wakeup_event().  
If the driver then wants to call pm_wakeup_begin(), the event will get 
counted twice.  I guess this doesn't matter much, but it does seem 
peculiar.

Alan Stern

