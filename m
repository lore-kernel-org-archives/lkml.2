Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528Ab1CEBAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:45 -0500
Received: from kroah.org ([198.145.64.141]:50409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760511Ab1CEBAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.778250196@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [53/73] clockevents: Prevent oneshot mode when broadcast device is periodic
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 3a142a0672b48a853f00af61f184c7341ac9c99d upstream.

When the per cpu timer is marked CLOCK_EVT_FEAT_C3STOP, then we only
can switch into oneshot mode, when the backup broadcast device
supports oneshot mode as well. Otherwise we would try to switch the
broadcast device into an unsupported mode unconditionally. This went
unnoticed so far as the current available broadcast devices support
oneshot mode. Seth unearthed this problem while debugging and working
around an hpet related BIOS wreckage.

Add the necessary check to tick_is_oneshot_available().

Reported-and-tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |   10 ++++++++++
 kernel/time/tick-common.c    |    6 +++++-
 kernel/time/tick-internal.h  |    3 +++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -600,4 +600,14 @@ int tick_broadcast_oneshot_active(void)
 	return tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT;
 }
 
+/*
+ * Check whether the broadcast device supports oneshot.
+ */
+bool tick_broadcast_oneshot_available(void)
+{
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+
+	return bc ? bc->features & CLOCK_EVT_FEAT_ONESHOT : false;
+}
+
 #endif
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -51,7 +51,11 @@ int tick_is_oneshot_available(void)
 {
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 
-	return dev && (dev->features & CLOCK_EVT_FEAT_ONESHOT);
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return 0;
+	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		return 1;
+	return tick_broadcast_oneshot_available();
 }
 
 /*
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -36,6 +36,7 @@ extern void tick_shutdown_broadcast_ones
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast(int cpu);
+bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -46,6 +47,7 @@ static inline void tick_broadcast_switch
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -76,6 +78,7 @@ static inline int tick_resume_broadcast_
 	return 0;
 }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
+static inline bool tick_broadcast_oneshot_available(void) { return false; }
 #endif /* !TICK_ONESHOT */
 
 /*


