Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab2GCCRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:17:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57711 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab2GCCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:17:03 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3][RFC] Potential fix for leapsecond caused futex issue (v3)
Date: Mon,  2 Jul 2012 22:16:03 -0400
Message-Id: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070302-7606-0000-0000-000001AE9F9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As widely reported on the internet, many Linux systems after
the leapsecond was inserted are experiencing futex related load
spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).

An apparent  workaround for this issue is running:
$ date -s "`date`"

Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix


To address this issue I'm proposing we do three things:
1) Fix the clock_was_set() call to remove the limitation that kept
us from calling it from update_wall_time().

2) Call clock_was_set() when we add/remove a leapsecond.

3) Change hrtimer_interrupt to update the hrtimer base offset values.
This third item provides additional robustness should the
clock_was_set() notification (done via a timer if we're in_atomic)
be delayed significantly.


This third item is new and tries to better address the fact that
the hrtimer code caches its sense of time separately from the
timekeeping core. This is necessary for performance reasons, as
hrtimer code is a very hot path, but opens up races between when
the time offsets have changed and when the hrtimer code updates
its bases on each cpu. By updating the base offsets prior to
doing any expiration, we ensure no timers are expired early.

Close review, however, would be appreciated.

I'm fairly happy with this set of changes, so if there's no
objections, I'd propose merging these for 3.5, and I'll
start generating backports for -stable (unfortunately
these won't apply trivially to 3.3 and prior kernels).

I'm also looking to see if we can consolidate the per-cpu base
offset values, so they are not per-cpu and are protected by their
own lock, allowing us to update them quickly from atomic context, 
even while holding the timekeeper.lock (currently I believe there's
the risk of having an ABBA deadlock between the base.lock and the
timekeeper.lock if we try to update the base offsets under
the timekeepr lock). However this will be potentially a more
significant change and wouldn't be appropriate for backporting,
so I want to get these three changes to fix the issue merged first.


NOTE: Some reports have been of a hard hang right at or before
the leapsecond. I've not been able to reproduce or diagnose
this, so this fix does not likely address the reported hard
hangs (unless they end up being connected to the futex/hrtimer
issue). Please email lkml and me if you experienced this.


TODOs:
* Collect feedback & acks
* Submit for merging.
* Generate a backports for pre-v3.4 kernels


v2:
* Address the issue w/ calling clock_was_set from atomic context,
pointed out by Prarit and Ben.
* Rework fix so its simpler.

v3:
* Change from using a work item to a timer for scheduling the
do_clock_was_set() call sooner.
* Add hrtimer_interrupt base offset updating



CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>

John Stultz (3):
  [RFC] hrtimer: Fix clock_was_set so it is safe to call from atomic
  [RFC] time: Fix leapsecond triggered hrtimer/futex load spike issue
  [RFC] hrtimer: Update hrtimer base offsets each hrtimer_interrupt

 include/linux/hrtimer.h   |    3 +++
 kernel/hrtimer.c          |   33 +++++++++++++++++++++++++++++----
 kernel/time/timekeeping.c |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 4 deletions(-)

-- 
1.7.9.5

