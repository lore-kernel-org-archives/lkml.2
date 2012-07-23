Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2GWB7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:59:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab2GWBmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:51 -0400
Message-Id: <20120723010703.935085158@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: [ 082/108] timekeeping: Provide hrtimer update function
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
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/1341960205-56738-7-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[John Stultz: Backported to 3.2]
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/hrtimer.h   |    1 +
 kernel/time/timekeeping.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index c9ec940..cc07d27 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -327,6 +327,7 @@ extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d5d0e5d..4938c5e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1240,6 +1240,40 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	} while (read_seqretry(&xtime_lock, seq));
 }
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+/**
+ * ktime_get_update_offsets - hrtimer helper
+ * @real:	pointer to storage for monotonic -> realtime offset
+ * @_boot:	pointer to storage for monotonic -> boottime offset
+ *
+ * Returns current monotonic time and updates the offsets
+ * Called from hrtimer_interupt() or retrigger_next_event()
+ */
+ktime_t ktime_get_update_offsets(ktime_t *real, ktime_t *boot)
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
+		*boot = offs_boot;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
+	now = ktime_sub(now, *real);
+	return now;
+}
+#endif
+
 /**
  * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
  */


