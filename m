Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab1ERVdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:33:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:54556 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1ERVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:42 -0400
Message-Id: <20110518210136.223607682@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 3/7] clockevents: Restructure clock_event_device members
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline; filename=ce-better-layout.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group the hot path members of struct clock_event_device together so we
have a better cache line footprint. Make it cacheline aligned.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

Index: linux-2.6-tip/include/linux/clockchips.h
===================================================================
--- linux-2.6-tip.orig/include/linux/clockchips.h
+++ linux-2.6-tip/include/linux/clockchips.h
@@ -56,46 +56,47 @@ enum clock_event_nofitiers {
 
 /**
  * struct clock_event_device - clock event device descriptor
- * @name:		ptr to clock event name
- * @features:		features
+ * @event_handler:	Assigned by the framework to be called by the low
+ *			level handler of the event source
+ * @set_next_event:	set next event function
+ * @next_event:		local storage for the next event in oneshot mode
  * @max_delta_ns:	maximum delta value in ns
  * @min_delta_ns:	minimum delta value in ns
  * @mult:		nanosecond to cycles multiplier
  * @shift:		nanoseconds to cycles divisor (power of two)
+ * @mode:		operating mode assigned by the management code
+ * @features:		features
+ * @retries:		number of forced programming retries
+ * @set_mode:		set mode function
+ * @broadcast:		function to broadcast events
+ * @name:		ptr to clock event name
  * @rating:		variable to rate clock event devices
  * @irq:		IRQ number (only for non CPU local devices)
  * @cpumask:		cpumask to indicate for which CPUs this device works
- * @set_next_event:	set next event function
- * @set_mode:		set mode function
- * @event_handler:	Assigned by the framework to be called by the low
- *			level handler of the event source
- * @broadcast:		function to broadcast events
  * @list:		list head for the management code
- * @mode:		operating mode assigned by the management code
- * @next_event:		local storage for the next event in oneshot mode
- * @retries:		number of forced programming retries
  */
 struct clock_event_device {
-	const char		*name;
-	unsigned int		features;
+	void			(*event_handler)(struct clock_event_device *);
+	int			(*set_next_event)(unsigned long evt,
+						  struct clock_event_device *);
+	ktime_t			next_event;
 	u64			max_delta_ns;
 	u64			min_delta_ns;
 	u32			mult;
 	u32			shift;
+	enum clock_event_mode	mode;
+	unsigned int		features;
+	unsigned long		retries;
+
+	void			(*broadcast)(const struct cpumask *mask);
+	void			(*set_mode)(enum clock_event_mode mode,
+					    struct clock_event_device *);
+	const char		*name;
 	int			rating;
 	int			irq;
 	const struct cpumask	*cpumask;
-	int			(*set_next_event)(unsigned long evt,
-						  struct clock_event_device *);
-	void			(*set_mode)(enum clock_event_mode mode,
-					    struct clock_event_device *);
-	void			(*event_handler)(struct clock_event_device *);
-	void			(*broadcast)(const struct cpumask *mask);
 	struct list_head	list;
-	enum clock_event_mode	mode;
-	ktime_t			next_event;
-	unsigned long		retries;
-};
+} ____cacheline_aligned;
 
 /*
  * Calculate a multiplication factor for scaled math, which is used to convert


