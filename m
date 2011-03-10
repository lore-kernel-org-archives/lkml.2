Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1CJV6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:58:09 -0500
Received: from www.tglx.de ([62.245.132.106]:33144 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1CJV6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:58:08 -0500
Date: Thu, 10 Mar 2011 22:57:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shishkin <virtuoso@slind.org>
cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
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
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
In-Reply-To: <20110310141241.GE11410@shisha.kicks-ass.net>
Message-ID: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <alpine.LFD.2.00.1103101014260.2787@localhost6.localdomain6> <20110310141241.GE11410@shisha.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Alexander Shishkin wrote:
> On Thu, Mar 10, 2011 at 10:52:18AM +0100, Thomas Gleixner wrote:
> Sure. The time daemon that we have here has to stop automatic time updates
> when some other program changes system time *and* keep that setting
> effective. Currently, when "the other program" changes the system time
> right before time daemon changes it, this time setting will be overwritten
> and lost. I'm thinking that it could be solved with something like
> 
>   clock_swaptime(clockid, new_timespec, old_timespec);
> 
> but something tells me that it will not be welcome either.

Aside of that it wont work. You don't have a reference what
old_timespec means.

The whole problem space is full of race conditions and always will be
a horrible hackery when we try to piggy pack on clock_was_set() as we
have no idea what and when it actually happened. clock_was_set() is
async. While we can somehow get an event on a counter which tells us
that the clock was set, any attempt to return useful information aside
of the fact that the counter changed is going to be inconsistent one
way or the other.

It really takes some more to make this consistent for all the use
cases which are interested in notifications and unconditional timer
cancellation when the underlying clock was set.

After twisting my brain around the corner cases for a while I think
the only feasible approach to avoid all the lurking races is to:

1) Provide a syscall which returns the current offset of
   CLOCK_REALTIME vs. CLOCK_MONOTONIC. That offset is changed when
   CLOCK_REALTIME is set.

2) Provide a mechanism to check consistently the CLOCK_REALTIME
   vs. CLOCK_MONOTONIC offset and notify about changes.

3) Extend the clock_nanosleep() flags with TIMER_CANCEL_ON_CLOCK_SET

   When the flag is set, then the rmtp pointer, which is currently
   used to copy the remaining time to user space must contain a valid
   pointer to the previously retrieved CLOCK_REALTIME offset.

   clock_nanosleep() then checks that user space provided offset under
   #2 and hooks the caller into the notification mechanism. If the
   offset has changed before the timer is enqueued the syscall returns
   immediately with an appropriate error code. If the offset changes
   after the check, then an eventually enqueued timer will be
   cancelled and an appropriate error code returned.

   Note: This wont work for signal based timers as we have no sane way
   to notify user space about a forced cancellation of the timer. Even
   if we could think about some extra signal for this, it's not worth
   the trouble and the mess it's going to create.

4) Extend timerfd_settime() as #3 if necessary

   I'd prefer to avoid that, but I can see the charm of the poll
   facility which is provided by timerfd.

   Again we could reuse the omtr pointer of timerfd_settime() to
   provide the offset as an incoming parameter when the corresponing
   flag is set and basically do the same thing as clock_nanosleep() in
   the setup path - check the offset consistently.

   It needs some thought on the return values from poll and how to
   handle read, but that's a solvable problem as we can reasonably
   restrict this functionality to non self rearming timers.

That should solve the most urgent problem of cron alike battery
wasters. It also should be a reasonable notification mechanism for
others who are just interested in the fact that clock was set as those
can simply arm a timer which expires somewhere in the next decade. If
clock is not set within that time frame then battery life wont suffer
from that once in a decade regular timer expiry wakeup.

It's not going to solve the "stop updating time when something else
set the clock" requirement, but as I argued before there is no point
to even think about that at all.

Thanks,

	tglx
