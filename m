Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab1FWIbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:31:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41714 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab1FWIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:31:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E02F9E5.6040200@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 17:31:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: catalin.marinas@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] arm: replace old cpumask functions with new one.
References: <4E02F92C.7070203@jp.fujitsu.com> <4E02F9A2.4040204@jp.fujitsu.com>
In-Reply-To: <4E02F9A2.4040204@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now cpus_xx() cpumask functions are marked as deprecated. This
patch replace them with modern one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/common/gic.c     |    2 +-
 arch/arm/kernel/kprobes.c |    2 +-
 arch/arm/kernel/smp.c     |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 4ddd0a6..ebd6b3b 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -389,7 +389,7 @@ void __cpuinit gic_enable_ppi(unsigned int irq)
 #ifdef CONFIG_SMP
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
-	unsigned long map = *cpus_addr(*mask);
+	unsigned long map = *cpumask_bits(mask);

 	/*
 	 * Ensure that stores to Normal memory are visible to the
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 1656c87..4ecc5ce 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -102,7 +102,7 @@ int __kprobes __arch_disarm_kprobe(void *p)

 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	stop_machine(__arch_disarm_kprobe, p, &cpu_online_map);
+	stop_machine(__arch_disarm_kprobe, p, cpu_online_mask);
 }

 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 344e52b..98a48ab 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -601,8 +601,9 @@ void smp_send_stop(void)
 	unsigned long timeout;

 	if (num_online_cpus() > 1) {
-		cpumask_t mask = cpu_online_map;
-		cpu_clear(smp_processor_id(), mask);
+		cpumask_t mask;
+		cpumask_copy(&mask, cpu_online_mask);
+		cpumask_clear_cpu(smp_processor_id(), &mask);

 		smp_cross_call(&mask, IPI_CPU_STOP);
 	}
-- 
1.7.3.1



