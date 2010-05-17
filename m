Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0EQVlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:41:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab0EQVly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:41:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Mon, 17 May 2010 23:42:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
References: <1273810273-3039-1-git-send-email-arve@android.com> <201005142308.48386.rjw@sisk.pl> <AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
In-Reply-To: <AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005172342.52660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, Arve Hjønnevåg wrote:
> 2010/5/14 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday 14 May 2010, Arve Hjønnevåg wrote:
> >> This patch series adds a suspend-block api that provides the same
> >> functionality as the android wakelock api. This version has some
> >> changes from, or requested by, Rafael. The most notable changes are:
> >> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
> >>   for statically allocated suspend blockers.
> >> - suspend_blocker_destroy is now called suspend_blocker_unregister
> >> - The user space mandatory _INIT ioctl has been replaced with an
> >>   optional _SET_NAME ioctl.
> >>
> >> I kept the ack and reviewed by tags on two of the patches even though
> >> there were a few cosmetic changes.
> >
> > Thanks for the patches, I think they are in a pretty good shape now.
> >
> > That said, I'd like the changelogs to be a bit more descriptive, at least for
> > patch [1/8].  I think it should explain (in a few words) what the purpose of
> > the feature is and what problems it solves that generally a combination of
> > runtime PM and cpuidle is not suitable for in your opinion.  IOW, why you
> > think we need that feature.
> >
> 
> How about:
> 
> PM: Add opportunistic suspend support.

"PM: Opportunistic suspend support" would be sufficient IMO.

Now, I'd start with the motivation.  Like "Power management features present
in the current mainline kernel are insufficient to get maximum possible energy
savings on some platforms, such as Android, because ..." (here go explanations
why this is the case in your opinion).

Next, "To allow Android and similar platforms to save more energy than they
currently can save using the mainline kernel, introduce a mechanism by which
the system is automatically suspended (i.e. put into a system-wide sleep state)
whenever it's not doing useful work, called opportunistic suspend".

"For this purpose introduce the suspend blockers framework allowing the
kernel's power management subsystem to decide when it is desirable to suspend
the system (i.e. when useful work is not being done).  Add an API that ..."

> Adds a suspend block api that drivers can use to block opportunistic
> suspend. This is needed to avoid losing wakeup events that occur
> right after suspend is initiated.
>
> Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> After setting the policy to opportunistic, writes to /sys/power/state
> become non-blocking requests that specify which suspend state to enter
> when no suspend blockers are active. A special state, "on", stops the
> process by activating the "main" suspend blocker.
> 
> Opportunistic suspend is most useful on systems that cannot enter their
> lowest power state from idle, but it is also useful on systems that enter
> the same power state from idle and suspend. Periodic timers can cause
> a significant power drain on these systems, and suspend will stop most
> of this. Opportunistic suspend can also reduce the harm caused by apps
> that never go idle.
> 
> > The changelog of patch [2/8] appears to be outdated, that needs to be fixed.
> > Also, it would be nice to explain in the changelog what the interface is needed
> > for (in terms of the problems that it helps to handle).
> >
> 
> How about:
> 
> PM: suspend_block: Add driver to access suspend blockers from user-space
> 
> Add a misc device, "suspend_blocker", that allows user-space processes
> to block auto suspend.

"automatic suspend" would be better IMO.

> Opening this device creates a suspend_blocker.

"suspend blocker that can be used by the opener to prevent automatic suspend
from occuring.  There are ioctls provided for blocking and unblocking suspend
and for giving the suspend blocker a meaningful name.  Closing the device
special file causes the suspend blocker to be destroyed."

> ioctls are provided to name this suspend_blocker, and to block and unblock
> suspend. To delete the suspend_blocker, close the device.
> 
> For example, when select or poll indicates that input event are available, this
> interface can be used to block suspend before reading those event. This allows
> the input driver to release its suspend blocker as soon as the event queue is
> empty.

I think you should explain in more detail how suspend blockers used by user
space make that possible.

Rafael
