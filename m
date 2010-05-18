Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab0ERTMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:12:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab0ERTMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:12:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Tue, 18 May 2010 21:13:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
References: <1273810273-3039-1-git-send-email-arve@android.com> <201005172342.52660.rjw@sisk.pl> <AANLkTilQ5wZ_7fMyDMpUBCtu9oD1Wh22JGllyS1EPlxB@mail.gmail.com>
In-Reply-To: <AANLkTilQ5wZ_7fMyDMpUBCtu9oD1Wh22JGllyS1EPlxB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005182113.10448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
> 2010/5/17 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday 17 May 2010, Arve Hjønnevåg wrote:
> >> 2010/5/14 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Friday 14 May 2010, Arve Hjønnevåg wrote:
> >> >> This patch series adds a suspend-block api that provides the same
> >> >> functionality as the android wakelock api. This version has some
> >> >> changes from, or requested by, Rafael. The most notable changes are:
> >> >> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
> >> >>   for statically allocated suspend blockers.
> >> >> - suspend_blocker_destroy is now called suspend_blocker_unregister
> >> >> - The user space mandatory _INIT ioctl has been replaced with an
> >> >>   optional _SET_NAME ioctl.
> >> >>
> >> >> I kept the ack and reviewed by tags on two of the patches even though
> >> >> there were a few cosmetic changes.
> >> >
> >> > Thanks for the patches, I think they are in a pretty good shape now.
> >> >
> >> > That said, I'd like the changelogs to be a bit more descriptive, at least for
> >> > patch [1/8].  I think it should explain (in a few words) what the purpose of
> >> > the feature is and what problems it solves that generally a combination of
> >> > runtime PM and cpuidle is not suitable for in your opinion.  IOW, why you
> >> > think we need that feature.
> >> >
> >>
> >> How about:
> >>
> >> PM: Add opportunistic suspend support.
> >
> > "PM: Opportunistic suspend support" would be sufficient IMO.
> >
> > Now, I'd start with the motivation.  Like "Power management features present
> > in the current mainline kernel are insufficient to get maximum possible energy
> > savings on some platforms, such as Android, because ..." (here go explanations
> > why this is the case in your opinion).
> >
> > Next, "To allow Android and similar platforms to save more energy than they
> > currently can save using the mainline kernel, introduce a mechanism by which
> > the system is automatically suspended (i.e. put into a system-wide sleep state)
> > whenever it's not doing useful work, called opportunistic suspend".
> >
> > "For this purpose introduce the suspend blockers framework allowing the
> > kernel's power management subsystem to decide when it is desirable to suspend
> > the system (i.e. when useful work is not being done).  Add an API that ..."
> >
> 
> PM: Opportunistic suspend support.
> 
> Power management features present in the current mainline kernel are
> insufficient to get maximum possible energy savings on some platforms,
> such as Android, because low power states can only safely be entered
> from idle.

Do you mean CPU low-power states or system low-power states here?

I'd add more details here, because it may not be completely clear to the
(interested) reader why entering these states only from idle affects the
possibility to achieve maximum energy savings.  I _guess_ you mean that
using idle is not sufficient, because there are so many wakeups on the
systems in question that more savings are still possible.  Is that correct?

> Suspend, in its current form, cannot be used, since wakeup
> events that occur right after initiating suspend will not be processed
> until another possibly unrelated event wake up the system again.

I think the word "cannot" is too strong here.  I'd say "not suitable" instead
and I'd say what kind of wakeup events I meant more precisely (there are
events that wake up a CPU from idle and events that wake up the system from
suspend).

> On some systems idle combined with runtime PM can enter the same power
> state as suspend, but periodic wakeups increase the average power
> consumption. Suspending the system also reduces the harm caused by
> apps that never go idle. On other systems suspend can enter a much
> lower power state than idle.
> 
> To allow Android and similar platforms to save more energy than they
> currently can save using the mainline kernel, we introduce a mechanism

Just "introduce" without "we" works too.

> by which the system is automatically suspended (i.e. put into a
> system-wide sleep state) whenever it's not doing useful work, called
> opportunistic suspend.

I think we can address the Kevin's comment about "useful" and say "whenever
it's only doing work that can be done later without noticeable effect on
functionality".

> For this purpose introduce the suspend blockers framework allowing the
> kernel's power management subsystem to decide when it is desirable to
> suspend the system (i.e. when useful work is not being done). Add an

Perhaps remove the part in parens entirely.

> API that that drivers can use to block opportunistic suspend. This is
> needed to avoid losing wakeup events that occur right after suspend is
> initiated.
> 
> Adds /sys/power/policy that selects the behavior of /sys/power/state.
> After setting the policy to opportunistic, writes to /sys/power/state
> become non-blocking requests that specify which suspend state to enter
> when no suspend blockers are active. A special state, "on", stops the
> process by activating the "main" suspend blocker.

...
 
> PM: suspend_block: Add driver to access suspend blockers from user-space
> 
> Add a misc device, "suspend_blocker", that allows user-space processes
> to block automatic suspend.
> 
> Opening this device creates a suspend blocker that can be used by the
> opener to prevent automatic suspend from occurring.  There are ioctls
> provided for blocking and unblocking suspend and for giving the
> suspend blocker a meaningful name.  Closing the device special file
> causes the suspend blocker to be destroyed.
> 
> For example, when select or poll indicates that input event are
> available, this interface can be used by user space to block suspend
> before it reads those events. This allows the input driver to release
> its suspend blocker as soon as the event queue is empty. If user space
> could not use a suspend blocker here the input driver would need to
> delay the release of its suspend blocker until it knows (or assumes)
> that user space has finished processing the events.
> 
> By careful use of suspend blockers in drivers and user space system
> code, one can arrange for the system to stay awake for extremely short
> periods of time in reaction to events, rapidly returning to a fully
> suspended state.

That's fine by me.

Thanks,
Rafael
