Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0K0PZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:25:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:37959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab0K0PWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:22:52 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/16] x86: Replace apic->apicid_to_node() with ->numa_cpu_node()
Date: Sat, 27 Nov 2010 16:22:01 +0100
Message-Id: <1290871325-3055-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290871325-3055-1-git-send-email-tj@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 15:22:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic->apicid_to_node() is 32bit specific apic operation which
determines NUMA node for a CPU.  Depending on the APIC implementation,
it can be easier to determine NUMA node from either physical or
logical apicid.  Currently, ->apicid_to_node() takes @logical_apicid
and calls hard_smp_processor_id() if the physical apicid is needed.

This prevents NUMA mapping from being queried from a different CPU,
which in turn makes it impossible to initialize NUMA mapping before
SMP bringup.

This patch replaces apic->apicid_to_node() with ->numa_cpu_node()
which takes @cpu, from which both logical and physical apicids can
easily be determined.  While at it, drop duplicate implementations
from bigsmp_32 and summit_32, and use the default.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/apic.h           |    4 ++--
 arch/x86/kernel/apic/apic.c           |    6 +++---
 arch/x86/kernel/apic/apic_flat_64.c   |    4 ++--
 arch/x86/kernel/apic/apic_noop.c      |    4 ++--
 arch/x86/kernel/apic/bigsmp_32.c      |    7 +------
 arch/x86/kernel/apic/es7000_32.c      |    7 +++----
 arch/x86/kernel/apic/numaq_32.c       |   11 ++++++++++-
 arch/x86/kernel/apic/probe_32.c       |    2 +-
 arch/x86/kernel/apic/summit_32.c      |   11 +----------
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 +-
 arch/x86/kernel/smpboot.c             |    3 +--
 13 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 70ced53..9dc2689 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -318,7 +318,7 @@ struct apic {
 
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
-	int (*apicid_to_node)(int logical_apicid);
+	int (*numa_cpu_node)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
@@ -532,7 +532,7 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-extern int default_apicid_to_node(int logical_apicid);
+extern int default_numa_cpu_node(int cpu);
 
 #endif
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4931b10..597ef66 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2013,10 +2013,10 @@ void default_init_apic_ldr(void)
 }
 
 #ifdef CONFIG_X86_32
-int default_apicid_to_node(int logical_apicid)
+int default_numa_cpu_node(int cpu)
 {
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
+#ifdef CONFIG_NUMA
+	return apicid_2_node[early_per_cpu(x86_cpu_to_apicid, cpu)];
 #else
 	return 0;
 #endif
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 09d3b17..a6c2cf4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -185,7 +185,7 @@ struct apic apic_flat =  {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
+	.numa_cpu_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
@@ -337,7 +337,7 @@ struct apic apic_physflat =  {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
+	.numa_cpu_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index e31b9ff..04f96d6 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -113,7 +113,7 @@ static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_set_cpu(cpu, retmask);
 }
 
-int noop_apicid_to_node(int logical_apicid)
+int noop_numa_cpu_node(int cpu)
 {
 	/* we're always on node 0 */
 	return 0;
@@ -153,7 +153,7 @@ struct apic apic_noop = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= noop_apicid_to_node,
+	.numa_cpu_node			= noop_numa_cpu_node,
 
 	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index df83be7..d473b3b 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -86,11 +86,6 @@ static void bigsmp_setup_apic_routing(void)
 		nr_ioapics);
 }
 
-static int bigsmp_apicid_to_node(int logical_apicid)
-{
-	return apicid_2_node[hard_smp_processor_id()];
-}
-
 static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
@@ -222,7 +217,7 @@ struct apic apic_bigsmp = {
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= bigsmp_apicid_to_node,
+	.numa_cpu_node			= default_numa_cpu_node,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 6eb0bd1..5e81b0c 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -510,12 +510,11 @@ static void es7000_setup_apic_routing(void)
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
 }
 
-static int es7000_apicid_to_node(int logical_apicid)
+static int es7000_numa_cpu_node(int cpu)
 {
 	return 0;
 }
 
-
 static int es7000_cpu_present_to_apicid(int mps_cpu)
 {
 	if (!mps_cpu)
@@ -650,7 +649,7 @@ struct apic __refdata apic_es7000_cluster = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= es7000_apicid_to_node,
+	.numa_cpu_node			= es7000_numa_cpu_node,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -715,7 +714,7 @@ struct apic __refdata apic_es7000 = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= es7000_apicid_to_node,
+	.numa_cpu_node			= es7000_numa_cpu_node,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 49cae83..5f84018 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -400,6 +400,15 @@ static inline int numaq_apicid_to_node(int logical_apicid)
 	return logical_apicid >> 4;
 }
 
+static int numaq_numa_cpu_node(int cpu)
+{
+	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+
+	if (logical_apicid != BAD_APICID)
+		return numaq_apicid_to_node(logical_apicid);
+	return NUMA_NO_NODE;
+}
+
 static void numaq_apicid_to_cpu_present(int logical_apicid, physid_mask_t *retmap)
 {
 	int node = numaq_apicid_to_node(logical_apicid);
@@ -511,7 +520,7 @@ struct apic __refdata apic_numaq = {
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
-	.apicid_to_node			= numaq_apicid_to_node,
+	.numa_cpu_node			= numaq_numa_cpu_node,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 99d2fe0..ae66389 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -130,7 +130,7 @@ struct apic apic_default = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= default_apicid_to_node,
+	.numa_cpu_node			= default_numa_cpu_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 50d5e3b..ec9fdb1 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -239,15 +239,6 @@ static void summit_setup_apic_routing(void)
 						nr_ioapics);
 }
 
-static int summit_apicid_to_node(int logical_apicid)
-{
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
-#else
-	return 0;
-#endif
-}
-
 static int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
@@ -524,7 +515,7 @@ struct apic apic_summit = {
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= summit_apicid_to_node,
+	.numa_cpu_node			= default_numa_cpu_node,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index cf69c59..6f6daed 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -206,7 +206,7 @@ struct apic apic_x2apic_cluster = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
+	.numa_cpu_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8972f38..0528136 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -195,7 +195,7 @@ struct apic apic_x2apic_phys = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
+	.numa_cpu_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c1c52c3..ad6e137 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -336,7 +336,7 @@ struct apic __refdata apic_x2apic_uv_x = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
+	.numa_cpu_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0768761..963c44b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -168,10 +168,9 @@ static void unmap_cpu_to_node(int cpu)
 static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
-	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 	int node;
 
-	node = apic->apicid_to_node(logical_apicid);
+	node = apic->numa_cpu_node(cpu);
 	if (!node_online(node))
 		node = first_online_node;
 
-- 
1.7.1

