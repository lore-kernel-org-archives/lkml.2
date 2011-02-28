Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1B1RkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:40:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53141 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1B1RkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:40:08 -0500
Date: Mon, 28 Feb 2011 18:39:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20110228173952.GA4592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      clockevents: Prevent oneshot mode when broadcast device is periodic


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
