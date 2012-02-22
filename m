Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2BVQKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:10:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2BVQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:10:10 -0500
Date: Wed, 22 Feb 2012 08:09:03 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-b0e5c77903fd717cc5eb02b7b8f5de3c869efc49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        arjan@linux.intel.com, akpm@linux-foundation.org, steiner@sgi.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1328581940.29790.20.camel@sbsiddha-desk.sc.intel.com>
References: <1328581940.29790.20.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86/tsc:
  Reduce the TSC sync check time for core-siblings
Git-Commit-ID: b0e5c77903fd717cc5eb02b7b8f5de3c869efc49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:09:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0e5c77903fd717cc5eb02b7b8f5de3c869efc49
Gitweb:     http://git.kernel.org/tip/b0e5c77903fd717cc5eb02b7b8f5de3c869efc49
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 6 Feb 2012 18:32:20 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 11:49:40 +0100

x86/tsc: Reduce the TSC sync check time for core-siblings

For each logical CPU that is coming online, we spend 20msec for
checking the TSC synchronization. And as this is done
sequentially for each logical CPU boot, this time gets added up
depending on the number of logical CPU's supported by the
platform.

Minimize this by using the socket topology information.

If the target CPU coming online doesn't have any of its
core-siblings online, a timeout of 20msec will be used for the
TSC-warp measurement loop. Otherwise a smaller timeout of 2msec
will be used, as we have some information about this socket
already (and this information grows as we have more and more
logical-siblings in that socket).

Ideally we should be able to skip the TSC sync check on the
other core-siblings, if the first logical CPU in a socket passed
the sync test. But as the TSC is per-logical CPU and can
potentially be modified wrongly by the bios before the OS boot,
TSC sync test for smaller duration should be able to catch such
errors. Also this will catch the condition where all the cores
in the socket doesn't get reset at the same time.

For example, with this modification, time spent in TSC sync
checks on a 4 socket 10-core with HT system gets reduced from
1580msec to 212msec.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jack Steiner <steiner@sgi.com>
Cc: venki@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1328581940.29790.20.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc_sync.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9eba29b..fc25e60 100644
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
