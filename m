Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0LBALM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:11:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38010 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0LBAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:10:57 -0500
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
In-Reply-To: <20101201104359.GJ22787@shareable.org>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
	 <20101123224346.GA19350@tango.0pointer.de>
	 <20101201104359.GJ22787@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 16:10:47 -0800
Message-ID: <1291248647.2846.34.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 10:43 +0000, Jamie Lokier wrote:
> Lennart Poettering wrote:
> > On Tue, 23.11.10 19:22, Alexander Shishkin (virtuoso@slind.org) wrote:
> > 
> > > Certain userspace applications (like "clock" desktop applets or cron or
> > > systemd) might want to be notified when some other application changes
> > > the system time. There are several known to me reasons for this:
> > >  - avoiding periodic wakeups to poll time changes;
> > >  - rearming CLOCK_REALTIME timers when said changes happen;
> > >  - changing system timekeeping policy for system-wide time management
> > >    programs;
> > >  - keeping guest applications/operating systems running in emulators
> > >    up to date.
> > > 
> > > This is another attempt to approach notifying userspace about system
> > > clock changes. The other one is using an eventfd and a syscall [1]. In
> > > the course of discussing the necessity of a syscall for this kind of
> > > notifications, it was suggested that this functionality can be achieved
> > > via timers [2] (and timerfd in particular [3]). This idea got quite
> > > some support [4], [5], [6] and some vague criticism [7], so I decided
> > > to try and go a bit further with it.
> > 
> > I agree with Kay, this is pretty much exactly what we want for
> > systemd. (Assuming that the time jump due to system suspend is
> > propagated to userspace like any other time jump with this path).
> 
> I hope the time jump due to suspend is *not* propagated in the same
> way to userspace :-)

Sadly this behavior depends on architecture and rtc configuration.

For x86 and a number of other architectures, read_persisitent_clock()
functions and we inject the time in suspend into CLOCK_REALTIME on
resume. No notification would be seen.

For architectures where read_persistent_clock does not function (usually
due to RTC not being accessible with irqs are off), we rely on the RTC
code to set the time when it resumes and irqs are enabled. This happens
via do_settimeofday, so a notification would be seen.

A hook could be added so the non-read_persistent_clock supporting arches
can inject time into CLOCK_REALTIME without going through settimeofday()
and triggering the notification. But there may still be odd races around
other stuff running and getting the wrong time before the suspend time
is injected.

This ignores any userland resume scripts that may do something like call
ntpdate or whatever, which would call settimefoday().


> What I'd like to see:
> 
>  1. Time jump due to the system clock being stepped: Notification.
> 
>     This is *not* a change in real time.  It means the clock was
>     corrected/changed.  No physical time passed.

Right. That's settimeofday()/clock_settime().


>  2. Time jump due to suspend/resume: Different notification.
> 
>     This *is* a change in real time.  Physical time passed.

This is the case for read_persistent_clock() supported architectures.

Why do you want a notification here? Or is the resume hook enough?


>  3. Time drift corrections: As now, no notification, it's just
>     the clock being regulated.

Yep. adjtimex() handles this.


> To signal the difference between 1 and 2, there ought to be some way
> for userspace to determine how much of the clock delta corresponds
> with physical time, by reading some sort of "monotonic" clock :-)


Could you further expand on the needs for distinguishing between the
two?


> CLOCK_MONOTONIC is unsuitable because it stops at suspend.  Maybe it
> should stay that way.  But maybe not - programs using CLOCK_MONOTONIC
> usually want to trigger timeouts etc. based on real elapsed time, and
> after suspend/resume, it's quite reasonable to want to trigger all of
> a program's short timeouts immediately.  Indeed some network protocol
> userspace may currently behave *incorrectly* over suspend/resume,
> especially those using clock times to validate their caches,
> *because* CLOCK_MONOTONIC doesn't count it.

Is there a specific example of this occurring that you have in mind? 


> So maybe CLOCK_MONOTONIC should be changed to include elapsed time
> during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
> for programs that want that?

No. Lets not change it. CLOCK_MONOTONIC and CLOCK_MONOTONIC_RAW's
relationship is tightly coupled, and applications that are tracking the
amount of clock adjustment being done to the system require they keep
their semantics.

As I said earlier, adding a new clockid to represent the MONOTONIC
+SUSPEND time wouldn't be difficult, we just need to be clear about why
it should be exposed, and have it also be easy to describe to developers
which clockid would suit their needs best.

thanks
-john


