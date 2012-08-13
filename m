Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab2HME52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 00:57:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2HME51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 00:57:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,757,1336374000"; 
   d="scan'208";a="133460494"
Message-ID: <50287CD5.1090104@intel.com>
Date: Mon, 13 Aug 2012 13:04:37 +0900
From: "Chen, LinX Z" <linx.z.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        yanmin_zhang@linux.intel.com
Subject: [PATCH V2] x86/smp: Fix cpuN startup panic
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

This patch let AP waits for 60 seconds at maximum.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Chen LinX <linx.z.chen@intel.com>
---
  arch/x86/kernel/smpboot.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c5a8c3..447aa3b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -162,9 +162,9 @@ static void __cpuinit smp_callin(void)
  	 */

  	/*
-	 * Waiting 2s total for startup (udelay is not yet working)
+	 * Waiting 60s total for startup (udelay is not yet working)
  	 */
-	timeout = jiffies + 2*HZ;
+	timeout = jiffies + 60*HZ;
  	while (time_before(jiffies, timeout)) {
  		/*
  		 * Has the boot CPU finished it's STARTUP sequence?
-- 
1.7.1
