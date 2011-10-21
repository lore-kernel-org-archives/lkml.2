Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1JUDAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:00:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:20188 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab1JUDAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,383,1315206000"; 
   d="scan'208";a="76010981"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH] x86: add a early_tsc_khz parameter for the early printk time
Date: Fri, 21 Oct 2011 11:02:16 +0800
Message-Id: <1319166136-30939-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the printk time for x86 will not counts untill the tsc_init()
where the TSC get initiated. But if we already know the cpu/tsc freq,
we can make the printk time count since the start of start_kernel(),
by adding a "early_tsc_khz=_your_board_cpu_khz_" in command line.

This patch will use the user provided tsc_khz info to calculate the
printk time till the tsc_init() get called. With it, the printk time
could start at about 200ms earlier on a 3 GHz Core Duo machine, 440ms
earlier on a 1.6 GHz Intel Medfield soc platform(with earlyprintk on,
it could be 2.3 seconds earlier)

And the earlier printk time could make tuning the boot time easier,
as we already see the mem_init() could take about 230ms for a 1GB
MRST platform before the tsc_init().

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 Documentation/kernel-parameters.txt |    5 ++++
 arch/x86/kernel/tsc.c               |   40 +++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d6e6724..c80cc1f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2541,6 +2541,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			platforms where RDTSC is slow and this accounting
 			can add overhead.
 
+	early_tsc_kzh=  [X86] Set to the known x86 tsc khz.
+			It will help to make the printk time start to count
+			much earlier before the tsc get initiated in the
+			tsc_init().
+
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
 			Format:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..2da4820 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -25,6 +25,36 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int __read_mostly tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu);
+
+unsigned long __read_mostly early_tsc_khz;
+
+static int __init setup_early_tsc_khz(char *p)
+{
+	unsigned long size;
+
+	if (!p)
+		return -EINVAL;
+
+	size = (unsigned long)memparse(p, &p);
+
+	/* Warn if the early tsc freq is larger than 10G or less then 1M HZ */
+	if (size < 1024 || size > (10 << 20)) {
+		pr_warn("Wired early_tsc_khz param: %lu\n", size);
+		return -EINVAL;
+	}
+	early_tsc_khz = size;
+
+	/*
+	 * Here we only care about the boot cpu, as other CPUs will be
+	 * covered by tsc_init().
+	 */
+	set_cyc2ns_scale(early_tsc_khz, 0);
+	sched_clock_stable = 1;
+	return 0;
+}
+early_param("early_tsc_khz", setup_early_tsc_khz);
+
 /*
  * TSC can be unstable due to cpufreq or due to unsynced TSCs
  */
@@ -36,6 +66,7 @@ static int __read_mostly tsc_unstable;
 static int __read_mostly tsc_disabled = -1;
 
 static int tsc_clocksource_reliable;
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
@@ -52,8 +83,13 @@ u64 native_sched_clock(void)
 	 *   can achieve it. )
 	 */
 	if (unlikely(tsc_disabled)) {
-		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
+		/*
+		 * If people setup the early_tsc_khz, then we should
+		 * trust it and use it till the tsc_init().
+		 * No locking but a rare wrong value is not a big deal:
+		 */
+		if (!early_tsc_khz)
+			return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}
 
 	/* read the Time Stamp Counter: */
-- 
1.7.2.3

