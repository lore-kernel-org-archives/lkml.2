Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2GETNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:13:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58651 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab2GETNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:13:42 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Fix for leapsecond caused hrtimer/futex issue
Date: Thu,  5 Jul 2012 15:12:15 -0400
Message-Id: <1341515538-5100-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070519-2356-0000-0000-000000329E6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas:
	So Prarit and my testing over the last few days have gone fine,
and its been quiet otherwise, so I wanted to go ahead and submit this
for inclusion.

As widely reported on the internet, many Linux systems after
the leapsecond was inserted experienced futex related load
spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).

An apparent  workaround for this issue is running:
$ date -s "`date`"

Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix


This issue stemmed from the timekeeping subsystem not notifying
the hrtimer subsystem that the leapsecond occurred, causing
CLOCK_REALTIME hritmers to be fired one second early, and 
sub-second CLOCK_REALTIME hrtimer timeouts to fire immediately
(causing the load spikes).


To address this issue I'm proposing we do three things:
1) Fix the clock_was_set() call to remove the limitation that kept
us from calling it from update_wall_time().

2) Call clock_was_set() when we add/remove a leapsecond.

3) Change hrtimer_interrupt to update the hrtimer base offset values.
This third item provides additional robustness should the
clock_was_set() notification (done via a timer if we're in_atomic)
be delayed significantly.


NOTE: Some reports have been of a hard hang right at or before
the leapsecond. I've not been able to reproduce or diagnose
this, so this fix does not likely address the reported hard
hangs (unless they end up being connected to the futex/hrtimer
issue). Please email lkml and me if you experienced this.

Big thanks to Prarit for shaking out a few issues in the earlier
version of this patch set, as well as the extra effort testing over
the Holiday!

Also, I've already got backports generated for -stable, that I'm
testing and I'll submitting them once I have upstream commit ids for
these patches.

thanks
-john

CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>


John Stultz (3):
  hrtimer: Fix clock_was_set so it is safe to call from irq context
  time: Fix leapsecond triggered hrtimer/futex load spike issue
  hrtimer: Update hrtimer base offsets each hrtimer_interrupt

 include/linux/hrtimer.h   |    3 +++
 kernel/hrtimer.c          |   31 +++++++++++++++++++++++++++----
 kernel/time/timekeeping.c |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 4 deletions(-)

-- 
1.7.9.5

