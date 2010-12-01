Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0LAKod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:44:33 -0500
Received: from mail2.shareable.org ([80.68.89.115]:53009 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0LAKoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:44:32 -0500
Date: Wed, 1 Dec 2010 10:43:59 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Message-ID: <20101201104359.GJ22787@shareable.org>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org> <20101123224346.GA19350@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123224346.GA19350@tango.0pointer.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Poettering wrote:
> On Tue, 23.11.10 19:22, Alexander Shishkin (virtuoso@slind.org) wrote:
> 
> > Certain userspace applications (like "clock" desktop applets or cron or
> > systemd) might want to be notified when some other application changes
> > the system time. There are several known to me reasons for this:
> >  - avoiding periodic wakeups to poll time changes;
> >  - rearming CLOCK_REALTIME timers when said changes happen;
> >  - changing system timekeeping policy for system-wide time management
> >    programs;
> >  - keeping guest applications/operating systems running in emulators
> >    up to date.
> > 
> > This is another attempt to approach notifying userspace about system
> > clock changes. The other one is using an eventfd and a syscall [1]. In
> > the course of discussing the necessity of a syscall for this kind of
> > notifications, it was suggested that this functionality can be achieved
> > via timers [2] (and timerfd in particular [3]). This idea got quite
> > some support [4], [5], [6] and some vague criticism [7], so I decided
> > to try and go a bit further with it.
> 
> I agree with Kay, this is pretty much exactly what we want for
> systemd. (Assuming that the time jump due to system suspend is
> propagated to userspace like any other time jump with this path).

I hope the time jump due to suspend is *not* propagated in the same
way to userspace :-)

What I'd like to see:

 1. Time jump due to the system clock being stepped: Notification.

    This is *not* a change in real time.  It means the clock was
    corrected/changed.  No physical time passed.

 2. Time jump due to suspend/resume: Different notification.

    This *is* a change in real time.  Physical time passed.

 3. Time drift corrections: As now, no notification, it's just
    the clock being regulated.

To signal the difference between 1 and 2, there ought to be some way
for userspace to determine how much of the clock delta corresponds
with physical time, by reading some sort of "monotonic" clock :-)

CLOCK_MONOTONIC is unsuitable because it stops at suspend.  Maybe it
should stay that way.  But maybe not - programs using CLOCK_MONOTONIC
usually want to trigger timeouts etc. based on real elapsed time, and
after suspend/resume, it's quite reasonable to want to trigger all of
a program's short timeouts immediately.  Indeed some network protocol
userspace may currently behave *incorrectly* over suspend/resume,
especially those using clock times to validate their caches,
*because* CLOCK_MONOTONIC doesn't count it.

So maybe CLOCK_MONOTONIC should be changed to include elapsed time
during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
for programs that want that?

That, plus this proposed patch, would signal the difference between 1
and 2 above nicely.

-- Jamie
