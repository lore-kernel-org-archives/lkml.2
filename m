Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2GQRgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:36:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47743 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab2GQRes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:34:48 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 04/11] 3.0.x: time: Move common updates to a function
Date: Tue, 17 Jul 2012 13:33:51 -0400
Message-Id: <1342546438-17534-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071717-5930-0000-0000-000009F4070E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of cc06268c6a87db156af2daed6e96a936b955cc82

While not a bugfix itself, it allows following fixes to backport
in a more straightforward manner.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ac5b225..0b582eb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -166,6 +166,19 @@ static struct timespec total_sleep_time;
  */
 static struct timespec raw_time;
 
+/* must hold write on xtime_lock */
+static void timekeeping_update(bool clearntp)
+{
+	if (clearntp) {
+		timekeeper.ntp_error = 0;
+		ntp_clear();
+	}
+	update_vsyscall(&xtime, &wall_to_monotonic,
+			 timekeeper.clock, timekeeper.mult);
+}
+
+
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -366,11 +379,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	xtime = *tv;
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -403,11 +412,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	xtime = timespec_add(xtime, *ts);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -630,10 +635,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -938,9 +940,7 @@ static void update_wall_time(void)
 		wall_to_monotonic.tv_sec -= leap;
 	}
 
-	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(false);
 }
 
 /**
-- 
1.7.9.5

