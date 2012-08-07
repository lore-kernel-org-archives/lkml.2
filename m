Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2HGKnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:43:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:26335 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab2HGKnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:43:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177849967"
Message-ID: <5020E4F0.5060203@intel.com>
Date: Tue, 07 Aug 2012 18:50:40 +0900
From: "Chen, LinX Z" <linx.z.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        yanmin_zhang@linux.intel.com
Subject: [PATCH] x86/smp: Fix cpuN startup panic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Chen <linx.z.chen@intel.com>

We hit a panic while doing cpu hotplug test.
<0>[  627.982857] Kernel panic - not syncing: smp_callin: CPU1 started up but did not get a callout!
<0>[  627.982864]
<4>[  627.982876] Pid: 0, comm: kworker/0:1 Tainted: G ...
<4>[  627.982883] Call Trace:
<4>[  627.982903]  [<c18f2977>] panic+0x66/0x16c
<4>[  627.982918]  [<c12234cc>] ? default_get_apic_id+0x1c/0x40
<4>[  627.982931]  [<c18ef96d>] start_secondary+0xda/0x252

During BSP bootup AP, it is possible that BSP be preempted before
finishing STARTUP sequence of AP(set cpu_callout_mask) which maybe cause
AP busy wait for it. At present, AP will wait for 2 seconds then panic.

This patch let AP waits until BSP finish the startup sequence and gives
WARNING when BSP is preempted more than 2 seconds.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Lin Chen <linx.z.chen@intel.com>
---
  arch/x86/kernel/smpboot.c |   11 ++++++-----
  1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c5a8c3..a9e3379 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -165,19 +165,20 @@ static void __cpuinit smp_callin(void)
  	 * Waiting 2s total for startup (udelay is not yet working)
  	 */
  	timeout = jiffies + 2*HZ;
-	while (time_before(jiffies, timeout)) {
+	while (1) {
  		/*
  		 * Has the boot CPU finished it's STARTUP sequence?
  		 */
  		if (cpumask_test_cpu(cpuid, cpu_callout_mask))
  			break;
  		cpu_relax();
+		if (!time_before(jiffies, timeout)) {
+			WARN(1, "%s: CPU%d started up but did not get a callout!\n",
+					__func__, cpuid);
+			timeout = jiffies + 2*HZ;
+		}
  	}

-	if (!time_before(jiffies, timeout)) {
-		panic("%s: CPU%d started up but did not get a callout!\n",
-		      __func__, cpuid);
-	}

  	/*
  	 * the boot CPU has finished the init stage and is spinning
-- 
1.7.1
