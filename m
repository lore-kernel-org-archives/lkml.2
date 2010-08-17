Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0HQNT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:19:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab0HQNT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:19:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Date: Tue, 17 Aug 2010 15:18:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com> <201008130528.21887.rjw@sisk.pl> <20100813092020.41290f1f@virtuousgeek.org>
In-Reply-To: <20100813092020.41290f1f@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171518.14069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 13, 2010, Jesse Barnes wrote:
> On Fri, 13 Aug 2010 05:28:21 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday, August 12, 2010, Jesse Barnes wrote:
> > > On Thu, 12 Aug 2010 12:19:34 -0700
> > > Brian Swetland <swetland@google.com> wrote:
> > > > Question though -- has every feature ever added to the kernel been a
> > > > feature that there's pre-existing usage of?  Seems like a chicken and
> > > > egg problem.  Also, some people seem to think there's value in being
> > > > able to build kernels "out of the box" that work with the Android
> > > > userspace -- given that there are a few devices out there that have
> > > > that userspace on 'em.
> > > 
> > > We generally try to merge new features like this along with code that
> > > uses said feature, but there are always exceptions.  We've merged code
> > > one release or more before the new code gets used for example, which is
> > > fine IMO.  What we don't want to see is some new drop of code added and
> > > abandoned, but you already knew that.
> > > 
> > > At any rate, if Felipe is the only one arguing against including
> > > suspend blockers in the kernel, you're probably in good shape.  Based
> > > on my (rather cursory I admit) evaluation of this thread, it seems like
> > > reasonable people agree that there's a place for a suspend blocker like
> > > API in the kernel, and that dynamic power management is also highly
> > > desirable.  So where's the git pull request already? :)
> > 
> > In fact my patch going in that direction has been merged already and that
> > code will likely be extended to cover some needs and cases I didn't have in
> > mind when I was preparing it.
> 
> Yeah, I like what you've done with dynamic power management, really
> good stuff (the approach is very similar to the one I used for vblank
> interrupt management in the drm layer).
> 
> Ted's point about providing the user with a way of knowing which apps
> are blocking things is a good one though, and doesn't seem too hard to
> add.  It might even be possible to do it largely with scripts wrapping
> fuser and such.
> 
> > However, having discussed the whole issue for many times and reconsidered it
> > thoroughly, I think that it's inappropriate to identify the suspend blockers
> > (or wakelocks) framework with the opportunistic suspend feature as proposed in
> > the original submission of the "suspend blockers" patchset.  IMO they really
> > are not the same thing and while the suspend blockers framework is used by
> > Android to implement opportunistic suspend, I don't really believe this is the
> > right approach.
> > 
> > We really need something similar to suspend blockers to avoid races between
> > a suspend process and wakeup events, but it isn't necessary to provide user
> > space with an interface allowing it to use these things directly.  Such an
> > interface is only necessary in the specific implementation in which the system
> > is suspended as soon as the number of "active" suspend blockers goes down to
> > zero.  Arguably, though, this isn't the only possible way to implement a
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
> 
> Yes, I see your point.  But I actually think this is a fairly minor
> distinction.  In one case, a privileged app decides when to suspend the
> system, in the other case, one or more of several privileged apps
> decide when a suspend should not be allowed to occur.  It's just a
> matter of where you want to put the code and where you want the
> complexity.

Well, that used to be my opinion before the whole discussion started, but
now I think there's more to it.

First off, we need the "forced" suspend, initiated by writing to
/sys/power/state, to work regardless of the "opportunistic" one.  Now, the
races between wakeup events and suspend process are also a problem for the
"forced" suspend mechanism, so the fix should not be specific to
"opportunistic" suspend.  One could argue that that can be fixed by using
wakelocks as proposed by the Android developers, but this is not the case,
because there's no way to disinguish wakelocks taken by applications (that we
don't want the "forced" suspend to react to) from the wakelocks taken by the
kernel (that are strictly related to "real" wakeup events).

Second, system suspend is really an intrusive operation that does violent
things to many kernel subsystems (it freezes tasks, it puts the mm subsystem
into a degraded mode, it forcibly offlines non-boot CPUs and so on).  If that
is to be started from the kernel, the kernel thread starting it should really
ask all of these subsystems if they are OK with whatever it wants to do and the
answer would always be "no" in the majority of cases.  The very purpose of that
design is to allow a user to suspend the system whenever he wants and not
to do that when there's an opportunity to power down things because they
appear to be inactive (that may or may not be one of the "whenever the user
wants" situations, but really the user should be able to specify the
conditions).  The powering down of things by the kernel when there's an
opportunity should really be done in a more intelligent way (simply becasue the
kernel is potentially able to do that more intelligently).

Finally, in the kernel-driven opportunistic suspend scenario (using wakelocks)
it is not particularly clear which applications should be given the priviledge
to participate in the suspend blocking mechanism.  I don't think there are any
criteria which can be universally used for selecting these applications and in
fact on Android that doesn't work very well either (for example, if you leave
Google Maps in the foreground while the screan is off on Nexus One and you
happen to move reasonably quickly from one location to another, it will drain
the battery for the GPS updates much quickier than you'd expect).  For this
reason I don't think it is particularly smart to rely on applications when
deciding whether or not to start system suspend.  Other criteria should also
be taken into account in general and I have no idea how to provide the kernel
with an interface allowing it to do that.  Therefore I don't think the kernel
should start system suspend automatically.

> In general, we try to keep such complexity out of the
> kernel, but not always; there are compelling cases for putting
> complexity in the kernel to provide uniformity and flexibility (e.g.
> application state save/restore vs. system-wide checkpoints, the former
> preserves the "if it can be done outside the kernel, it should be",
> while the latter provides much greater flexibility and avoids the need
> to port applications to potentially incompatible or unportable state
> saves/restore libraries).

I understand that and IMO it should be decided on the case-by-case basis.
In this particular case, however, I don't think it's appropriate to use the
interface designed with user space in mind for implementing a kernel-based
mechanism.

Thanks,
Rafael
