Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2B1A5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:57:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46989 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2B1A5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:57:06 -0500
Date: Mon, 27 Feb 2012 16:19:19 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while
 event queue is not empty
Message-ID: <20120228001919.GG7666@count0.beaverton.ibm.com>
References: <201202070200.55505.rjw@sisk.pl>
 <201202220031.46219.rjw@sisk.pl>
 <201202220034.58836.rjw@sisk.pl>
 <20120224051649.GB7666@count0.beaverton.ibm.com>
 <CAMP5XgeaRHJ=FuOP2E4vj6OcX41nHmmB2bjr8Gq8NUXBCdXA2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5XgeaRHJ=FuOP2E4vj6OcX41nHmmB2bjr8Gq8NUXBCdXA2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-6148-0000-0000-000003CCF66F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 08:25:30PM -0800, Arve Hjønnevåg wrote:
> On Thu, Feb 23, 2012 at 9:16 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> > On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
> >> From: Arve Hjønnevåg <arve@android.com>
> >>
> >> Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
> >> an evdev client event queue, such that it will be active whenever the
> >> queue is not empty.  Then, all events in the queue will be regarded
> >> as wakeup events in progress and pm_get_wakeup_count() will block (or
> >> return false if woken up by a signal) until they are removed from the
> >> queue.  In consequence, if the checking of wakeup events is enabled
> >> (e.g. throught the /sys/power/wakeup_count interface), the system
> >> won't be able to go into a sleep state until the queue is empty.
> >>
> >> This allows user space processes to handle situations in which they
> >> want to do a select() on an evdev descriptor, so they go to sleep
> >> until there are some events to read from the device's queue, and then
> >> they don't want the system to go into a sleep state until all the
> >> events are read (presumably for further processing).  Of course, if
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
> activate the wakeup-source from the wait queue function it uses. The
> epoll callback will happen without holding evdev client buffer_lock,
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

Yup, that is exactly why epoll is so well suited to this.

> changed to use epoll even if select or poll would be a better fit.

Either way, modification of application code is necessary, right?

> I don't know how many other drivers this would work for. The input
> driver will wake up user-space from the same thread or interrupt
> handler that queued the event, but other drivers may defer this to
> another thread which makes an epoll wakeup-source insufficient.

I don't understand how this would be insufficient. So long as the
interrupt causes the wakeup source to prevent the machine from suspending
before finishing interrupt handling does it matter whether the event
handling itself is deferred?

In case there's some confusion: I'm not saying that this idea will solve
all of the problems, especially:

> >> Of course, if
> >> they don't want the system to go into a sleep state _after_ all the
> >> events have been read from the queue, they have to use a separate
> >> mechanism that will prevent the system from doing that and it has
> >> to be activated before reading the first event (that also may be
> >> the
> >> last one).

(endquote)

> 
> ...
> >> +     snprintf(name, sizeof(name), "%s-%d",
> >> +              dev_name(&evdev->dev), task_tgid_vnr(current));
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

I think dropping the pid would be the best choice. If it's absolutely
necessary in the output then it should be made to work with pid namespaces
because the interface will be maintained forever.

Cheers,
	-Matt

