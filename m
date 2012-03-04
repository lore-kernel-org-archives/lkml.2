Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2CDWwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:52:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab2CDWwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:52:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while event queue is not empty
Date: Sun, 4 Mar 2012 23:56:17 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, jeffbrown@android.com
References: <201202070200.55505.rjw@sisk.pl> <201202262157.18496.rjw@sisk.pl> <CAMP5XgfJ5tYgAEx_57vS70R8brHf4v=5U4VX5Ribt2e3fBdbfA@mail.gmail.com>
In-Reply-To: <CAMP5XgfJ5tYgAEx_57vS70R8brHf4v=5U4VX5Ribt2e3fBdbfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203042356.17846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 28, 2012, Arve Hjønnevåg wrote:
> On Sun, Feb 26, 2012 at 12:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, February 24, 2012, Matt Helsley wrote:
> >> On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
> >> > From: Arve Hjønnevåg <arve@android.com>
> >> >
> >> > Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
> >> > an evdev client event queue, such that it will be active whenever the
> >> > queue is not empty.  Then, all events in the queue will be regarded
> >> > as wakeup events in progress and pm_get_wakeup_count() will block (or
> >> > return false if woken up by a signal) until they are removed from the
> >> > queue.  In consequence, if the checking of wakeup events is enabled
> >> > (e.g. throught the /sys/power/wakeup_count interface), the system
> >> > won't be able to go into a sleep state until the queue is empty.
> >> >
> >> > This allows user space processes to handle situations in which they
> >> > want to do a select() on an evdev descriptor, so they go to sleep
> >> > until there are some events to read from the device's queue, and then
> >> > they don't want the system to go into a sleep state until all the
> >> > events are read (presumably for further processing).  Of course, if
> >> > they don't want the system to go into a sleep state _after_ all the
> >> > events have been read from the queue, they have to use a separate
> >> > mechanism that will prevent the system from doing that and it has
> >> > to be activated before reading the first event (that also may be the
> >> > last one).
> >>
> >> I haven't seen this idea mentioned before but I must admit I haven't
> >> been following this thread too closely so apologies (and don't bother
> >> rehashing) if it has:
> >>
> >> Could you just add this to epoll so that any fd userspace chooses would be
> >> capable of doing this without introducing potentially ecclectic ioctl
> >> interfaces?
> >>
> >> struct epoll_event ev;
> >>
> >> epfd = epoll_create1(EPOLL_STAY_AWAKE_SET);
> >> ev.data.ptr = foo;
> >> epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
> >>
> >> Which could be useful because you can put one epollfd in another's epoll
> >> set. Or maybe as an EPOLLKEEPAWAKE flag in the event struct sort of like
> >> EPOLLET:
> >>
> >> epfd = epoll_create1(0);
> >> ev.events = EPOLLIN|EPOLLKEEPAWAKE;
> >> epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
> >
> > Do you mean something like the patch below, or something different?
> >
> > Rafael
> >
> > ---
> 
> I don't think it is useful to tie an evdev implementation to epoll
> that way. You just replaced the ioctl with a new control function.
> 
> The code below tries to implement the same flag without modifying
> evdev at all. The behavior of this is different as it will keep the
> device awake until user-space calls epoll_wait again. I also used an
> extra wakeup source to handle the function that runs without the
> spin_lock held which means that non-wakeup files in same epoll list
> could abort suspend.

Well, if that works for you, it will be better than adding ioctls to evdev
(and presumably a number of other devices).

Care to resubmit with a proper changelog and sign-off?

Rafael
