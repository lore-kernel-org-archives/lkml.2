Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2IZFeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:34:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:9602 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2IZFeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:34:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,487,1344236400"; 
   d="scan'208";a="149130081"
Subject: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq
 affinity mask
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Sep 2012 22:32:04 +0800
Message-ID: <1348669924.19514.6.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When one CPU is going offline, and fixup_irqs() will re-set the
irq affinity in some cases, we should clean the offlining CPU from
the irq affinity.

The reason is setting offlining CPU as of the affinity is useless.
Moreover, the smp_affinity value will be confusing when the
offlining CPU come back again.

Example:
For irq 93 with 4 CPUS, the default affinity f(1111),
normal cases: 4 CPUS will receive the irq93 interrupts.

When echo 0 > /sys/devices/system/cpu/cpu3/online, just CPU0,1,2 will
receive the interrupts.

But after the CPU3 is online again, we will not set affinity,the result
will be:
the smp_affinity is f, but still just CPU0,1,2 can receive the interrupts.

So we should clean the offlining CPU from irq affinity mask
in fixup_irqs().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/irq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..671d462 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -239,6 +239,7 @@ void fixup_irqs(void)
 	struct irq_desc *desc;
 	struct irq_data *data;
 	struct irq_chip *chip;
+	int cpu = smp_processor_id();
 
 	for_each_irq_desc(irq, desc) {
 		int break_affinity = 0;
@@ -271,7 +272,8 @@ void fixup_irqs(void)
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
 			affinity = cpu_online_mask;
-		}
+		} else if (cpumask_test_cpu(cpu, data->affinity))
+			cpumask_clear_cpu(cpu, data->affinity);
 
 		chip = irq_data_get_irq_chip(data);
 		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
-- 
1.7.0.4



