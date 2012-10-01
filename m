Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab2JAXa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:30:26 -0400
Received: from 1wt.eu ([62.212.114.60]:35209 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab2JAXAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:41 -0400
Message-Id: <20121001225158.165039916@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 013/180] 2.6.32.x: timekeeping: Fix leapsecond triggered load spike issue
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <johnstul@us.ibm.com>

This is a backport of 4873fa070ae84a4115f0b3c9dfabc224f1bc7c51

The timekeeping code misses an update of the hrtimer subsystem after a
leap second happened. Due to that timers based on CLOCK_REALTIME are
either expiring a second early or late depending on whether a leap
second has been inserted or deleted until an operation is initiated
which causes that update. Unless the update happens by some other
means this discrepancy between the timekeeping and the hrtimer data
stays forever and timers are expired either early or late.

The reported immediate workaround - $ data -s "`date`" - is causing a
call to clock_was_set() which updates the hrtimer data structures.
See: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

Add the missing clock_was_set() call to update_wall_time() in case of
a leap second event. The actual update is deferred to softirq context
as the necessary smp function call cannot be invoked from hard
interrupt context.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-3-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/time/timekeeping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a969adf..1e9808d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -790,6 +790,8 @@ void update_wall_time(void)
 			leap = second_overflow(xtime.tv_sec);
 			xtime.tv_sec += leap;
 			wall_to_monotonic.tv_sec -= leap;
+			if (leap)
+				clock_was_set_delayed();
 		}
 
 		raw_time.tv_nsec += timekeeper.raw_interval;
-- 
1.7.2.1.45.g54fbc



