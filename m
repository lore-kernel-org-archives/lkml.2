Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1CNDwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 23:52:07 -0400
Received: from flusers.ccur.com ([173.221.59.2]:57972 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756786Ab1CNDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 23:51:50 -0400
Date: Sun, 13 Mar 2011 23:50:43 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] jrcu: make sampling frequency user changeable
Message-ID: <20110314035043.GA12976@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: make sampling interval user adjustable.

By default jrcu runs at 20 Hz.  The user can now change
that as shown in the below example.  Accepts any integer
between 1 and 1000, inclusive.

  echo hz=100 >/sys/kernel/debug/rcu/rcudata

This should make it easier to stress-test JRCU.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -38,12 +38,14 @@
 
 #include <linux/bug.h>
 #include <linux/smp.h>
+#include <linux/ctype.h>
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/stddef.h>
+#include <linux/string.h>
 #include <linux/preempt.h>
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
@@ -102,8 +104,6 @@ static inline void rcu_list_join(struct 
 }
 
 
-#define RCU_HZ 20		/* max rate at which batches are retired */
-
 struct rcu_data {
 	u8 wait;		/* goes false when this cpu consents to
 				 * the retirement of the current batch */
@@ -123,6 +123,14 @@ static struct rcu_stats {
 	unsigned nforced;	/* #forced eobs (should be zero) */
 } rcu_stats;
 
+#define RCU_HZ			(20)
+#define RCU_HZ_PERIOD_US	(USEC_PER_SEC / RCU_HZ)
+#define RCU_HZ_DELTA_US		(USEC_PER_SEC / (HZ * 3 / 2))
+
+int rcu_hz = RCU_HZ;
+int rcu_hz_period_us = RCU_HZ_PERIOD_US;
+int rcu_hz_delta_us = RCU_HZ_DELTA_US;
+
 int rcu_scheduler_active __read_mostly;
 int rcu_nmi_seen __read_mostly;
 static u64 rcu_timestamp;
@@ -387,11 +395,8 @@ static void rcu_delimit_batches(void)
 #include <linux/hrtimer.h>
 #include <linux/interrupt.h>
 
-#define RCU_PERIOD_NS		(NSEC_PER_SEC / RCU_HZ)
-#define RCU_PERIOD_DELTA_NS	(((NSEC_PER_SEC / HZ) * 3) / 2)
-
-#define RCU_PERIOD_MIN_NS	RCU_PERIOD_NS
-#define RCU_PERIOD_MAX_NS	(RCU_PERIOD_NS + RCU_PERIOD_DELTA_NS)
+#define rcu_hz_period_ns	(rcu_hz_period_us * NSEC_PER_USEC)
+#define rcu_hz_delta_ns		(rcu_hz_delta_us * NSEC_PER_USEC)
 
 static struct hrtimer rcu_timer;
 
@@ -406,15 +411,15 @@ static enum hrtimer_restart rcu_timer_fu
 
 	raise_softirq(RCU_SOFTIRQ);
 
-	next = ktime_add_ns(ktime_get(), RCU_PERIOD_NS);
-	hrtimer_set_expires_range_ns(&rcu_timer, next, RCU_PERIOD_DELTA_NS);
+	next = ktime_add_ns(ktime_get(), rcu_hz_period_ns);
+	hrtimer_set_expires_range_ns(&rcu_timer, next, rcu_hz_delta_ns);
 	return HRTIMER_RESTART;
 }
 
 static void rcu_timer_restart(void)
 {
 	pr_info("JRCU: starting timer. rate is %d Hz\n", RCU_HZ);
-	hrtimer_forward_now(&rcu_timer, ns_to_ktime(RCU_PERIOD_NS));
+	hrtimer_forward_now(&rcu_timer, ns_to_ktime(rcu_hz_period_ns));
 	hrtimer_start_expires(&rcu_timer, HRTIMER_MODE_ABS);
 }
 
@@ -471,9 +476,6 @@ void __init rcu_scheduler_starting(void)
 
 /* ------------------ daemon driver section --------------------- */
 
-#define RCU_PERIOD_MIN_US	(RCU_PERIOD_MIN_NS / NSEC_PER_USEC)
-#define RCU_PERIOD_MAX_US	(RCU_PERIOD_MAX_NS / NSEC_PER_USEC)
-
 /*
  * Once the system is fully up, we will drive the periodic-polling part
  * of JRCU from a kernel daemon, jrcud.  Until then it is driven by
@@ -492,7 +494,7 @@ static int jrcud_func(void *arg)
 	rcu_timer_stop();
 
 	while (!kthread_should_stop()) {
-		usleep_range(RCU_PERIOD_MIN_US, RCU_PERIOD_MAX_US);
+		usleep_range(rcu_hz_period_us, rcu_hz_period_us + rcu_hz_delta_us);
 		rcu_delimit_batches();
 	}
 
@@ -531,6 +533,8 @@ static int rcu_debugfs_show(struct seq_f
 	msecs = div_s64(sched_clock() - rcu_timestamp, NSEC_PER_MSEC);
 	raw_local_irq_enable();
 
+	seq_printf(m, "%14u: hz\n",
+		rcu_hz);
 	seq_printf(m, "%14u: #passes seen\n",
 		rcu_stats.npasses);
 	seq_printf(m, "%14u: #batches seen\n",
@@ -580,6 +584,57 @@ static int rcu_debugfs_show(struct seq_f
 	return 0;
 }
 
+static ssize_t rcu_debugfs_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *ppos)
+{
+	int i, j, c;
+	char token[32];
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (count <= 0)
+		return count;
+
+	if (!access_ok(VERIFY_READ, buffer, count))
+		return -EFAULT;
+
+	i = 0;
+	if (__get_user(c, &buffer[i++]))
+		return -EFAULT;
+
+	/* Token extractor -- first, skip leading whitepace */
+	while (c && isspace(c) && i < count) {
+		if (__get_user(c, &buffer[i++]))
+			return -EFAULT;
+	}
+
+	if (i >= count || c == 0)
+		return count;	/* all done, no more tokens */
+
+	j = 0;
+	do {
+		if (j == (sizeof(token) - 1))
+			return -EINVAL;
+		token[j++] = c;
+		if (__get_user(c, &buffer[i++]))
+			return -EFAULT;
+	} while (c && !isspace(c) && i < count); /* extract next token */
+	token[j++] = 0;
+
+	if (!strncmp(token, "hz=", 3)) {
+		int rcu_hz_wanted = -1;
+		sscanf(&token[3], "%d", &rcu_hz_wanted);
+		if (rcu_hz_wanted < 2 || rcu_hz_wanted > 1000)
+			return -EINVAL;
+		rcu_hz = rcu_hz_wanted;
+		rcu_hz_period_us = USEC_PER_SEC / rcu_hz;
+	} else
+		return -EINVAL;
+
+	return count;
+}
+
 static int rcu_debugfs_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, rcu_debugfs_show, NULL);
@@ -589,6 +644,7 @@ static const struct file_operations rcu_
 	.owner = THIS_MODULE,
 	.open = rcu_debugfs_open,
 	.read = seq_read,
+	.write = rcu_debugfs_write,
 	.llseek = seq_lseek,
 	.release = single_release,
 };
@@ -603,7 +659,7 @@ static int __init rcu_debugfs_init(void)
 	if (!rcudir)
 		goto error;
 
-	retval = debugfs_create_file("rcudata", 0444, rcudir,
+	retval = debugfs_create_file("rcudata", 0644, rcudir,
 			NULL, &rcu_debugfs_fops);
 	if (!retval)
 		goto error;
