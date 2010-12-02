Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0LBBNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:13:09 -0500
Received: from mail2.shareable.org ([80.68.89.115]:46195 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0LBBNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:13:07 -0500
Date: Thu, 2 Dec 2010 01:12:11 +0000
From: Jamie Lokier <jamie@shareable.org>
To: john stultz <johnstul@us.ibm.com>
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
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Message-ID: <20101202011211.GN22787@shareable.org>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org> <20101123224346.GA19350@tango.0pointer.de> <20101201104359.GJ22787@shareable.org> <1291248647.2846.34.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291248647.2846.34.camel@work-vm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> > CLOCK_MONOTONIC is unsuitable because it stops at suspend.  Maybe it
> > should stay that way.  But maybe not - programs using CLOCK_MONOTONIC
> > usually want to trigger timeouts etc. based on real elapsed time, and
> > after suspend/resume, it's quite reasonable to want to trigger all of
> > a program's short timeouts immediately.  Indeed some network protocol
> > userspace may currently behave *incorrectly* over suspend/resume,
> > especially those using clock times to validate their caches,
> > *because* CLOCK_MONOTONIC doesn't count it.
> 
> Is there a specific example of this occurring that you have in mind?

Yes, it's a correctness issue in network protocols using
lease/oplock/MESI-style cache coherency.  (E.g. NFSv4, CIFS, whatever
you like in userspace.)

By this, I mean anything with this sort of pattern:

   1. Receive message "you may cache thing X for up to 20 seconds *without
      checking if it changed* during that time; afterwards, check".

      (If the other end need to change X within the 20 second
      interval, the other end will send a request to break the lease;
      if the other end doesn't get a response, then it waits until the
      20 second expires, and then it's safe to assume the lease expired.)

   2. Local request for value of X.

      => If less than 20 seconds has passed, the local cache responds
         with X *without any network confirmation*.  I.e. it's instant.
      => If more than 20 seconds has passed, it has to talk to the
         other end.  I.e. a network round trip.

The algorithm is coherent even if the network is unreliable and goes
down sometimes.  When that happens, local requests are stalled, rather
than returning values incoherent with other machines.

This algorithm breaks if the local application depends on
CLOCK_MONOTONIC to confirm that less than 20 seconds has passed
and CLOCK_MONOTONIC is lying.

CLOCK_MONOTONIC lies when you've done suspend+resume while this
program was running, so it's 20 seconds test gives the wrong result.

You can imagine there are quite a few applications that use this
technique because it's quite fundamental to efficient coherency
protocols.  (Although I'm unable to name any off the top of my head!).

There are generalisations for more interesting distributed systems.
The thing they all have in common is the ability to locally
query "has time T elapsed, in terms that would be recognised as T by
the remote machines".  In reality clocks have tolerances etc. so you
fudge by some percentage, and you are more careful about the order of
events than I have shown (it's more like "you may assume Y for up to
time T since you sent the request which initiated this response".)

clearly this wouldn't be expected to go wrong *often*, but it's good
if distributed systems correctness remains assured over
suspend/resume, so it's no different from slowing/descheduling.

For this sort of thing, it's enough to have a vague guaranteed
notification from the system: "There has been some kind of
CLOCK_MONOTONIC discrepancy", and algorithms should assume everything
might have elapsed.

> > So maybe CLOCK_MONOTONIC should be changed to include elapsed time
> > during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
> > for programs that want that?
> 
> No. Lets not change it. CLOCK_MONOTONIC and CLOCK_MONOTONIC_RAW's
> relationship is tightly coupled, and applications that are tracking the
> amount of clock adjustment being done to the system require they keep
> their semantics.
> 
> As I said earlier, adding a new clockid to represent the MONOTONIC
> +SUSPEND time wouldn't be difficult, we just need to be clear about why
> it should be exposed, and have it also be easy to describe to developers
> which clockid would suit their needs best.

What I've described above doesn't actually need a new clock.  It's
enough if you guarantee some kind of notification when there's been an
unknown jump in CLOCK_MONOTONIC's relationship to real time.

That's just as well, as I doubt you could guarantee MONOTONIC+SUSPEND
accuracy on all hardware.

For correct behaviour, the notification must be guaranteed to be seen
by any program when it queries CLOCK_MONOTONIC or queries expiry of a
timer based on that.  It's insufficient to queue a notification which
might take program execution time to be delivered (that includes
signals).  In other words, the clock-jump flag must be flagged by
suspend/resume before the program execution itself is resumed (and
after it's suspended of course), and seen synchronously when the
program calls a system call to check the clock/timer.

-- Jamie
