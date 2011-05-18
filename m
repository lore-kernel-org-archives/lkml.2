Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1ERVec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:34:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:54568 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1ERVdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:43 -0400
Message-Id: <20110518210136.437459958@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 5/7] clockevents: Provide interface to reconfigure an active
 clock event device
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline;
 filename=re-arm-twd-adjust-localtimer-frequency-withcpufreqnotifiers.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ARM SoCs have clock event devices which have their frequency
modified due to frequency scaling. Provide an interface which allows
to reconfigure an active device. After reconfiguration reprogram the
current pending event.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h |    2 ++
 kernel/time/clockevents.c  |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

Index: linux-2.6-tip/include/linux/clockchips.h
===================================================================
--- linux-2.6-tip.orig/include/linux/clockchips.h
+++ linux-2.6-tip/include/linux/clockchips.h
@@ -132,6 +132,8 @@ extern void clockevents_config_and_regis
 					    u32 freq, unsigned long min_delta,
 					    unsigned long max_delta);
 
+extern int clockevents_reconfigure(struct clock_event_device *ce, u32 freq);
+
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
 extern void clockevents_set_mode(struct clock_event_device *dev,
Index: linux-2.6-tip/kernel/time/clockevents.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/clockevents.c
+++ linux-2.6-tip/kernel/time/clockevents.c
@@ -238,6 +238,26 @@ void clockevents_config_and_register(str
 	clockevents_register_device(dev);
 }
 
+/**
+ * clockevents_reconfigure - Reconfigure and reprogram a clock event device.
+ * @dev:	device to modify
+ * @freq:	new device frequency
+ *
+ * Reconfigure and reprogram a clock event device in oneshot
+ * mode. Must be called on the cpu for which the device delivers per
+ * cpu timer events with interrupts disabled!  Returns 0 on success,
+ * -ETIME when the event is in the past.
+ */
+int clockevents_reconfigure(struct clock_event_device *dev, u32 freq)
+{
+	clockevents_config(dev, freq);
+
+	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
+		return 0;
+
+	return clockevents_program_event(dev, dev->next_event, ktime_get());
+}
+
 /*
  * Noop handler when we shut down an event device
  */


