Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1HWNcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:32:50 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:51722 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab1HWNcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:32:01 -0400
Message-Id: <20110823133142.815350967@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 15:29:43 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/3] direct ktime path for clockevent devices
References: <20110823132941.744407154@de.ibm.com>
Content-Disposition: inline; filename=clockevent-feat-ktime.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

There is at least one architecture (s390) with a sane clockevent device
that can be programmed with the equivalent of a ktime. No need to create
a delta against the current time, the ktime can be used directly.

A new clock device function 'set_next_ktime' is introduced that is called
with the unmodified ktime for the timer if the clock event device has the 
CLOCK_EVT_FEAT_KTIME bit set.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clockchips.h |   10 +++++++---
 kernel/time/clockevents.c  |    4 ++++
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-clockevents/include/linux/clockchips.h
===================================================================
--- linux-clockevents.orig/include/linux/clockchips.h	2011-08-23 15:15:59.159588700 +0200
+++ linux-clockevents/include/linux/clockchips.h	2011-08-23 15:16:02.327629024 +0200
@@ -45,20 +45,22 @@
  */
 #define CLOCK_EVT_FEAT_PERIODIC		0x000001
 #define CLOCK_EVT_FEAT_ONESHOT		0x000002
+#define CLOCK_EVT_FEAT_KTIME		0x000004
 /*
  * x86(64) specific misfeatures:
  *
  * - Clockevent source stops in C3 State and needs broadcast support.
  * - Local APIC timer is used as a dummy device.
  */
-#define CLOCK_EVT_FEAT_C3STOP		0x000004
-#define CLOCK_EVT_FEAT_DUMMY		0x000008
+#define CLOCK_EVT_FEAT_C3STOP		0x000008
+#define CLOCK_EVT_FEAT_DUMMY		0x000010
 
 /**
  * struct clock_event_device - clock event device descriptor
  * @event_handler:	Assigned by the framework to be called by the low
  *			level handler of the event source
- * @set_next_event:	set next event function
+ * @set_next_event:	set next event function using a clocksource delta
+ * @set_next_ktime:	set next event function using a direct ktime value
  * @next_event:		local storage for the next event in oneshot mode
  * @max_delta_ns:	maximum delta value in ns
  * @min_delta_ns:	minimum delta value in ns
@@ -81,6 +83,8 @@
 	void			(*event_handler)(struct clock_event_device *);
 	int			(*set_next_event)(unsigned long evt,
 						  struct clock_event_device *);
+	int			(*set_next_ktime)(ktime_t expires,
+						  struct clock_event_device *);
 	ktime_t			next_event;
 	u64			max_delta_ns;
 	u64			min_delta_ns;
Index: linux-clockevents/kernel/time/clockevents.c
===================================================================
--- linux-clockevents.orig/kernel/time/clockevents.c	2011-08-23 15:15:59.159588700 +0200
+++ linux-clockevents/kernel/time/clockevents.c	2011-08-23 15:16:02.327629024 +0200
@@ -216,6 +216,10 @@
 	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
 		return 0;
 
+	/* Shortcut for clockevent devices that can deal with ktime. */
+	if (dev->features & CLOCK_EVT_FEAT_KTIME)
+		return dev->set_next_ktime(expires, dev);
+
 	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
 	if (delta <= 0)
 		return force ? clockevents_program_min_delta(dev) : -ETIME;

