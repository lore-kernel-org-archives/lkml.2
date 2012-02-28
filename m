Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab2B1BNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:13:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45135 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965253Ab2B1BNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:13:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while event queue is not empty
Date: Tue, 28 Feb 2012 02:17:39 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202262157.18496.rjw@sisk.pl> <20120227221831.GF7666@count0.beaverton.ibm.com>
In-Reply-To: <20120227221831.GF7666@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202280217.39661.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 27, 2012, Matt Helsley wrote:
> On Sun, Feb 26, 2012 at 09:57:18PM +0100, Rafael J. Wysocki wrote:
> > On Friday, February 24, 2012, Matt Helsley wrote:
> > > On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
> > > > From: Arve Hjønnevåg <arve@android.com>
> > > > 
> > > > Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
> > > > an evdev client event queue, such that it will be active whenever the
> > > > queue is not empty.  Then, all events in the queue will be regarded
> > > > as wakeup events in progress and pm_get_wakeup_count() will block (or
> > > > return false if woken up by a signal) until they are removed from the
> > > > queue.  In consequence, if the checking of wakeup events is enabled
> > > > (e.g. throught the /sys/power/wakeup_count interface), the system
> > > > won't be able to go into a sleep state until the queue is empty.
> > > > 
> > > > This allows user space processes to handle situations in which they
> > > > want to do a select() on an evdev descriptor, so they go to sleep
> > > > until there are some events to read from the device's queue, and then
> > > > they don't want the system to go into a sleep state until all the
> > > > events are read (presumably for further processing).  Of course, if
> > > > they don't want the system to go into a sleep state _after_ all the
> > > > events have been read from the queue, they have to use a separate
> > > > mechanism that will prevent the system from doing that and it has
> > > > to be activated before reading the first event (that also may be the
> > > > last one).
> > > 
> > > I haven't seen this idea mentioned before but I must admit I haven't
> > > been following this thread too closely so apologies (and don't bother
> > > rehashing) if it has:
> > > 
> > > Could you just add this to epoll so that any fd userspace chooses would be
> > > capable of doing this without introducing potentially ecclectic ioctl
> > > interfaces?
> > > 
> > > struct epoll_event ev;
> > > 
> > > epfd = epoll_create1(EPOLL_STAY_AWAKE_SET);
> > > ev.data.ptr = foo;
> > > epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
> > > 
> > > Which could be useful because you can put one epollfd in another's epoll
> > > set. Or maybe as an EPOLLKEEPAWAKE flag in the event struct sort of like
> > > EPOLLET:
> > > 
> > > epfd = epoll_create1(0);
> > > ev.events = EPOLLIN|EPOLLKEEPAWAKE;
> > > epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
> > 
> > Do you mean something like the patch below, or something different?
> 
> Yeah, this was sort of what I was thinking of. It nicely avoids the
> ioctl() bits. I guess my only issue is the fop mimics the epoll
> interface -- should it just be an fop to manage the file as a wakeup
> source rather than a generic hook into epoll?

I'm not exactly sure what you mean, could you be a bit more specific, please?

Rafael
