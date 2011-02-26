Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab1BZIuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 03:50:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:50730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1BZIuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 03:50:19 -0500
Date: Sat, 26 Feb 2011 08:49:23 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, seth.forshee@canonical.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, seth.forshee@canonical.com
In-Reply-To: <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
References: <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clockevents: Prevent oneshot mode when broadcast device is periodic
Message-ID: <tip-3a142a0672b48a853f00af61f184c7341ac9c99d@git.kernel.org>
Git-Commit-ID: 3a142a0672b48a853f00af61f184c7341ac9c99d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 08:49:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a142a0672b48a853f00af61f184c7341ac9c99d
Gitweb:     http://git.kernel.org/tip/3a142a0672b48a853f00af61f184c7341ac9c99d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 25 Feb 2011 22:34:23 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 26 Feb 2011 09:45:28 +0100

clockevents: Prevent oneshot mode when broadcast device is periodic

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
Cc: stable@kernel.org # .21 ->
---
 kernel/time/tick-broadcast.c |   10 ++++++++++
 kernel/time/tick-common.c    |    6 +++++-
 kernel/time/tick-internal.h  |    3 +++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 48b2761..a3b5aff 100644
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
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 051bc80..ed228ef 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -51,7 +51,11 @@ int tick_is_oneshot_available(void)
 {
 	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
-	return dev && (dev->features & CLOCK_EVT_FEAT_ONESHOT);
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return 0;
+	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		return 1;
+	return tick_broadcast_oneshot_available();
 }
 
 /*
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 290eefb..f65d3a7 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -36,6 +36,7 @@ extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast(int cpu);
+bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -46,6 +47,7 @@ static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -76,6 +78,7 @@ static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 	return 0;
 }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
+static inline bool tick_broadcast_oneshot_available(void) { return false; }
 #endif /* !TICK_ONESHOT */
 
 /*
