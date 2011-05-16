Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1EPXgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:36:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62627 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1EPXgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:36:03 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] watchdog: configure nmi watchdog period based on watchdog_thresh
Date: Mon, 16 May 2011 16:35:01 -0700
Message-Id: <1305588901-8141-4-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305588901-8141-1-git-send-email-msb@chromium.org>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
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

This change configures the NMI period based on the watchdog_thresh.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    4 ++--
 include/linux/nmi.h           |    2 +-
 kernel/watchdog.c             |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
index c536f85..c20c55a 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -45,7 +45,7 @@ static inline bool trigger_all_cpu_backtrace(void)
 
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
-u64 hw_nmi_get_sample_period(void);
+u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_enabled;
 struct ctl_table;
 extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 50c2f62..169e1e2 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -359,7 +359,7 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
-	wd_attr->sample_period = hw_nmi_get_sample_period();
+	wd_attr->sample_period = hw_nmi_get_sample_period(softlockup_thresh);
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
-- 
1.7.3.1

