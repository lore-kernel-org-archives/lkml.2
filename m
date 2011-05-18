Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1ERVew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:34:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:54560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1ERVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:42 -0400
Message-Id: <20110518210136.331975870@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 4/7] clockevents: Provide combined configure and register
 function
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline; filename=ce-add-register-if.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All clockevent devices have the same open coded initialization
functions. Provide an interface which does all necessary
initialization in the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h |    9 +++++++++
 kernel/time/clockevents.c  |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

Index: linux-2.6-tip/include/linux/clockchips.h
===================================================================
--- linux-2.6-tip.orig/include/linux/clockchips.h
+++ linux-2.6-tip/include/linux/clockchips.h
@@ -69,6 +69,8 @@ enum clock_event_nofitiers {
  * @retries:		number of forced programming retries
  * @set_mode:		set mode function
  * @broadcast:		function to broadcast events
+ * @min_delta_ticks:	minimum delta value in ticks stored for reconfiguration
+ * @max_delta_ticks:	maximum delta value in ticks stored for reconfiguration
  * @name:		ptr to clock event name
  * @rating:		variable to rate clock event devices
  * @irq:		IRQ number (only for non CPU local devices)
@@ -91,6 +93,9 @@ struct clock_event_device {
 	void			(*broadcast)(const struct cpumask *mask);
 	void			(*set_mode)(enum clock_event_mode mode,
 					    struct clock_event_device *);
+	unsigned long		min_delta_ticks;
+	unsigned long		max_delta_ticks;
+
 	const char		*name;
 	int			rating;
 	int			irq;
@@ -123,6 +128,10 @@ extern u64 clockevent_delta2ns(unsigned 
 			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
+extern void clockevents_config_and_register(struct clock_event_device *dev,
+					    u32 freq, unsigned long min_delta,
+					    unsigned long max_delta);
+
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
 extern void clockevents_set_mode(struct clock_event_device *dev,
Index: linux-2.6-tip/kernel/time/clockevents.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/clockevents.c
+++ linux-2.6-tip/kernel/time/clockevents.c
@@ -194,6 +194,50 @@ void clockevents_register_device(struct 
 }
 EXPORT_SYMBOL_GPL(clockevents_register_device);
 
+static void clockevents_config(struct clock_event_device *dev,
+			       u32 freq)
+{
+	unsigned long sec;
+
+	if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return;
+
+	/*
+	 * Calculate the maximum number of seconds we can sleep. Limit
+	 * to 10 minutes for hardware which can program more than
+	 * 32bit ticks so we still get reasonable conversion values.
+	 */
+	sec = dev->max_delta_ticks;
+	do_div(sec, freq);
+	if (!sec)
+		sec = 1;
+	else if (sec > 600 && dev->max_delta_ticks > UINT_MAX)
+		sec = 600;
+
+	clockevents_calc_mult_shift(dev, freq, sec);
+	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
+	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
+}
+
+/**
+ * clockevents_config_and_register - Configure and register a clock event device
+ * @dev:	device to register
+ * @freq:	The clock frequency
+ * @min_delta:	The minimum clock ticks to program in oneshot mode
+ * @max_delta:	The maximum clock ticks to program in oneshot mode
+ *
+ * min/max_delta can be 0 for devices which do not support oneshot mode.
+ */
+void clockevents_config_and_register(struct clock_event_device *dev,
+				     u32 freq, unsigned long min_delta,
+				     unsigned long max_delta)
+{
+	dev->min_delta_ticks = min_delta;
+	dev->max_delta_ticks = max_delta;
+	clockevents_config(dev, freq);
+	clockevents_register_device(dev);
+}
+
 /*
  * Noop handler when we shut down an event device
  */


