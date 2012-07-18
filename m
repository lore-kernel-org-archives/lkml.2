Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab2GRAO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:14:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2GRANP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:13:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 16/23] time: Move common updates to a function
Date: Tue, 17 Jul 2012 17:12:09 -0700
Message-Id: <20120717232330.584010234@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of cc06268c6a87db156af2daed6e96a936b955cc82

While not a bugfix itself, it allows following fixes to backport
in a more straightforward manner.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

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
 
@@ -366,11 +379,7 @@ int do_settimeofday(const struct timespe
 
 	xtime = *tv;
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -403,11 +412,7 @@ int timekeeping_inject_offset(struct tim
 	xtime = timespec_add(xtime, *ts);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -630,10 +635,7 @@ void timekeeping_inject_sleeptime(struct
 
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


