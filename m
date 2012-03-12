Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2CLJ1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:27:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:27087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2CLJ1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:27:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="76347134"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: Ac0AMkf58fFhOwlxQ12bG6GdAj6CkA==
Date: Mon, 12 Mar 2012 09:27:04 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] Fix the race between smp_call_function and CPU booting

When system is waking up from suspend state, sometimes the smp_call_function is called which will cause deadlock specially on the platform which just has two CPUs.

CPU0:                                           CPU1:
pm_suspend -->
suspend_devices_and_enter -->
enable_nonboot_cpus -->
_cpu_up -->
__cpu_up -->
native_cpu_up
                                                start_secondary
                                                        -- set cpu online
                                                        -- waiting for the active state new thread call:
smp_call_function -->
smp_call_function_many -->
smp_call_function_single -->
   -- csd_lock
   -- generic_exec_single -->
   -- arch_send_call_function_single_ipi
   -- csd_lock_wait

At this time, both CPUs are blocked. Normally the CPU0 will set the CPU1 with active state after finished the _cpu_up calling, but CPU1 can not handle the IPI due to the corresponding irq is still disabled, which will be enabled after waiting for the active state.

The solution is just to send smp call to active cpus instead of online cpus.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c index fb67dfa..e67674b 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -573,7 +573,7 @@ EXPORT_SYMBOL(smp_call_function_many);
 int smp_call_function(smp_call_func_t func, void *info, int wait)  {
        preempt_disable();
-       smp_call_function_many(cpu_online_mask, func, info, wait);
+       smp_call_function_many(cpu_active_mask, func, info, wait);
        preempt_enable();
 
        return 0;
--
1.7.0.4



