Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2G2OMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 10:12:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab2G2OMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 10:12:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 3/6] timekeeping: Add suspend and resume of clock event devices
Date: Sun, 29 Jul 2012 16:15:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl>
In-Reply-To: <201207291612.43138.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207291615.10354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some clock event devices, for example such that belong to PM domains,
need to be handled in a spcial way during the timekeeping suspend
and resume (which takes place in the system core, or "syscore",
stages of system power transitions) in analogy with clock sources.

Introduce .suspend() and .resume() callbacks for clock event devices
that will be executed by timekeeping_suspend/_resume(), respectively,
next the the clock sources' .suspend() and .resume() callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/clockchips.h |    5 +++++
 kernel/time/clockevents.c  |   24 ++++++++++++++++++++++++
 kernel/time/timekeeping.c  |    2 ++
 3 files changed, 31 insertions(+)

Index: linux/include/linux/clockchips.h
===================================================================
--- linux.orig/include/linux/clockchips.h
+++ linux/include/linux/clockchips.h
@@ -97,6 +97,8 @@ struct clock_event_device {
 	void			(*broadcast)(const struct cpumask *mask);
 	void			(*set_mode)(enum clock_event_mode mode,
 					    struct clock_event_device *);
+	void			(*suspend)(struct clock_event_device *);
+	void			(*resume)(struct clock_event_device *);
 	unsigned long		min_delta_ticks;
 	unsigned long		max_delta_ticks;
 
@@ -156,6 +158,9 @@ clockevents_calc_mult_shift(struct clock
 				      freq, minsec);
 }
 
+extern void clockevents_suspend(void);
+extern void clockevents_resume(void);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
Index: linux/kernel/time/clockevents.c
===================================================================
--- linux.orig/kernel/time/clockevents.c
+++ linux/kernel/time/clockevents.c
@@ -397,6 +397,30 @@ void clockevents_exchange_device(struct
 	local_irq_restore(flags);
 }
 
+/**
+ * clockevents_suspend - suspend clock devices
+ */
+void clockevents_suspend(void)
+{
+	struct clock_event_device *dev;
+
+	list_for_each_entry_reverse(dev, &clockevent_devices, list)
+		if (dev->suspend)
+			dev->suspend(dev);
+}
+
+/**
+ * clockevents_resume - resume clock devices
+ */
+void clockevents_resume(void)
+{
+	struct clock_event_device *dev;
+
+	list_for_each_entry(dev, &clockevent_devices, list)
+		if (dev->resume)
+			dev->resume(dev);
+}
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
Index: linux/kernel/time/timekeeping.c
===================================================================
--- linux.orig/kernel/time/timekeeping.c
+++ linux/kernel/time/timekeeping.c
@@ -733,6 +733,7 @@ static void timekeeping_resume(void)
 
 	read_persistent_clock(&ts);
 
+	clockevents_resume();
 	clocksource_resume();
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
@@ -791,6 +792,7 @@ static int timekeeping_suspend(void)
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
+	clockevents_suspend();
 
 	return 0;
 }

