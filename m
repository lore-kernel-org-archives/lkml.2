Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GZKro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:47:44 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35859 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2GZKrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:47:43 -0400
X-AuditID: b753bd60-928c4ba0000047ca-7e-5011204cdeb4
X-AuditID: b753bd60-928c4ba0000047ca-7e-5011204cdeb4
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RESEND PATCH] x86/ioapic: Fix NULL pointer dereference on CPU
 hotplug after disabling irqs
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>
Date: Thu, 26 Jul 2012 19:47:32 +0900
Message-ID: <20120726104732.2889.19144.stgit@kvmdev>
In-Reply-To: <20120726102106.GA22573@gmail.com>
References: <20120726102106.GA22573@gmail.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Previous patch was broken, sorry. Resending with another mailer.)

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


