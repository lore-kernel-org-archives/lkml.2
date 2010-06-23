Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab0FWCMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 22:12:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46948 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750938Ab0FWCMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 22:12:17 -0400
Date: Tue, 22 Jun 2010 22:12:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
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
In-Reply-To: <201006222341.15605.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006222203070.10376-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:

> > > Please tell me what you think.
> > 
> > I like it a lot.  It addresses the main weakness in the earlier 
> > version.  With this, you could essentially duplicate the in-kernel part 
> > of the wakelocks/suspend blockers stuff.  All except the timed 
> > wakelocks -- you might want to consider adding a 
> > pm_wakeup_begin_timeout() convenience routine.
> 
> That may be added in future quite easily if it really turns out to be necessary.
> IIRC Arve said Android only used timeouts in user space wakelocks, not in the
> kernel ones.

Didn't we agree that timeouts would be needed for Wake-on-LAN?

> > Here's another possible enhancement (if you can figure out a way to do
> > it without too much effort): After a suspend begins, keep track of the
> > first wakeup event you get.  Then when the suspend is aborted, print a
> > log message saying why and indicating which device was responsible for
> > the wakeup.
> 
> Good idea, but I'd prefer to add it in a separate patch not to complicate
> things too much to start with.

Okay.  Another thing to be considered later is whether there should be
a way to write to /sys/power/state that would block until the active
wakeup count drops to 0.  On the other hand polling maybe once per
second wouldn't be so bad.  It would happen only when the kernel had
some events outstanding and userspace didn't.

One thing that stands out is the new spinlock.  It could potentially be
a big source of contention.  Any wakeup-enabled device is liable to
need it during every interrupt.  Do you think this could cause a
noticeable slowdown?

> > One little thing: You have the PCI subsystem call pm_wakeup_event().  
> > If the driver then wants to call pm_wakeup_begin(), the event will get 
> > counted twice.  I guess this doesn't matter much, but it does seem 
> > peculiar.
> 
> Knowing that the PCI core has increased the wakeup count of its device, a
> PCI driver may simply use pm_wakeup_begin(NULL) and that will only cause
> the main counter to be increased in the end.  Which kind of makes sense,
> because in that case there really is a sequence of events.  First, the PCI core
> detects a wakeup signal and requests wakeup so that the driver has a chance
> to access the device and get the event information from it (although at this
> point it is not known whether or not the driver will need to do that).  Second,
> the driver requests that the system stay in the working state, because it needs
> time to process the event data and (presumably) hand it over to user space.
> The device has only signaled wakeup once, though, and that should be recorded.

Okay, that works.  Although if anybody wanted to keep track of timing
statistics, the results wouldn't be as effective since the start and
end times would not be associated with the device.

> BTW, I thought I would make pm_get_wakeup_count() and pm_save_wakeup_count()
> fail if they are called when events_in_progress is nonzero.  For
> pm_save_wakeup_count() that's pretty obvious (I think) and it also kind of
> makes sense for pm_get_wakeup_count(), because that will tell the reader of
> /sys/power/wakeup_count that the value is going to change immediately so it
> should really try again.

Sensible.

Alan Stern

