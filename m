Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1EWFLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:11:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1EWFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:11:46 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] watchdog: configure nmi watchdog period based on watchdog_thresh
Date: Sun, 22 May 2011 22:10:23 -0700
Message-Id: <1306127423-3347-4-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1306127423-3347-1-git-send-email-msb@chromium.org>
References: <1306127423-3347-1-git-send-email-msb@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the conversion of the NMI watchdog to perf event, the watchdog
timeout was 5 seconds. Now it is 60 seconds. For my particular application,
netbooks, 5 seconds was a better timeout. With a short timeout, we
catch faults earlier and are able to send back a panic. With a 60 second
timeout, the user is unlikely to wait and will instead hit the power
button, causing us to lose the panic info.

This change configures the NMI period to watchdog_thresh and sets
the softlockup_thresh to watchdog_thresh * 2. In addition, watchdog_thresh
was reduced to 10 seconds as suggested by Ingo Molnar.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
LKML-Reference: <20110517071642.GF22305@elte.hu>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/kernel/apic/hw_nmi.c |    4 ++--
 include/linux/nmi.h           |    2 +-
 kernel/watchdog.c             |   19 +++++++++++++++----
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 5260fe9..d5e57db0 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -19,9 +19,9 @@
 #include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-u64 hw_nmi_get_sample_period(void)
+u64 hw_nmi_get_sample_period(int watchdog_thresh)
 {
-	return (u64)(cpu_khz) * 1000 * 60;
+	return (u64)(cpu_khz) * 1000 * watchdog_thresh;
 }
 #endif
 
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 5317b8b..2d304ef 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -45,7 +45,7 @@ static inline bool trigger_all_cpu_backtrace(void)
 
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
-u64 hw_nmi_get_sample_period(void);
+u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_enabled;
 extern int watchdog_thresh;
 struct ctl_table;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6030191..6e63097 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -28,7 +28,7 @@
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
-int __read_mostly watchdog_thresh = 60;
+int __read_mostly watchdog_thresh = 10;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -91,6 +91,17 @@ static int __init nosoftlockup_setup(char *str)
 __setup("nosoftlockup", nosoftlockup_setup);
 /*  */
 
+/*
+ * Hard-lockup warnings should be triggered after just a few seconds. Soft-
+ * lockups can have false positives under extreme conditions. So we generally
+ * want a higher threshold for soft lockups than for hard lockups. So we couple
+ * the thresholds with a factor: we make the soft threshold twice the amount of
+ * time the hard threshold is.
+ */
+static int get_softlockup_thresh()
+{
+	return watchdog_thresh * 2;
+}
 
 /*
  * Returns seconds, approximately.  We don't need nanosecond
@@ -110,7 +121,7 @@ static unsigned long get_sample_period(void)
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return watchdog_thresh * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -182,7 +193,7 @@ static int is_softlockup(unsigned long touch_ts)
 	unsigned long now = get_timestamp(smp_processor_id());
 
 	/* Warn about unreasonable delays: */
-	if (time_after(now, touch_ts + watchdog_thresh))
+	if (time_after(now, touch_ts + get_softlockup_thresh()))
 		return now - touch_ts;
 
 	return 0;
@@ -359,7 +370,7 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
-	wd_attr->sample_period = hw_nmi_get_sample_period();
+	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
-- 
1.7.3.1

