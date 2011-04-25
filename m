Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab1DYJce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:32:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34607 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab1DYJcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:32:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] blackfin: convert old cpumask API to new one
Cc: kosaki.motohiro@jp.fujitsu.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110425182906.2673.A69D9226@jp.fujitsu.com>
References: <20110425182906.2673.A69D9226@jp.fujitsu.com>
Message-Id: <20110425183402.2683.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:32:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

old cpu_xxx() APIs is planned to removed later. then, converted.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: device-driver-devel@blackfin.uclinux.org
---
 arch/blackfin/kernel/nmi.c       |    8 ++++----
 arch/blackfin/kernel/setup.c     |    4 ++--
 arch/blackfin/mach-common/dpmc.c |    7 ++++---
 arch/blackfin/mach-common/smp.c  |   27 ++++++++++++++-------------
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/blackfin/kernel/nmi.c b/arch/blackfin/kernel/nmi.c
index 0b5f72f..7af8b70 100644
--- a/arch/blackfin/kernel/nmi.c
+++ b/arch/blackfin/kernel/nmi.c
@@ -145,16 +145,16 @@ int check_nmi_wdt_touched(void)
 {
 	unsigned int this_cpu = smp_processor_id();
 	unsigned int cpu;
+	cpumask_t mask;
 
-	cpumask_t mask = cpu_online_map;
-
+	cpumask_copy(&mask, cpu_online_mask);
 	if (!atomic_read(&nmi_touched[this_cpu]))
 		return 0;
 
 	atomic_set(&nmi_touched[this_cpu], 0);
 
-	cpu_clear(this_cpu, mask);
-	for_each_cpu_mask(cpu, mask) {
+	cpumask_clear_cpu(this_cpu, &mask);
+	for_each_cpu(cpu,&mask) {
 		invalidate_dcache_range((unsigned long)(&nmi_touched[cpu]),
 				(unsigned long)(&nmi_touched[cpu]));
 		if (!atomic_read(&nmi_touched[cpu]))
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 805c613..c00c87b 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -1326,7 +1326,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)
-		*pos = first_cpu(cpu_online_map);
+		*pos = cpumask_first(cpu_online_mask);
 	if (*pos >= num_online_cpus())
 		return NULL;
 
@@ -1335,7 +1335,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_online_map);
+	*pos = cpumask_next(*pos, cpu_online_mask);
 
 	return c_start(m, pos);
 }
diff --git a/arch/blackfin/mach-common/dpmc.c b/arch/blackfin/mach-common/dpmc.c
index 382099f..6ea2921 100644
--- a/arch/blackfin/mach-common/dpmc.c
+++ b/arch/blackfin/mach-common/dpmc.c
@@ -88,10 +88,11 @@ static void bfin_wakeup_cpu(void)
 {
 	unsigned int cpu;
 	unsigned int this_cpu = smp_processor_id();
-	cpumask_t mask = cpu_online_map;
+	cpumask_t mask;
 
-	cpu_clear(this_cpu, mask);
-	for_each_cpu_mask(cpu, mask)
+	cpumask_copy(&mask, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, &mask);
+	for_each_cpu(cpu, &mask)
 		platform_send_ipi_cpu(cpu, IRQ_SUPPLE_0);
 }
 
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 1fbd94c..f430bba 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -96,7 +96,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 	dump_stack();
 	spin_unlock(&stop_lock);
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 
 	local_irq_disable();
 
@@ -146,7 +146,7 @@ static void ipi_call_function(unsigned int cpu, struct ipi_message *msg)
 		 */
 		resync_core_dcache();
 #endif
-		cpu_clear(cpu, *msg->call_struct.waitmask);
+		cpumask_clear_cpu(cpu, msg->call_struct.waitmask);
 	}
 }
 
@@ -222,9 +222,10 @@ static inline void smp_send_message(cpumask_t callmap, unsigned long type,
 	struct ipi_message_queue *msg_queue;
 	struct ipi_message *msg;
 	unsigned long flags, next_msg;
-	cpumask_t waitmask = callmap; /* waitmask is shared by all cpus */
+	cpumask_t waitmask; /* waitmask is shared by all cpus */
 
-	for_each_cpu_mask(cpu, callmap) {
+	cpumask_copy(&waitmask, &callmap);
+	for_each_cpu(cpu, &callmap) {
 		msg_queue = &per_cpu(ipi_msg_queue, cpu);
 		spin_lock_irqsave(&msg_queue->lock, flags);
 		if (msg_queue->count < BFIN_IPI_MSGQ_LEN) {
@@ -246,7 +247,7 @@ static inline void smp_send_message(cpumask_t callmap, unsigned long type,
 	}
 
 	if (wait) {
-		while (!cpus_empty(waitmask))
+		while (!cpumask_empty(&waitmask))
 			blackfin_dcache_invalidate_range(
 				(unsigned long)(&waitmask),
 				(unsigned long)(&waitmask));
@@ -265,9 +266,9 @@ int smp_call_function(void (*func)(void *info), void *info, int wait)
 	cpumask_t callmap;
 
 	preempt_disable();
-	callmap = cpu_online_map;
-	cpu_clear(smp_processor_id(), callmap);
-	if (!cpus_empty(callmap))
+	cpumask_copy(&callmap, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &callmap);
+	if (!cpumask_empty(&callmap))
 		smp_send_message(callmap, BFIN_IPI_CALL_FUNC, func, info, wait);
 
 	preempt_enable();
@@ -284,8 +285,8 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 
 	if (cpu_is_offline(cpu))
 		return 0;
-	cpus_clear(callmap);
-	cpu_set(cpu, callmap);
+	cpumask_clear(&callmap);
+	cpumask_set_cpu(cpu, &callmap);
 
 	smp_send_message(callmap, BFIN_IPI_CALL_FUNC, func, info, wait);
 
@@ -308,9 +309,9 @@ void smp_send_stop(void)
 	cpumask_t callmap;
 
 	preempt_disable();
-	callmap = cpu_online_map;
-	cpu_clear(smp_processor_id(), callmap);
-	if (!cpus_empty(callmap))
+	cpumask_copy(&callmap, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &callmap);
+	if (!cpumask_empty(&callmap))
 		smp_send_message(callmap, BFIN_IPI_CPU_STOP, NULL, NULL, 0);
 
 	preempt_enable();
-- 
1.7.3.1



