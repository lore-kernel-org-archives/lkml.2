Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2GQSHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:07:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53425 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab2GQSHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:07:42 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/11] 2.6.35.x: timekeeping: Provide hrtimer update function
Date: Tue, 17 Jul 2012 14:05:40 -0400
Message-Id: <1342548342-19683-10-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342548342-19683-1-git-send-email-johnstul@us.ibm.com>
References: <1342548342-19683-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071718-8974-0000-0000-00000B4069F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 include/linux/hrtimer.h   |    2 +-
 kernel/time/timekeeping.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 39d5222..568d88f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -319,7 +319,7 @@ static inline void clock_was_set_delayed(void) { }
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
-
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1f8140e..2461fe4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -976,3 +976,35 @@ struct timespec get_monotonic_coarse(void)
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
1.7.9.5

