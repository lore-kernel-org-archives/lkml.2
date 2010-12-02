Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0LBDH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:07:56 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57039 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab0LBDHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:07:54 -0500
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for
 clock changes
From: john stultz <johnstul@us.ibm.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20101202011211.GN22787@shareable.org>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
	 <20101123224346.GA19350@tango.0pointer.de>
	 <20101201104359.GJ22787@shareable.org> <1291248647.2846.34.camel@work-vm>
	 <20101202011211.GN22787@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 19:07:44 -0800
Message-ID: <1291259264.2846.119.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 01:12 +0000, Jamie Lokier wrote:
> john stultz wrote:
> > > CLOCK_MONOTONIC is unsuitable because it stops at suspend.  Maybe it
> > > should stay that way.  But maybe not - programs using CLOCK_MONOTONIC
> > > usually want to trigger timeouts etc. based on real elapsed time, and
> > > after suspend/resume, it's quite reasonable to want to trigger all of
> > > a program's short timeouts immediately.  Indeed some network protocol
> > > userspace may currently behave *incorrectly* over suspend/resume,
> > > especially those using clock times to validate their caches,
> > > *because* CLOCK_MONOTONIC doesn't count it.
> > 
> > Is there a specific example of this occurring that you have in mind?
> 
> Yes, it's a correctness issue in network protocols using
> lease/oplock/MESI-style cache coherency.  (E.g. NFSv4, CIFS, whatever
> you like in userspace.)

Ok. Just curious, as similar cases I was thinking about (like AFS)
require clients to have a reasonably synced CLOCK_REALTIME to the server
for such caching. I'll have to look at the NFSv4 and CIFS cases.

> By this, I mean anything with this sort of pattern:
> 
>    1. Receive message "you may cache thing X for up to 20 seconds *without
>       checking if it changed* during that time; afterwards, check".
> 
>       (If the other end need to change X within the 20 second
>       interval, the other end will send a request to break the lease;
>       if the other end doesn't get a response, then it waits until the
>       20 second expires, and then it's safe to assume the lease expired.)
> 
>    2. Local request for value of X.
> 
>       => If less than 20 seconds has passed, the local cache responds
>          with X *without any network confirmation*.  I.e. it's instant.
>       => If more than 20 seconds has passed, it has to talk to the
>          other end.  I.e. a network round trip.
> 
> The algorithm is coherent even if the network is unreliable and goes
> down sometimes.  When that happens, local requests are stalled, rather
> than returning values incoherent with other machines.
> 
> This algorithm breaks if the local application depends on
> CLOCK_MONOTONIC to confirm that less than 20 seconds has passed
> and CLOCK_MONOTONIC is lying.
> 
> CLOCK_MONOTONIC lies when you've done suspend+resume while this
> program was running, so it's 20 seconds test gives the wrong result.
> 
> You can imagine there are quite a few applications that use this
> technique because it's quite fundamental to efficient coherency
> protocols.  (Although I'm unable to name any off the top of my head!).

Yea, the case seems reasonable. I guess I'm just surprised they use
CLOCK_MONOTONIC and haven't complained earlier about it.

> > > So maybe CLOCK_MONOTONIC should be changed to include elapsed time
> > > during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
> > > for programs that want that?
> > 
> > No. Lets not change it. CLOCK_MONOTONIC and CLOCK_MONOTONIC_RAW's
> > relationship is tightly coupled, and applications that are tracking the
> > amount of clock adjustment being done to the system require they keep
> > their semantics.
> > 
> > As I said earlier, adding a new clockid to represent the MONOTONIC
> > +SUSPEND time wouldn't be difficult, we just need to be clear about why
> > it should be exposed, and have it also be easy to describe to developers
> > which clockid would suit their needs best.
> 
> What I've described above doesn't actually need a new clock.  It's
> enough if you guarantee some kind of notification when there's been an
> unknown jump in CLOCK_MONOTONIC's relationship to real time.

I'm not as familiar with the pm code, but if you just need
suspend/resume event notification, we should already have that via the
userland suspend/resume hooks.

It just seems to me that the notification you suggest is sufficient, but
is only minimally useful. So, an application gets a notification that we
suspended, and so CLOCK_MONOTONIC based timers may have been delayed,
but without knowing how much, its unclear what to do. For the cache
cases, sure, you can just drop everything, but I'm sure for other cases
we'd be pushing the userland app to keep its own sense of the
CLOCK_MONOTONIC/REALTIME delta and try to track those changes.

So providing a new CLOCK_BOOTTIME or something would seem pretty
reasonable to me, allowing things like timers to be set that would
expire immediately after a resume if they were to expire while the
system was suspended.

> That's just as well, as I doubt you could guarantee MONOTONIC+SUSPEND
> accuracy on all hardware.

Well, unless there is no persistent/RTC device to figure out the suspend
time from, I think we could do a decent job. There are limitations (ie:
RTC hardware only providing second resolution time), but the bar for
time accuracy over suspend has been fairly low so far. 

> For correct behaviour, the notification must be guaranteed to be seen
> by any program when it queries CLOCK_MONOTONIC or queries expiry of a
> timer based on that.  It's insufficient to queue a notification which
> might take program execution time to be delivered (that includes
> signals).  In other words, the clock-jump flag must be flagged by
> suspend/resume before the program execution itself is resumed (and
> after it's suspended of course), and seen synchronously when the
> program calls a system call to check the clock/timer.

Maybe I'm missing something, but that seems like such a notification is
going to be difficult to provide with the current interfaces. And I'm
not sure it resolves any races you'd have with the suspend hitting you
right after the time read but before an action is taken.

For such strict semantics, it almost seems like some way to inhibit
suspend would be needed around the time checks and actions.

thanks
-john






