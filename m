Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab0HMPJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:09:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38910 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934424Ab0HMPJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:09:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Date: Fri, 13 Aug 2010 17:07:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com> <201008130528.21887.rjw@sisk.pl> <AANLkTinMmVdAVaCFXyDZpVRmZ9FCWYhtdeM=o4hdoZnT@mail.gmail.com>
In-Reply-To: <AANLkTinMmVdAVaCFXyDZpVRmZ9FCWYhtdeM=o4hdoZnT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008131707.03484.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 13, 2010, Arve Hjønnevåg wrote:
> On Thu, Aug 12, 2010 at 8:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, August 12, 2010, Jesse Barnes wrote:
> >> On Thu, 12 Aug 2010 12:19:34 -0700
> >> Brian Swetland <swetland@google.com> wrote:
> >> > Question though -- has every feature ever added to the kernel been a
> >> > feature that there's pre-existing usage of?  Seems like a chicken and
> >> > egg problem.  Also, some people seem to think there's value in being
> >> > able to build kernels "out of the box" that work with the Android
> >> > userspace -- given that there are a few devices out there that have
> >> > that userspace on 'em.
> >>
> >> We generally try to merge new features like this along with code that
> >> uses said feature, but there are always exceptions.  We've merged code
> >> one release or more before the new code gets used for example, which is
> >> fine IMO.  What we don't want to see is some new drop of code added and
> >> abandoned, but you already knew that.
> >>
> >> At any rate, if Felipe is the only one arguing against including
> >> suspend blockers in the kernel, you're probably in good shape.  Based
> >> on my (rather cursory I admit) evaluation of this thread, it seems like
> >> reasonable people agree that there's a place for a suspend blocker like
> >> API in the kernel, and that dynamic power management is also highly
> >> desirable.  So where's the git pull request already? :)
> >
> > In fact my patch going in that direction has been merged already and that
> > code will likely be extended to cover some needs and cases I didn't have in
> > mind when I was preparing it.
> >
> > However, having discussed the whole issue for many times and reconsidered it
> > thoroughly, I think that it's inappropriate to identify the suspend blockers
> > (or wakelocks) framework with the opportunistic suspend feature as proposed in
> > the original submission of the "suspend blockers" patchset.  IMO they really
> > are not the same thing and while the suspend blockers framework is used by
> > Android to implement opportunistic suspend, I don't really believe this is the
> > right approach.
> >
> 
> Can you clarify this? Do you not believe using opportunistic suspend
> is the right approach, or do you not believe linking suspend blockers
> with opportunistic suspend is the right approach?

The latter.  That should be clear from the remaining part of my message.

> > We really need something similar to suspend blockers to avoid races between
> > a suspend process and wakeup events, but it isn't necessary to provide user
> > space with an interface allowing it to use these things directly.  Such an
> > interface is only necessary in the specific implementation in which the system
> > is suspended as soon as the number of "active" suspend blockers goes down to
> > zero.
> 
> I don't think what you are saying here is correct. When you decide to
> suspend has no impact on whether a user space interface to block
> suspend is needed. The last suspend blocker patchset had this
> interface as a separate patch and the reasons for providing it have
> not changed with your interface. Android need the user space interface
> because low level services that handle wakeup events are started
> before the user space power manager. The other reason to have this
> interface in the mainline kernel is to provide a safe way to handle
> wakeup events on linux regardless of which user space power manager is
> used on the system. For instance some devices have a user space
> battery monitor, and there would be no need for this code to be
> android specific if the kernel provided all the functionality it
> needs.

Well, the problem is, with your /dev/suspend_blocker interface, multiple
user space processes are supposed to decide whether or not system suspend
should be started and in general there don't seem to be any particularly good
criteria for choosing these applications, in general.  So, application writers
may be tempted to use this interface in all programs and then the decision
whether or not to allow these programs to affect system power management will
be delegated to users.  In turn, the users may not be technically qualified to
make such a decision.

Also the fact that the same mechanism is used for handling wakeup events
detected by the kernel and allowing user space programs to grant permission to
suspend the system is somewhat confusing.

> >  Arguably, though, this isn't the only possible way to implement a
> > mechanism allowing the system to be suspended automatically when it appears
> > to be inactive.
> >
> > Namely, one can use a user space power manager for this purpose and actually
> > the OLPC project has been doing that successfully for some time, which clearly
> > demonstrates that the Android approach to this problem is not the only one
> > possible.  Moreover, the kernel's system suspend (or hibernate for that matter)
> > code has not been designed to be started from within the kernel.  It's been
> > designed to allow a privileged user space process to request the kernel to
> > put the system into a sleep state at any given time regardless of what the
> > other user space processes are doing.  While it can be started from within the
> > kernel, this isn't particularly nice and, in the Android case, starting it from
> > within the kernel requires permission from multiple user space processes
> > (given by not taking suspend blockers these processes are allowed to use).
> >
> 
> Why is starting suspend from within the kernel not nice? Personally I
> think reentering suspend from within the kernel is nicer than being
> forced to wake up a user space thread for events that are fully
> handled within the kernel (for instance the battery monitor on the
> Nexus One).

For basically the same reason why the kernel generally doesn't use sys_open()
for opening files.  It is an interface provided for user space.

> > Since, quite clearly, user space input is necessary to make the decision
> > whether or not to suspend the system, I think it is more appropriate to allow
> > user space to start the entire operation and provide the kernel with a means
> > to abort it in the case of a wakeup event.  Then, user space will be able to
> > use arbitrary heuristics in deciding whether or not to suspend the system,
> > possibly taking some kernel's input into account.
> >
> When we don't need these heuristics, this is just a burden.

The word 'arbitrary' means in particular that you can implement a mechanism
equivalent to the /dev/suspend_blocker entirely in user space.  Someone else,
though, can use a different approach.

By adding the /dev/suspend_blocker interface to the mainline kernel we would
mandate that Linux applications use it on all platforms.  Consequently,
application writers would have the right to expect that all platforms would be
using Android-alike opportunistic suspend, which may or may not be the case.

> > I'm not against the very idea of automatic system suspend, which IMO is a
> > legitimate and reasonable thing to do in many usage scenarios, but I don't
> > think that the kernel is the right place to start a suspend process.  For this
> > reason I'm not going to take any code trying to start a suspend process from
> > within the kernel, regardless of that code's purpose, unless somebody makes a
> > really convincing case for that to me (basically proving the need for such a
> > solution).
> 
> There is no absolute need to start the suspend process from within the
> kernel, but it makes the user space code much simpler for what we
> need.

I'm entirely aware of that.  Still, I think user space is the right place to
initiate system suspend.

Thanks,
Rafael
