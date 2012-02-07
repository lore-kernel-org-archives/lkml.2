Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2BGCZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:25:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:52567 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab2BGCZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:25:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="107146062"
Subject: [patch] x86, tsc: reduce the TSC sync check time for core-siblings
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>, venki@google.com
Date: Mon, 06 Feb 2012 18:32:20 -0800
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1328581940.29790.20.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each logical CPU that is coming online, we spend 20msec for checking
the TSC synchronization. And as this is done sequentially for each logical CPU
boot, this time gets added up depending on the number of logical CPU's
supported by the platform.

Minimize this by using the socket topology information.

If the target CPU coming online doesn't have any of its core-siblings
online, a timeout of 20msec will be used for the TSC-warp measurement
loop. Otherwise a smaller timeout of 2msec will be used, as we have some
information about this socket already (and this information grows as we
have more and more logical-siblings in that socket).

Ideally we should be able to skip the TSC sync check on the other
core-siblings, if the first logical CPU in a socket passed the sync test.
But as the TSC is per-logical CPU and can potentially be modified wrongly
by the bios before the OS boot, TSC sync test for smaller duration should
be able to catch such errors. Also this will catch the condition where all the
cores in the socket doesn't get reset at the same time.

For example, with this modification, time spent in TSC sync checks on a
4 socket 10-core with HT system gets reduced from 1580msec to 212msec.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/tsc_sync.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9eba29b..cbf0b0f 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -42,7 +42,7 @@ static __cpuinitdata int nr_warps;
 /*
  * TSC-warp measurement loop running on both CPUs:
  */
-static __cpuinit void check_tsc_warp(void)
+static __cpuinit void check_tsc_warp(unsigned int timeout)
 {
 	cycles_t start, now, prev, end;
 	int i;
@@ -51,9 +51,9 @@ static __cpuinit void check_tsc_warp(void)
 	start = get_cycles();
 	rdtsc_barrier();
 	/*
-	 * The measurement runs for 20 msecs:
+	 * The measurement runs for 'timeout' msecs:
 	 */
-	end = start + tsc_khz * 20ULL;
+	end = start + (cycles_t) tsc_khz * timeout;
 	now = start;
 
 	for (i = 0; ; i++) {
@@ -99,6 +99,25 @@ static __cpuinit void check_tsc_warp(void)
 }
 
 /*
+ * If the target CPU coming online doesn't have any of its core-siblings
+ * online, a timeout of 20msec will be used for the TSC-warp measurement
+ * loop. Otherwise a smaller timeout of 2msec will be used, as we have some
+ * information about this socket already (and this information grows as we
+ * have more and more logical-siblings in that socket).
+ *
+ * Ideally we should be able to skip the TSC sync check on the other
+ * core-siblings, if the first logical CPU in a socket passed the sync test.
+ * But as the TSC is per-logical CPU and can potentially be modified wrongly
+ * by the bios, TSC sync test for smaller duration should be able
+ * to catch such errors. Also this will catch the condition where all the
+ * cores in the socket doesn't get reset at the same time.
+ */
+static inline unsigned int loop_timeout(int cpu)
+{
+	return (cpumask_weight(cpu_core_mask(cpu)) > 1) ? 2 : 20;
+}
+
+/*
  * Source CPU calls into this - it waits for the freshly booted
  * target CPU to arrive and then starts the measurement:
  */
@@ -135,7 +154,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	 */
 	atomic_inc(&start_count);
 
-	check_tsc_warp();
+	check_tsc_warp(loop_timeout(cpu));
 
 	while (atomic_read(&stop_count) != cpus-1)
 		cpu_relax();
@@ -183,7 +202,7 @@ void __cpuinit check_tsc_sync_target(void)
 	while (atomic_read(&start_count) != cpus)
 		cpu_relax();
 
-	check_tsc_warp();
+	check_tsc_warp(loop_timeout(smp_processor_id()));
 
 	/*
 	 * Ok, we are done:


