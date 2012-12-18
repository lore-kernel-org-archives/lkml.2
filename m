Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2LRMHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:07:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40911 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2LRMHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:07:44 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, nico@linaro.org, will.deacon@arm.com,
        marc.zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 2/5] clockevents: Add generic timer broadcast receiver
Date: Tue, 18 Dec 2012 12:06:55 +0000
Message-Id: <1355832418-31692-3-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 18 Dec 2012 12:07:34.0328 (UTC) FILETIME=[43655380:01CDDD18]
X-MC-Unique: 112121812074221701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBIC7sWm018309

Currently the broadcast mechanism used for timers is abstracted by a
function pointer on struct clock_event_device. As the fundamental
mechanism for broadcast is architecture-specific, this ties each
clock_event_device driver to a single architecture, even where the
driver is otherwise generic.

This patch adds a standard path for the receipt of timer broadcasts, so
drivers and/or architecture backends need not manage redundant lists of
timers for the purpose of routing broadcast timer ticks.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 include/linux/clockchips.h   |    4 ++++
 kernel/time/tick-broadcast.c |   15 +++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 8a7096f..e1089aa 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -161,6 +161,10 @@ clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
 extern void clockevents_suspend(void);
 extern void clockevents_resume(void);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+extern int tick_receive_broadcast(void);
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..c2dd022 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -125,6 +125,21 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	return ret;
 }
 
+int tick_receive_broadcast(void)
+{
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+	struct clock_event_device *evt = td->evtdev;
+
+	if (!evt)
+		return -ENODEV;
+
+	if (!evt->event_handler)
+		return -EINVAL;
+
+	evt->event_handler(evt);
+	return 0;
+}
+
 /*
  * Broadcast the event to the cpus, which are set in the mask (mangled).
  */
-- 
1.7.0.4


