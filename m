Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1LUVSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:18:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1LUVSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:18:20 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        avi@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/5] softlockup, sched: convert softlockup to real-time timestamping
Date: Wed, 21 Dec 2011 16:17:40 -0500
Message-Id: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the touch_softlockup_watchdog code just delays the setting of the
timestamp until the timer thread is run.  This causes the softlockup timer
to be unarmed for a brief period until the timer runs and re-arms the
watchdog.

It seems some workloads are affected by this, namely Anton's test code
that disables interrupts and idles the cpu on ppc.  By switching to a
model where we timestamp as soon as we are called in
touch_softlockup_watchdog(), we can trigger a little sooner and in
more cases.

The flip side, is there is some extra overhead to calculating the 
time at the touch.  Normally this shouldn't be an issue, because most
cases, any code touching the watchdog already believes it is in a
slow path.  This is not true for the scheduler.

The scheduler at any time can take large jumps of time (ie suspend/resume,
kgdb, virt guest pause/restart) and therefore needs to touch the watchdog
to prevent from falsely firing at almost every tick.

I noticed that the touch_softlockup_watchdog was being called very
frequently in the scheduler.  So the first two patches are an attempt
to minimize them from being called a million times/sec to zero under
normal circumstances.

The last patch removes a long standing hack that should be satisified
with the new changes (untested though).

I tested these patches through suspend/resume, a kvm guest and using
lkdtm (softlockup).  Everything seems to work as it did before.

Anton Blanchard (2):
  watchdog: Remove touch_all_softlockup_watchdogs
  watchdog: Softlockup has regular windows where it is not armed

Don Zickus (3):
  sched: Minimize the number of touch_softlockup_watchdogs
  time: Minimize number of touch_softlockup_watchdog
  kgdb, softlockup:  Remove touch_softlockup_watchdog_sync

 include/linux/sched.h     |    8 --------
 kernel/debug/debug_core.c |    2 +-
 kernel/sched/clock.c      |    3 ++-
 kernel/sched/core.c       |    2 +-
 kernel/time/tick-sched.c  |    7 ++-----
 kernel/watchdog.c         |   37 ++-----------------------------------
 6 files changed, 8 insertions(+), 51 deletions(-)

-- 
1.7.7.4

