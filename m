Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3AIOrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:47:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45690 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3AIOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:47:22 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, nico@linaro.org,
        will.deacon@arm.com, marc.zyngier@arm.com, john.stultz@linaro.org,
        mark.rutland@arm.com
Subject: [PATCHv2 3/4] clockevents: Add generic timer broadcast function
Date: Wed,  9 Jan 2013 14:46:09 +0000
Message-Id: <1357742770-15028-4-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 09 Jan 2013 14:47:18.0462 (UTC) FILETIME=[39129DE0:01CDEE78]
X-MC-Unique: 113010914472012501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r09ElRw3006484

Currently, the timer broadcast mechanism is defined by a function
pointer on struct clock_event_device. As the fundamental mechanism for
broadcast is architecture-specific, this means that clock_event_device
drivers cannot be shared across multiple architectures.

This patch adds an (optional) architecture-specific function for timer
tick broadcast, allowing drivers which may require broadcast
functionality to be shared across multiple architectures.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/clockchips.h   |    5 +++++
 kernel/time/Kconfig          |    4 ++++
 kernel/time/tick-broadcast.c |   13 +++++++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 6537114..921568b 100644
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
 #else
 static inline int tick_receive_broadcast(void)
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
index 5079bb7..b8aa122 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/smp.h>
 
 #include "tick-internal.h"
 
@@ -86,6 +87,11 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
 	return (dev && tick_broadcast_device.evtdev == dev);
 }
 
+static void err_broadcast(const struct cpumask *mask)
+{
+	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
+}
+
 /*
  * Check, if the device is disfunctional and a place holder, which
  * needs to be handled by the broadcast device.
@@ -105,6 +111,13 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
+		if (!dev->broadcast)
+			dev->broadcast = tick_broadcast;
+		if (!dev->broadcast) {
+			pr_warn_once("%s depends on broadcast, but no broadcast function available\n",
+				     dev->name);
+			dev->broadcast = err_broadcast;
+		}
 		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
-- 
1.7.0.4


