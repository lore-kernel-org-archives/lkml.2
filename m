Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2GZPQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:16:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2GZPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:16:42 -0400
Date: Thu, 26 Jul 2012 08:16:24 -0700
From: tip-bot for Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Message-ID: <tip-1d44b30f35a9873a65b320dd5300088fa995fd94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, tomoki.sekiyama.qu@hitachi.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        tomoki.sekiyama.qu@hitachi.com
In-Reply-To: <20120726104732.2889.19144.stgit@kvmdev>
References: <20120726104732.2889.19144.stgit@kvmdev>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ioapic:
  Fix NULL pointer dereference on CPU hotplug after disabling irqs
Git-Commit-ID: 1d44b30f35a9873a65b320dd5300088fa995fd94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:16:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d44b30f35a9873a65b320dd5300088fa995fd94
Gitweb:     http://git.kernel.org/tip/1d44b30f35a9873a65b320dd5300088fa995fd94
Author:     Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
AuthorDate: Thu, 26 Jul 2012 19:47:32 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 15:01:17 +0200

x86/ioapic: Fix NULL pointer dereference on CPU hotplug after disabling irqs

In the current kernel, percpu variable `vector_irq' is not always
cleared when a CPU is offlined. If the CPU that has the disabled
irqs in vector_irq is hotplugged again, __setup_vector_irq()
hits invalid irq vector and may crash.

This bug can be reproduced as following;

 # echo 0 > /sys/devices/system/cpu/cpu7/online
 # modprobe -r some_driver_using_interrupts     # vector_irq@cpu7 uncleared
 # echo 1 > /sys/devices/system/cpu/cpu7/online # kernel may crash

To fix this problem, this patch clears vector_irq in
__fixup_irqs() when the CPU is offlined.

This also reverts commit f6175f5bfb4c, which partially fixes
this bug by clearing vector in __clear_irq_vector(). But in
environments with IOMMU IRQ remapper, it could fail because
cfg->domain doesn't contain offlined CPUs. With this patch, the
fix in __clear_irq_vector() can be reverted because every
vector_irq is already cleared in __fixup_irqs() on offlined CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20120726104732.2889.19144.stgit@kvmdev
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 arch/x86/kernel/irq.c          |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 406eee7..a6c64aa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1204,7 +1204,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
-	for_each_cpu(cpu, cfg->domain)
+	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
@@ -1212,7 +1212,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 
 	if (likely(!cfg->move_in_progress))
 		return;
-	for_each_cpu(cpu, cfg->old_domain) {
+	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1f5f1d5..7ad683d 100644
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
