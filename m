Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1JPBtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:49:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45461 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751489Ab1JPBtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:49:45 -0400
Date: Sat, 15 Oct 2011 21:49:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: markgross@thegnar.org, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <arve@android.com>,
        <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
In-Reply-To: <20111016092556.07d6e415@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011, NeilBrown wrote:

> > > > Here's an example (just for kicks, not completely relevant to your
> > > > discussion): A USB keyboard key release.  Unlike key presses, key
> > > > releases need not generate input events.  If no processes are
> > > > monitoring the raw keyboard event queue then the release is not visible
> > > > to userspace at all, hence not visible before the wakeup_source needs
> > > > to be deactivated.
> > > > 
> > > > Alan Stern
> > > 
> > > As you say, not completely relevant.
> > > 
> > > If a tree falls in a forest with no one to here, does it make a sound?
> > > 
> > > similarly if an event happens that no-one is looking for, is it visible?
> > > It doesn't really matter.
> > 
> > That's a different question, but I'll answer it anyway: Yes, it does
> > matter.  If the kernel is unable to _know_ that nobody is looking for
> > an event, it has to _assume_ that somebody is.  Then what should happen 
> > if it turns out that nobody really is looking for it?
> 
> Same answer - it doesn't really matter.
> In every case, the kernel's responsibility is to make the sure the event is
> visible to any watching user-space process before it releases the
> wakeup_source.
> What user-space does then is up to user-space.
> If no-one is watching the kernel is free to drop it at any stage - as soon as
> it discovers no-one is watching.
> When the input layer gets an event, it iterated through a list of fds which
> are open on the event source and queues it to each one.  This list might be
> empty - no big deal.  It was still a wakeup_event.  If we were suspended, the
> write to /sys/power/state will now complete, the suspend daemon will go back
> around its loop, nothing will seem to be happening, so the system will go
> back to sleep.

All right, let's make things a little more complicated.

Here's what actually happens when a USB keyboard generates a wakeup 
request.  The system wakes up, of course, but there's no particular 
indication of the cause.  In particular, the usbhid driver has no way 
to know directly that the keyboard was the reason for the wakeup.

In addition, usbhid can't poll keyboards to see if they have an event
to report.  (In theory it could -- the HID protocol allows for this --
but many keyboards don't support that part of the protocol properly.)  
It has to wait until the keyboard gets around to reporting the event, 
which can take 10 ms or more.

Taken together, this means usbhid must activate a wakeup_source every
time it wakes up.  If a keyboard event report is received reasonably
quickly then good, it can deactivate the wakeup_source at the right
time.  But if not, all the driver can do is time out the wakeup_source
after some delay.  I don't see any way to avoid it.

Alan Stern

