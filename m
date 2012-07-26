Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2GZJn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:43:26 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41691 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2GZJnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:43:25 -0400
X-AuditID: b753bd60-8ecbeba0000047ca-36-5011113a25ee
X-AuditID: b753bd60-8ecbeba0000047ca-36-5011113a25ee
Message-ID: <50111146.7070707@hitachi.com>
Date: Thu, 26 Jul 2012 18:43:34 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, suresh.b.siddha@intel.com
Cc: hpa@zytor.com, yinghai@kernel.org, agordeev@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: [PATCH] x86/ioapic: Fix NULL pointer dereference on CPU hotplug after
 disabling irqs
References: <BC5CD145C5D9E74D86490E60F52766FF1EBCFCDD@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <BC5CD145C5D9E74D86490E60F52766FF1EBCFCDD@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current Linux, percpu variable `vector_irq' is not always cleared when
a CPU is offlined. If the CPU that has the disabled irqs in vector_irq is
hotplugged again, __setup_vector_irq() hits invalid irq vector and may
crash.

This bug can be reproduced as following;
 # echo 0 > /sys/devices/system/cpu/cpu7/online
 # modprobe -r some_driver_using_interrupts     # vector_irq@cpu7 uncleared
 # echo 1 > /sys/devices/system/cpu/cpu7/online # kernel may crash

To fix this problem, this patch clears vector_irq in __fixup_irqs() when
the CPU is offlined.

This also reverts commit f6175f5bfb4c, which partially fixes this bug by
clearing vector in __clear_irq_vector(). But in environments with IOMMU IRQ
remapper, it could fail because cfg->domain doesn't contain offlined CPUs.
With this patch, the fix in __clear_irq_vector() can be reverted because
every vector_irq is already cleared in __fixup_irqs() on offlined CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 arch/x86/kernel/irq.c          |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5f0ff59..ac96561 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1195,7 +1195,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	BUG_ON(!cfg->vector);
  	vector = cfg->vector;
-	for_each_cpu(cpu, cfg->domain)
+	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
  	cfg->vector = 0;
@@ -1203,7 +1203,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
  	if (likely(!cfg->move_in_progress))
 		return;
-	for_each_cpu(cpu, cfg->old_domain) {
+	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3dafc60..d27b27d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -328,6 +328,7 @@ void fixup_irqs(void)
 				chip->irq_retrigger(data);
 			raw_spin_unlock(&desc->lock);
 		}
+		__this_cpu_write(vector_irq[vector], -1);
 	}
 }
 #endif
-- 
1.7.7.6


