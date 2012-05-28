Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2E1JaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:30:07 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:44099 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2E1JaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:30:05 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2012 05:30:04 EDT
X-AuditID: b753bd60-a3089ba000000655-48-4fc340c11849
X-AuditID: b753bd60-a3089ba000000655-48-4fc340c11849
Message-ID: <4FC340BE.7080101@hitachi.com>
Date: Mon, 28 May 2012 18:09:18 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, ltc-kernel@ml.yrl.intra.hitachi.co.jp
Subject: [PATCH] x86: Fix NULL pointer dereference on CPU hotplug after disabling
 irqs
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current Linux, percpu variable `vector_irq' is not cleared on offlined
cpus while disabling devices' irqs. If the cpu that has the disabled irqs
in vector_irq is hotplugged, __setup_vector_irq() hits invalid irq vector
and may crash.

This bug can be reproduced as following;
 # echo 0 > /sys/devices/system/cpu/cpu7/online
 # modprobe -r some_driver_using_interrupts      # vector_irq@cpu7 uncleared
 # echo 1 > /sys/devices/system/cpu/cpu7/online  # kernel may crash

This patch fixes this bug by clearing vector_irq in __clear_irq_vector()
even if the cpu is offlined.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ac96561..5f0ff59 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1195,7 +1195,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	BUG_ON(!cfg->vector);
  	vector = cfg->vector;
-	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
+	for_each_cpu(cpu, cfg->domain)
 		per_cpu(vector_irq, cpu)[vector] = -1;
  	cfg->vector = 0;
@@ -1203,7 +1203,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
  	if (likely(!cfg->move_in_progress))
 		return;
-	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
+	for_each_cpu(cpu, cfg->old_domain) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
-- 
1.7.7.6

