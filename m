Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2LRMIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:08:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44751 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2LRMIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:08:19 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, nico@linaro.org, will.deacon@arm.com,
        marc.zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 4/5] clockevents: Add generic timer broadcast function
Date: Tue, 18 Dec 2012 12:06:57 +0000
Message-Id: <1355832418-31692-5-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 18 Dec 2012 12:08:09.0062 (UTC) FILETIME=[58195060:01CDDD18]
X-MC-Unique: 112121812081102901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBIC8Nrf018317

Currently, the timer broadcast mechanism is defined by a function
pointer on struct clock_event_device. As the fundamental mechanism for
broadcast is architecture-specific, this means that clock_event_device
drivers cannot be shared across multiple architectures.

This patch adds an (optional) architecture-specific function for timer
tick broadcast, allowing drivers which may require broadcast
functionality to be shared across multiple architectures.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 include/linux/clockchips.h   |    5 +++++
 kernel/time/Kconfig          |    4 ++++
 kernel/time/tick-broadcast.c |   15 +++++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index e1089aa..6634652 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -162,6 +162,11 @@ extern void clockevents_suspend(void);
 extern void clockevents_resume(void);
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+#ifdef CONFIG_ARCH_HAS_TICK_BROADCAST
+extern void tick_broadcast(const struct cpumask *mask);
+#else
+#define tick_broadcast	NULL
+#endif
 extern int tick_receive_broadcast(void);
 #endif
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 8601f0d..b696922 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -38,6 +38,10 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS
 
+# Architecture can handle broadcast in a driver-agnostic way
+config ARCH_HAS_TICK_BROADCAST
+	bool
+
 # Clockevents broadcasting infrastructure
 config GENERIC_CLOCKEVENTS_BROADCAST
 	bool
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index c2dd022..ec22a80 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/smp.h>
 
 #include "tick-internal.h"
 
@@ -86,6 +87,12 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
 	return (dev && tick_broadcast_device.evtdev == dev);
 }
 
+static void err_broadcast(const struct cpumask *mask)
+{
+	pr_crit_once("Attempted to broadcast tick, but no broadcast mechanism "
+		     "present. Some CPUs may be unresponsive.");
+}
+
 /*
  * Check, if the device is disfunctional and a place holder, which
  * needs to be handled by the broadcast device.
@@ -105,6 +112,14 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
+		if (!dev->broadcast)
+			dev->broadcast = tick_broadcast;
+		if (!dev->broadcast) {
+			pr_warn_once("%s depends on broadcast, but no "
+				     "broadcast function available\n",
+				     dev->name);
+			dev->broadcast = err_broadcast;
+		}
 		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
-- 
1.7.0.4


