Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab2BYX36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 18:29:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42353 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab2BYX35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 18:29:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while event queue is not empty
Date: Sun, 26 Feb 2012 00:33:55 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <20120224051649.GB7666@count0.beaverton.ibm.com> <CAMP5XgeaRHJ=FuOP2E4vj6OcX41nHmmB2bjr8Gq8NUXBCdXA2A@mail.gmail.com>
In-Reply-To: <CAMP5XgeaRHJ=FuOP2E4vj6OcX41nHmmB2bjr8Gq8NUXBCdXA2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202260033.55556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 25, 2012, Arve Hjønnevåg wrote:
> On Thu, Feb 23, 2012 at 9:16 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> > On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
> >> From: Arve Hjønnevåg <arve@android.com>
> >>
> >> Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
> >> an evdev client event queue, such that it will be active whenever the
> >> queue is not empty.  Then, all events in the queue will be regarded
> >> as wakeup events in progress and pm_get_wakeup_count() will block (or
> >> return false if woken up by a signal) until they are removed from the
> >> queue.  In consequence, if the checking of wakeup events is enabled
> >> (e.g. throught the /sys/power/wakeup_count interface), the system
> >> won't be able to go into a sleep state until the queue is empty.
> >>
> >> This allows user space processes to handle situations in which they
> >> want to do a select() on an evdev descriptor, so they go to sleep
> >> until there are some events to read from the device's queue, and then
> >> they don't want the system to go into a sleep state until all the
> >> events are read (presumably for further processing).  Of course, if
> >> they don't want the system to go into a sleep state _after_ all the
> >> events have been read from the queue, they have to use a separate
> >> mechanism that will prevent the system from doing that and it has
> >> to be activated before reading the first event (that also may be the
> >> last one).
> >
> > I haven't seen this idea mentioned before but I must admit I haven't
> > been following this thread too closely so apologies (and don't bother
> > rehashing) if it has:
> >
> > Could you just add this to epoll so that any fd userspace chooses would be
> > capable of doing this without introducing potentially ecclectic ioctl
> > interfaces?
> >
> 
> This is an interesting idea, but I'm not sure how well it would work.
> 
> I looked at the epoll code and it looks like it is possible to
> activate the wakeup-source from the wait queue function it uses.

I'm not sure I'm following you here.  How exactly would you like to do that?

In particular, what data structure would the wakeup source object be
associated with?

> The epoll callback will happen without holding evdev client buffer_lock,
> so the wakeup-source and buffer state will not always be in sync (this
> may be OK, but require more thought). This callback is also called if
> no data was added to the queue we are polling on because another
> client has grabbed the input device (is this a bug or intended?).
> 
> There is no call into the epoll code when input queue is emptied, so
> we can't deactivate the wakeup-source until epoll_wait is called
> again. This also should be workable, but result in different stats.
> 
> It does not look like the normal poll and select interfaces can be
> extended the same way (since they remove themselves from the
> wait-queue before returning to user-space), so user-space has to be
> changed to use epoll even if select or poll would be a better fit.

Well, epoll without EPOLLET is equivalent to poll, so the only potential
issue is select.  How serious may the problem with that be?

> I don't know how many other drivers this would work for. The input
> driver will wake up user-space from the same thread or interrupt
> handler that queued the event, but other drivers may defer this to
> another thread which makes an epoll wakeup-source insufficient.

If we go for new ioctls insread, we'll have to add them to all of those
drivers, so I would prefer the epoll-based approach if that's viable at
least for a subset of the relevant drivers.

> ...
> >> +     snprintf(name, sizeof(name), "%s-%d",
> >> +              dev_name(&evdev->dev), task_tgid_vnr(current));
> >
> > This does not look like it will work well with tasks in different pid
> > namespaces. What should happen, I think, is the wakeup_source should hold a
> > reference to either the struct pid of current or current itself. Then
> > when someone reads the file you should get the pid vnr in the reader's
> > pid namespace. That way instead of a bogus pid vnr 0 would show up if
> > "current" here is not in the reader's pid namepsace.
> >
> 
> The pid here is only used for debugging purposes, and used less than
> the dev_name. I don't think tracking pid namespaces is worth the
> trouble here, so if this is a real problem we can just drop the pid
> from the name for now.

OK

Thanks,
Rafael
