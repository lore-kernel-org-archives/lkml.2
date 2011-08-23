Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1HWNcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:32:09 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53618 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab1HWNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:31:51 -0400
Message-Id: <20110823133142.494157493@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 15:29:42 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/3] clockevent event minimum delay adjustments
References: <20110823132941.744407154@de.ibm.com>
Content-Disposition: inline; filename=clockevent-move-force.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The automatic increase of the min_delta_ns of a clockevents devices
should be done in the clockevents code as the minimum delay is an
attribute of the clockevents device.
In addition not all architectures want the automatic adjustment, on a
massively virtualized system it can happen that the programming of a
clock event fails several times in a row because the virtual cpu has
been rescheduled quickly enough. In that case the minimum delay will
erroneously be increased with no way back. The new config symbol
GENERIC_CLOCKEVENTS_MIN_ADJUST is used to enable the automatic
adjustment. The config option is selected only for x86.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/x86/Kconfig             |    1 
 include/linux/clockchips.h   |    2 
 kernel/time/Kconfig          |    2 
 kernel/time/clockevents.c    |  125 ++++++++++++++++++++++++++++++++++++++-----
 kernel/time/tick-broadcast.c |    4 -
 kernel/time/tick-common.c    |    4 -
 kernel/time/tick-internal.h  |    2 
 kernel/time/tick-oneshot.c   |   77 +-------------------------
 8 files changed, 123 insertions(+), 94 deletions(-)

Index: linux-clockevents/arch/x86/Kconfig
===================================================================
--- linux-clockevents.orig/arch/x86/Kconfig	2011-08-09 17:40:09.252011057 +0200
+++ linux-clockevents/arch/x86/Kconfig	2011-08-23 15:15:59.155588652 +0200
@@ -68,6 +68,7 @@
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CLOCKEVENTS_MIN_ADJUST
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
Index: linux-clockevents/include/linux/clockchips.h
===================================================================
--- linux-clockevents.orig/include/linux/clockchips.h	2011-05-20 13:13:38.365605338 +0200
+++ linux-clockevents/include/linux/clockchips.h	2011-08-23 15:15:59.159588700 +0200
@@ -140,7 +140,7 @@
 				 enum clock_event_mode mode);
 extern int clockevents_register_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
-				     ktime_t expires, ktime_t now);
+				     ktime_t expires, int force);
 
 extern void clockevents_handle_noop(struct clock_event_device *dev);
 
Index: linux-clockevents/kernel/time/Kconfig
===================================================================
--- linux-clockevents.orig/kernel/time/Kconfig	2010-08-09 17:53:26.000000000 +0200
+++ linux-clockevents/kernel/time/Kconfig	2011-08-23 15:15:59.159588700 +0200
@@ -27,3 +27,5 @@
 	default y
 	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
 
+config GENERIC_CLOCKEVENTS_MIN_ADJUST
+	bool
Index: linux-clockevents/kernel/time/clockevents.c
===================================================================
--- linux-clockevents.orig/kernel/time/clockevents.c	2011-06-08 19:17:59.275636952 +0200
+++ linux-clockevents/kernel/time/clockevents.c	2011-08-23 15:15:59.159588700 +0200
@@ -94,42 +94,139 @@
 	dev->next_event.tv64 = KTIME_MAX;
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST
+
+/* Limit min_delta to a jiffie */
+#define MIN_DELTA_LIMIT		(NSEC_PER_SEC / HZ)
+
+/**
+ * clockevents_increase_min_delta - raise minimum delta of a clock event device
+ * @dev:       device to increase the minimum delta
+ *
+ * Returns 0 on success, -ETIME when the minimum delta reached the limit.
+ */
+static int clockevents_increase_min_delta(struct clock_event_device *dev)
+{
+	/* Nothing to do if we already reached the limit */
+	if (dev->min_delta_ns >= MIN_DELTA_LIMIT) {
+		printk(KERN_WARNING "CE: Reprogramming failure. Giving up\n");
+		dev->next_event.tv64 = KTIME_MAX;
+		return -ETIME;
+	}
+
+	if (dev->min_delta_ns < 5000)
+		dev->min_delta_ns = 5000;
+	else
+		dev->min_delta_ns += dev->min_delta_ns >> 1;
+
+	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
+		dev->min_delta_ns = MIN_DELTA_LIMIT;
+
+	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
+	       dev->name ? dev->name : "?",
+	       (unsigned long long) dev->min_delta_ns);
+	return 0;
+}
+
+/**
+ * clockevents_program_min_delta - Set clock event device to the minimum delay.
+ * @dev:	device to program
+ *
+ * Returns 0 on success, -ETIME when the retry loop failed.
+ */
+static int clockevents_program_min_delta(struct clock_event_device *dev)
+{
+	unsigned long long clc;
+	int64_t delta;
+	int i;
+
+	for (i = 0;;) {
+		delta = dev->min_delta_ns;
+		dev->next_event = ktime_add_ns(ktime_get(), delta);
+
+		if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
+			return 0;
+
+		dev->retries++;
+		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+		if (dev->set_next_event((unsigned long) clc, dev) == 0)
+			return 0;
+
+		if (++i > 2) {
+			/*
+			 * We tried 3 times to program the device with the
+			 * given min_delta_ns. Try to increase the minimum
+			 * delta, if that fails as well get out of here.
+			 */
+			if (clockevents_increase_min_delta(dev))
+				return -ETIME;
+			i = 0;
+		}
+	}
+}
+
+#else  /* CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST */
+
+/**
+ * clockevents_program_min_delta - Set clock event device to the minimum delay.
+ * @dev:	device to program
+ *
+ * Returns 0 on success, -ETIME when the retry loop failed.
+ */
+static int clockevents_program_min_delta(struct clock_event_device *dev)
+{
+	unsigned long long clc;
+	int64_t delta;
+
+	delta = dev->min_delta_ns;
+	dev->next_event = ktime_add_ns(ktime_get(), delta);
+
+	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
+		return 0;
+
+	dev->retries++;
+	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+	return dev->set_next_event((unsigned long) clc, dev);
+}
+
+#endif /* CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST */
+
 /**
  * clockevents_program_event - Reprogram the clock event device.
+ * @dev:	device to program
  * @expires:	absolute expiry time (monotonic clock)
+ * @force:	program minimum delay if expires can not be set
  *
  * Returns 0 on success, -ETIME when the event is in the past.
  */
 int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
-			      ktime_t now)
+			      int force)
 {
 	unsigned long long clc;
 	int64_t delta;
+	int rc;
 
 	if (unlikely(expires.tv64 < 0)) {
 		WARN_ON_ONCE(1);
 		return -ETIME;
 	}
 
-	delta = ktime_to_ns(ktime_sub(expires, now));
-
-	if (delta <= 0)
-		return -ETIME;
-
 	dev->next_event = expires;
 
 	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
 		return 0;
 
-	if (delta > dev->max_delta_ns)
-		delta = dev->max_delta_ns;
-	if (delta < dev->min_delta_ns)
-		delta = dev->min_delta_ns;
+	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
+	if (delta <= 0)
+		return force ? clockevents_program_min_delta(dev) : -ETIME;
 
-	clc = delta * dev->mult;
-	clc >>= dev->shift;
+	delta = min(delta, (int64_t) dev->max_delta_ns);
+	delta = max(delta, (int64_t) dev->min_delta_ns);
 
-	return dev->set_next_event((unsigned long) clc, dev);
+	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+	rc = dev->set_next_event((unsigned long) clc, dev);
+
+	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
 }
 
 /**
@@ -258,7 +355,7 @@
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
 		return 0;
 
-	return clockevents_program_event(dev, dev->next_event, ktime_get());
+	return clockevents_program_event(dev, dev->next_event, 0);
 }
 
 /*
Index: linux-clockevents/kernel/time/tick-broadcast.c
===================================================================
--- linux-clockevents.orig/kernel/time/tick-broadcast.c	2011-05-24 13:02:20.066640590 +0200
+++ linux-clockevents/kernel/time/tick-broadcast.c	2011-08-23 15:15:59.159588700 +0200
@@ -194,7 +194,7 @@
 	for (next = dev->next_event; ;) {
 		next = ktime_add(next, tick_period);
 
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, 0))
 			return;
 		tick_do_periodic_broadcast();
 	}
@@ -373,7 +373,7 @@
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 
-	return tick_dev_program_event(bc, expires, force);
+	return clockevents_program_event(bc, expires, force);
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
Index: linux-clockevents/kernel/time/tick-common.c
===================================================================
--- linux-clockevents.orig/kernel/time/tick-common.c	2011-03-16 09:26:42.994913981 +0100
+++ linux-clockevents/kernel/time/tick-common.c	2011-08-23 15:15:59.159588700 +0200
@@ -94,7 +94,7 @@
 	 */
 	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, 0))
 			return;
 		/*
 		 * Have to be careful here. If we're in oneshot mode,
@@ -137,7 +137,7 @@
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
 		for (;;) {
-			if (!clockevents_program_event(dev, next, ktime_get()))
+			if (!clockevents_program_event(dev, next, 0))
 				return;
 			next = ktime_add(next, tick_period);
 		}
Index: linux-clockevents/kernel/time/tick-internal.h
===================================================================
--- linux-clockevents.orig/kernel/time/tick-internal.h	2011-03-16 09:26:42.994913981 +0100
+++ linux-clockevents/kernel/time/tick-internal.h	2011-08-23 15:15:59.159588700 +0200
@@ -26,8 +26,6 @@
 extern void tick_setup_oneshot(struct clock_event_device *newdev,
 			       void (*handler)(struct clock_event_device *),
 			       ktime_t nextevt);
-extern int tick_dev_program_event(struct clock_event_device *dev,
-				  ktime_t expires, int force);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
Index: linux-clockevents/kernel/time/tick-oneshot.c
===================================================================
--- linux-clockevents.orig/kernel/time/tick-oneshot.c	2011-03-16 09:26:42.994913981 +0100
+++ linux-clockevents/kernel/time/tick-oneshot.c	2011-08-23 15:15:59.159588700 +0200
@@ -21,74 +21,6 @@
 
 #include "tick-internal.h"
 
-/* Limit min_delta to a jiffie */
-#define MIN_DELTA_LIMIT		(NSEC_PER_SEC / HZ)
-
-static int tick_increase_min_delta(struct clock_event_device *dev)
-{
-	/* Nothing to do if we already reached the limit */
-	if (dev->min_delta_ns >= MIN_DELTA_LIMIT)
-		return -ETIME;
-
-	if (dev->min_delta_ns < 5000)
-		dev->min_delta_ns = 5000;
-	else
-		dev->min_delta_ns += dev->min_delta_ns >> 1;
-
-	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
-		dev->min_delta_ns = MIN_DELTA_LIMIT;
-
-	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
-	       dev->name ? dev->name : "?",
-	       (unsigned long long) dev->min_delta_ns);
-	return 0;
-}
-
-/**
- * tick_program_event internal worker function
- */
-int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
-			   int force)
-{
-	ktime_t now = ktime_get();
-	int i;
-
-	for (i = 0;;) {
-		int ret = clockevents_program_event(dev, expires, now);
-
-		if (!ret || !force)
-			return ret;
-
-		dev->retries++;
-		/*
-		 * We tried 3 times to program the device with the given
-		 * min_delta_ns. If that's not working then we increase it
-		 * and emit a warning.
-		 */
-		if (++i > 2) {
-			/* Increase the min. delta and try again */
-			if (tick_increase_min_delta(dev)) {
-				/*
-				 * Get out of the loop if min_delta_ns
-				 * hit the limit already. That's
-				 * better than staying here forever.
-				 *
-				 * We clear next_event so we have a
-				 * chance that the box survives.
-				 */
-				printk(KERN_WARNING
-				       "CE: Reprogramming failure. Giving up\n");
-				dev->next_event.tv64 = KTIME_MAX;
-				return -ETIME;
-			}
-			i = 0;
-		}
-
-		now = ktime_get();
-		expires = ktime_add_ns(now, dev->min_delta_ns);
-	}
-}
-
 /**
  * tick_program_event
  */
@@ -96,7 +28,7 @@
 {
 	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
-	return tick_dev_program_event(dev, expires, force);
+	return clockevents_program_event(dev, expires, force);
 }
 
 /**
@@ -104,11 +36,10 @@
  */
 void tick_resume_oneshot(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	struct clock_event_device *dev = td->evtdev;
+	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-	tick_program_event(ktime_get(), 1);
+	clockevents_program_event(dev, ktime_get(), 1);
 }
 
 /**
@@ -120,7 +51,7 @@
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	tick_dev_program_event(newdev, next_event, 1);
+	clockevents_program_event(newdev, next_event, 1);
 }
 
 /**

