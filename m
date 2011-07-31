Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1GaDEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 23:04:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41948 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1GaDET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 23:04:19 -0400
MIME-Version: 1.0
Date: Sun, 31 Jul 2011 11:04:18 +0800
Message-ID: <CAJd=RBB-jYsxz2ymXH-6dtPndQ0qJODfzBbxv0h3_zoiMFsV_g@mail.gmail.com>
Subject: [RFC PATCH] MIPS/octeon: select online CPU for irq
From: Hillf Danton <dhillf@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tiny probability of dead loop is removed if all bound CPUs of given irq go
offline, and selected CPU is always checked to be online.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 arch/mips/cavium-octeon/octeon-irq.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c
b/arch/mips/cavium-octeon/octeon-irq.c
index ffd4ae6..7b678e3 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -198,28 +198,18 @@ static void __init octeon_irq_init_core(void)

 static int next_cpu_for_irq(struct irq_data *data)
 {
-
 #ifdef CONFIG_SMP
-	int cpu;
-	int weight = cpumask_weight(data->affinity);
-
-	if (weight > 1) {
-		cpu = smp_processor_id();
-		for (;;) {
-			cpu = cpumask_next(cpu, data->affinity);
-			if (cpu >= nr_cpu_ids) {
-				cpu = -1;
-				continue;
-			} else if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-				break;
-			}
-		}
-	} else if (weight == 1) {
-		cpu = cpumask_first(data->affinity);
-	} else {
-		cpu = smp_processor_id();
-	}
-	return cpu;
+	int cpu = smp_processor_id();
+
+	cpu = cpumask_next_and(cpu, data->affinity, cpu_online_mask);
+	if (cpu < nr_cpu_ids)
+		return cpu;
+
+	cpu = cpumask_first_and(data->affinity, cpu_online_mask);
+	if (cpu < nr_cpu_ids)
+		return cpu;
+
+	return smp_processor_id();
 #else
 	return smp_processor_id();
 #endif
