Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2GJWnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:43:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47204 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2GJWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:48 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH 2/6] timekeeping: Fix leapsecond triggered load spike issue
Date: Tue, 10 Jul 2012 18:43:20 -0400
Message-Id: <1341960205-56738-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-7282-0000-0000-00000AC95BC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6f46a00..a413e59 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -963,6 +963,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	/* Accumulate raw time */
@@ -1079,6 +1081,8 @@ static void update_wall_time(void)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	timekeeping_update(false);
-- 
1.7.9.5

