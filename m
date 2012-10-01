Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2JAXDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:05 -0400
Received: from 1wt.eu ([62.212.114.60]:35622 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab2JAXDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:00 -0400
Message-Id: <20121001225158.294287816@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 016/180] 2.6.32.x: timekeeping: Provide hrtimer update function
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of f6c06abfb3972ad4914cef57d8348fcb2932bc3b

To finally fix the infamous leap second issue and other race windows
caused by functions which change the offsets between the various time
bases (CLOCK_MONOTONIC, CLOCK_REALTIME and CLOCK_BOOTTIME) we need a
function which atomically gets the current monotonic time and updates
the offsets of CLOCK_REALTIME and CLOCK_BOOTTIME with minimalistic
overhead. The previous patch which provides ktime_t offsets allows us
to make this function almost as cheap as ktime_get() which is going to
be replaced in hrtimer_interrupt().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/1341960205-56738-7-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/hrtimer.h   |    2 +-
 kernel/time/timekeeping.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index a7f48af..b4f0b3f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -319,7 +319,7 @@ static inline void clock_was_set_delayed(void) { }
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
-
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c7fbc9f..6054b94 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -943,3 +943,35 @@ struct timespec get_monotonic_coarse(void)
 				now.tv_nsec + mono.tv_nsec);
 	return now;
 }
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+/**
+ * ktime_get_update_offsets - hrtimer helper
+ * @real:	pointer to storage for monotonic -> realtime offset
+ *
+ * Returns current monotonic time and updates the offsets
+ * Called from hrtimer_interupt() or retrigger_next_event()
+ */
+ktime_t ktime_get_update_offsets(ktime_t *real)
+{
+	ktime_t now;
+	unsigned int seq;
+	u64 secs, nsecs;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		secs = xtime.tv_sec;
+		nsecs = xtime.tv_nsec;
+		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+
+		*real = offs_real;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
+	now = ktime_sub(now, *real);
+	return now;
+}
+#endif
-- 
1.7.2.1.45.g54fbc



