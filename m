Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2FOSsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:48:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57035 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab2FOSsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:48:15 -0400
Date: Fri, 15 Jun 2012 20:48:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120615184810.GA14185@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: a70270468234749741c5893ae78e5bb524771402 watchdog: Quiet down the boot messages

 Thanks,

	Ingo

------------------>
Don Zickus (1):
      watchdog: Quiet down the boot messages

Stephane Eranian (1):
      perf/x86: Fix broken LBR fixup code

Steven Rostedt (1):
      tracing: Have tracing_off() actually turn tracing off


 arch/x86/lib/usercopy.c |  2 +-
 kernel/trace/trace.c    |  2 +-
 kernel/watchdog.c       | 19 ++++++++++++++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 677b1ed..4f74d94 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -22,7 +22,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
-	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+	if (__range_not_ok(from, n, TASK_SIZE))
 		return len;
 
 	do {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 68032c6..49249c2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(tracing_on);
 void tracing_off(void)
 {
 	if (global_trace.buffer)
-		ring_buffer_record_on(global_trace.buffer);
+		ring_buffer_record_off(global_trace.buffer);
 	/*
 	 * This flag is only looked at when buffers haven't been
 	 * allocated yet. We don't really care about the race
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5e1d85..4b1dfba 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -372,6 +372,13 @@ static int watchdog(void *unused)
 
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+/*
+ * People like the simple clean cpu node info on boot.
+ * Reduce the watchdog noise by only printing messages
+ * that are different from what cpu0 displayed.
+ */
+static unsigned long cpu0_err;
+
 static int watchdog_nmi_enable(int cpu)
 {
 	struct perf_event_attr *wd_attr;
@@ -390,11 +397,21 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
+
+	/* save cpu0 error for future comparision */
+	if (cpu == 0 && IS_ERR(event))
+		cpu0_err = PTR_ERR(event);
+
 	if (!IS_ERR(event)) {
-		pr_info("enabled, takes one hw-pmu counter.\n");
+		/* only print for cpu0 or different than cpu0 */
+		if (cpu == 0 || cpu0_err)
+			pr_info("enabled on all CPUs, permanently consumes one hw-PMU counter.\n");
 		goto out_save;
 	}
 
+	/* skip displaying the same error again */
+	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
+		return PTR_ERR(event);
 
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
