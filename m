Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2FFPUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:20:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2FFPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:20:46 -0400
Date: Wed, 6 Jun 2012 08:20:33 -0700
From: tip-bot for Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Message-ID: <tip-f6175f5bfb4c9f2ed32758c95f765b529b1a7f15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, tomoki.sekiyama.qu@hitachi.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        tomoki.sekiyama.qu@hitachi.com
In-Reply-To: <4FC340BE.7080101@hitachi.com>
References: <4FC340BE.7080101@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ioapic:
  Fix NULL pointer dereference on CPU hotplug after disabling irqs
Git-Commit-ID: f6175f5bfb4c9f2ed32758c95f765b529b1a7f15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:20:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6175f5bfb4c9f2ed32758c95f765b529b1a7f15
Gitweb:     http://git.kernel.org/tip/f6175f5bfb4c9f2ed32758c95f765b529b1a7f15
Author:     Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
AuthorDate: Mon, 28 May 2012 18:09:18 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 12:03:25 +0200

x86/ioapic: Fix NULL pointer dereference on CPU hotplug after disabling irqs

In current Linux, percpu variable `vector_irq' is not cleared on
offlined cpus while disabling devices' irqs. If the cpu that has
the disabled irqs in vector_irq is hotplugged,
__setup_vector_irq() hits invalid irq vector and may crash.

This bug can be reproduced as following;

  # echo 0 > /sys/devices/system/cpu/cpu7/online
  # modprobe -r some_driver_using_interrupts      # vector_irq@cpu7 uncleared
  # echo 1 > /sys/devices/system/cpu/cpu7/online  # kernel may crash

This patch fixes this bug by clearing vector_irq in
__clear_irq_vector() even if the cpu is offlined.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: ltc-kernel@ml.yrl.intra.hitachi.co.jp
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/4FC340BE.7080101@hitachi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
