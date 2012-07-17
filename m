Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2GQWFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:05:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41936 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab2GQWFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:05:48 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 04/11] 2.6.32.x: time: Move common updates to a function
Date: Tue, 17 Jul 2012 18:05:28 -0400
Message-Id: <1342562735-55870-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com>
References: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071722-7182-0000-0000-000002025A76
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
 kernel/time/timekeeping.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6d19a00..a969adf 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -166,6 +166,18 @@ static struct timespec total_sleep_time;
  */
 struct timespec raw_time;
 
+/* must hold write on xtime_lock */
+static void timekeeping_update(bool clearntp)
+{
+	if (clearntp) {
+		timekeeper.ntp_error = 0;
+		ntp_clear();
+	}
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+}
+
+
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -341,10 +353,7 @@ int do_settimeofday(struct timespec *tv)
 
 	update_xtime_cache(0);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -832,8 +841,7 @@ void update_wall_time(void)
 	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
 	update_xtime_cache(nsecs);
 
-	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	timekeeping_update(false);
 }
 
 /**
-- 
1.7.9.5

