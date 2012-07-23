Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2GWB6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:58:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54219 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab2GWBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:57 -0400
Message-Id: <20120723010703.151981945@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 077/108] time: Move common updates to a function
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of cc06268c6a87db156af2daed6e96a936b955cc82

[John Stultz: While not a bugfix itself, it allows following fixes
 to backport in a more straightforward manner.]

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/timekeeping.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5c9b67e..5d55185 100644
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
 
@@ -636,10 +641,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -1052,9 +1054,7 @@ static void update_wall_time(void)
 		wall_to_monotonic.tv_sec -= leap;
 	}
 
-	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(false);
 }
 
 /**


