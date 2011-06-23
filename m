Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab1FWSF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:05:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:34775 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab1FWRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 141/247] clockevents: Prevent oneshot mode when broadcast device is periodic
Date: Thu, 23 Jun 2011 13:33:29 -0400
Message-Id: <1308850515-15242-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/tick-broadcast.c |   10 ++++++++++
 kernel/time/tick-common.c    |    6 +++++-
 kernel/time/tick-internal.h  |    3 +++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index b3bafd5..2030f62 100644
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
index b6b898d..61e296b 100644
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
-- 
1.7.4.4

