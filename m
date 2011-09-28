Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1I1VAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:00:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34629 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1I1VA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:00:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
Date: Wed, 28 Sep 2011 23:02:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org> <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
In-Reply-To: <1317164216.3112.711.camel@work-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109282302.39360.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,
Hi Peter,

On Wednesday, September 28, 2011, John Stultz wrote:
> On Tue, 2011-09-27 at 12:37 +0200, Peter Zijlstra wrote:
> > On Mon, 2011-09-26 at 15:27 -0700, John Stultz wrote:
> > > On Mon, 2011-09-26 at 22:16 +0200, Peter Zijlstra wrote:
> > > > On Mon, 2011-09-26 at 12:13 -0700, John Stultz wrote:
> > > > > 
> > > > > For now, I'd just be interested in what folks think about the concept with
> > > > > regards to the wakelock discussions. Where it might not be sufficient? Or
> > > > > what other disadvantages might it have? Are there any varients to this
> > > > > idea that would be better? 
> > > > 
> > > > I would like to know why people still think wakelocks are remotely sane?
> > > > 
> > > > From where I'm sitting they're utter crap.. _WHY_ do you need to suspend
> > > > anything? What's wrong with regular idle?
> > > 
> > > Well. Regular idle still takes up more power with my desktop then I
> > > could save with suspend.
> > 
> > Blame Intel ;-)

That's not Intel, but all of the PC vendors who don't care about
anything but Windows compatibility.

> > Personally I loathe suspend because it kills all my network links.

Well, I only use suspend when I would disconnect from the network anyway.
 
> > > My personal use case: I do nightly backups with rdiff-backup. I'd like
> > > to schedule those  backup using an alarm-timer, so I could suspend my
> > > system when I'm not using it. So far, so good, that all works. 
> > > 
> > > However, if my system tries to suspend itself after 15 minutes of X
> > > input idle, and my backup at 2am takes more then 15 minutes, then the
> > > backup gets interrupted. Because rdiff-backup is more of a transactional
> > > style backup, it then has to roll back any incomplete changes and try
> > > again the next night, which will surely take more then 15 minutes, etc.
> > 
> > So your fail is to tie suspend to the input inactivity instead of the
> > completion of your backup thingy.
> 
> Well, its both. If the backup runs very long, and I'm using the machine
> in the morning, I don't want the end of my backup to suspend the system.

I think this is a variant of a more general issue (see below).

> > > I could try to inhibit suspend by making requests to my desktop
> > > environment, so the desktop-specific power management daemon won't
> > > trigger suspend. But given recent behavior, I don't trust that not to
> > > break when I upgrade my system, or if I get frustrated with one desktop
> > > environment, that I won't have to use a different api for whatever other
> > > environment I pick next.
> > 
> > Kick the friggin Desktop folks already for messing up. I mean, because
> > userspace is incompetent this needs to go in the kernel?

The problem is not outright incompetence, but the fact that this would require
creating a layer of user space between the apps and the kernel that would
have to be shared by all the existing variants of user space, or else
applications working with one variant of the user space "middleware" won't be
compatible with another one.

> > Ere long we'll have a kernel based GUI if we go that route.

I guess you'd use the same argument against cgroups, right?

> Well, to be fair to the desktop guys, they have been working to try to
> provide a DBUS api to handle this.
> 
> But even with a proper DBUS api, there's still the race when I walk away
> from my computer 15 minutes before the backup starts. 
> 
> In that case, my backup application's alarm timer fires and schedules
> the backup, but then before the backup application runs and sends its
> DBUS message to block suspend, the suspend occurs. And yea, that's
> probably not a problem for my use, but it limits any similar power
> savings from an environment where reliability might actually matter. 
> 
> Read that last bit again, as it has seemingly been missed over and over
> in these discussions. This ability to make sure wake up events are
> consumed by userland before suspending again is key.

This alone doesn't require any new kernel interfaces IMO, although it
requires some additional conditions to be met, which is not the case in
practice (see below).

> > > Another use case I've heard about are systems that have firmware updates
> > > that are remotely triggered. Should the system go into suspend while the
> > > firmware update is going on, you end up with a brick.
> [snip]
> > > Having to have multiple distro/release specific quirks to get the
> > > power-management-daemon to inhibit suspend is annoying enough, but then
> > > you also have to deal with custom changes by administrator, or remote
> > > power management systems like power nap, which might also echo "mem"
> > > into /sys/power/state when you're not expecting it. A kernel method to
> > > really block suspend would be nice. While this doesn't necessarily need
> > > to be conflated with wakelock style suspend, there is some need to allow
> > > userland to block suspend at the kernel level, and once you have that, I
> > > can't imagine folks not trying to stretch that into something like
> > > wakelocks. So you might as well at least try to design it reasonably
> > > well to start.
> > 
> > How about you create a daemon tasked with managing /sys/power/state and
> > change /sys/power/state such that it can be opened only once, then that
> > daemon can keep the fd open and everything else trying to poke at it
> > will get a fail.
> 
> That's actually pretty interesting. It doesn't handle the race issues
> between wakeup event and event consumption by userland, but not a bad
> tool to have in the toolbox as we look at other approaches.

_If_ there is a power management daemon, it doesn't have to do things like
this.  It may work just as described in Section 5 of this paper:

http://lwn.net/images/pdf/suspend_blockers.pdf

The problem is that no one has ever tried to implement the PM daemon.

I think there are two questions to ask here:

(1) If "opportunistic" suspend is not used (i.e. the only way to make the
    system suspend is to write "mem" to /sys/power/state), can we handle
    the race issues between wakeup events and event consumption by userland?

(2) If the answer to (1) is "yes" and "opportunistic" suspend _is_ going
    to be used, is the mechanism addressing (1) sufficient for it to work
    correctly?

While (2) is only relevant if one wants to use "opportunistic" suspend (like
Android), (1) is relevant in general.

Now, I believe that the answer to (1) is "yes" under the following conditions:
* There is only one user space process attempting to use /sys/power/state
  (ie. the power manager daemon).
* This process cooperates with all user space processes consuming wakeup
  events (as described in the article mentioned above).

Unfortunately, as I said, I'm not aware of any power management daemon
implementations like this used in real life.  [Well, I could create a
proof-of-concept one, but quite evidently people want me to spend time on
other things.]  This means that _in_ _practice_ the answer to (1) is "no",
which I think John is trying to address (perhaps among other things).

The practice seems to be that (a) there are multiple processes that can
try to write to /sys/power/state (and we have hibernation that can use
a different interface for that matter) and (b) those processes don't
cooperate with each other in any way close to sanity.

Moreover, user space consumers of wakeup events (or more precisely, consumers
of input data associated with wakeup events) have no way to talk to
the processes operating /sys/power/state, so they can't indicate whether
or not it really is a good idea to suspend at the moment.

Arguably, those issues can be addressed by modifying user space, but there
are a few things to take into consideration here:
* Is it realistic to expect that they're ever going to be addressed this way?
* If so, is the cost of addressing them at the user space level lower or
  higher than the cost of a solution involving a kernel interface?
* If it is higher, then perhaps we can do that at the kernel level after all?

Rafael
