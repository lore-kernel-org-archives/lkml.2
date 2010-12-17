Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0LQT4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:56:08 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:58382 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab0LQTz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:55:56 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>, "H\. Peter Anvin" <hpa@zytor.com>,
        Magnus Damm <damm@opensource.se>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCHv6 13/16] pps: capture MONOTONIC_RAW timestamps as well
Date: Fri, 17 Dec 2010 22:54:37 +0300
Message-Id: <86006999fd830711c1714c96992b8231f9c4ead0.1292604060.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MONOTONIC_RAW clock timestamps are ideally suited for frequency
calculation and also fit well into the original NTP hardpps design. Now
phase and frequency can be adjusted separately: the former based on
REALTIME clock and the latter based on MONOTONIC_RAW clock.
A new function getnstime_raw_and_real is added to timekeeping subsystem
to capture both timestamps at the same time and atomically.

Acked-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 include/linux/pps_kernel.h |    3 ++-
 include/linux/time.h       |    2 ++
 kernel/time/timekeeping.c  |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index 1aedf50..6ae8898 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -47,6 +47,7 @@ struct pps_source_info {
 };
 
 struct pps_event_time {
+	struct timespec ts_raw;
 	struct timespec ts_real;
 };
 
@@ -99,7 +100,7 @@ static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
 
 static inline void pps_get_ts(struct pps_event_time *ts)
 {
-	getnstimeofday(&ts->ts_real);
+	getnstime_raw_and_real(&ts->ts_raw, &ts->ts_real);
 }
 
 #endif /* LINUX_PPS_KERNEL_H */
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..1e6d3b5 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -158,6 +158,8 @@ extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
 extern void getrawmonotonic(struct timespec *ts);
+extern void getnstime_raw_and_real(struct timespec *ts_raw,
+		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 49010d8..f42af9d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -285,6 +285,45 @@ void ktime_get_ts(struct timespec *ts)
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
 /**
+ * getnstime_raw_and_real - get day and raw monotonic time in timespec format
+ * @ts_raw:	pointer to the timespec to be set to raw monotonic time
+ * @ts_real:	pointer to the timespec to be set to the time of day
+ *
+ * This function reads both the time of day and raw monotonic time at the
+ * same time atomically and stores the resulting timestamps in timespec
+ * format.
+ */
+void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
+{
+	unsigned long seq;
+	s64 nsecs_raw, nsecs_real;
+
+	WARN_ON_ONCE(timekeeping_suspended);
+
+	do {
+		u32 arch_offset;
+
+		seq = read_seqbegin(&xtime_lock);
+
+		*ts_raw = raw_time;
+		*ts_real = xtime;
+
+		nsecs_raw = timekeeping_get_ns_raw();
+		nsecs_real = timekeeping_get_ns();
+
+		/* If arch requires, add in gettimeoffset() */
+		arch_offset = arch_gettimeoffset();
+		nsecs_raw += arch_offset;
+		nsecs_real += arch_offset;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts_raw, nsecs_raw);
+	timespec_add_ns(ts_real, nsecs_real);
+}
+EXPORT_SYMBOL(getnstime_raw_and_real);
+
+/**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
-- 
1.7.2.3

