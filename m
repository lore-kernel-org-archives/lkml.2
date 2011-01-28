Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1A1OmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:42:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:60076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1A1OmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:42:07 -0500
Date: Fri, 28 Jan 2011 14:41:17 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-13-git-send-email-tj@kernel.org>
References: <1295789862-25482-13-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Replace apic->apicid_to_node() with ->x86_32_numa_cpu_node()
Message-ID: <tip-89e5dc218e084e13a3996db6693b01478912f4ee@git.kernel.org>
Git-Commit-ID: 89e5dc218e084e13a3996db6693b01478912f4ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:41:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89e5dc218e084e13a3996db6693b01478912f4ee
Gitweb:     http://git.kernel.org/tip/89e5dc218e084e13a3996db6693b01478912f4ee
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:08 +0100

x86: Replace apic->apicid_to_node() with ->x86_32_numa_cpu_node()

apic->apicid_to_node() is 32bit specific apic operation which
determines NUMA node for a CPU.  Depending on the APIC
implementation, it can be easier to determine NUMA node from
either physical or logical apicid.  Currently,
->apicid_to_node() takes @logical_apicid and calls
hard_smp_processor_id() if the physical apicid is needed.

This prevents NUMA mapping from being queried from a different
CPU, which in turn makes it impossible to initialize NUMA
mapping before SMP bringup.

This patch replaces apic->apicid_to_node() with
->x86_32_numa_cpu_node() which takes @cpu, from which both
logical and physical apicids can easily be determined.  While at
it, drop duplicate implementations from bigsmp_32 and summit_32,
and use the default one.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-13-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h           |    6 ++++--
 arch/x86/kernel/apic/apic.c           |   10 +++++++---
 arch/x86/kernel/apic/apic_flat_64.c   |    2 --
 arch/x86/kernel/apic/apic_noop.c      |   16 +++++++++-------
 arch/x86/kernel/apic/bigsmp_32.c      |    7 +------
 arch/x86/kernel/apic/es7000_32.c      |    7 +++----
 arch/x86/kernel/apic/numaq_32.c       |   11 ++++++++++-
 arch/x86/kernel/apic/probe_32.c       |    2 +-
 arch/x86/kernel/apic/summit_32.c      |   11 +----------
 arch/x86/kernel/apic/x2apic_cluster.c |    1 -
 arch/x86/kernel/apic/x2apic_phys.c    |    1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |    1 -
 arch/x86/kernel/smpboot.c             |    3 +--
 13 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index efb073b..ad30ca4 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,6 @@ struct apic {
 
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
-	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
@@ -367,6 +366,9 @@ struct apic {
 	 * won't be applied properly during early boot in this case.
 	 */
 	int (*x86_32_early_logical_apicid)(int cpu);
+
+	/* determine CPU -> NUMA node mapping */
+	int (*x86_32_numa_cpu_node)(int cpu);
 #endif
 };
 
@@ -539,7 +541,7 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-extern int default_apicid_to_node(int logical_apicid);
+extern int default_x86_32_numa_cpu_node(int cpu);
 
 #endif
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3127079..0f4f3c1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2020,10 +2020,14 @@ void default_init_apic_ldr(void)
 }
 
 #ifdef CONFIG_X86_32
-int default_apicid_to_node(int logical_apicid)
+int default_x86_32_numa_cpu_node(int cpu)
 {
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
+#ifdef CONFIG_NUMA
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+
+	if (apicid != BAD_APICID)
+		return apicid_2_node[apicid];
+	return NUMA_NO_NODE;
 #else
 	return 0;
 #endif
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 5a9d11a..5652d31 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -185,7 +185,6 @@ struct apic apic_flat =  {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
@@ -336,7 +335,6 @@ struct apic apic_physflat =  {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 0309c58..f1baa2d 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -108,12 +108,6 @@ static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_set_cpu(cpu, retmask);
 }
 
-int noop_apicid_to_node(int logical_apicid)
-{
-	/* we're always on node 0 */
-	return 0;
-}
-
 static u32 noop_apic_read(u32 reg)
 {
 	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
@@ -125,6 +119,14 @@ static void noop_apic_write(u32 reg, u32 v)
 	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
+#ifdef CONFIG_X86_32
+static int noop_x86_32_numa_cpu_node(int cpu)
+{
+	/* we're always on node 0 */
+	return 0;
+}
+#endif
+
 struct apic apic_noop = {
 	.name				= "noop",
 	.probe				= noop_probe,
@@ -148,7 +150,6 @@ struct apic apic_noop = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= noop_apicid_to_node,
 
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
@@ -194,5 +195,6 @@ struct apic apic_noop = {
 
 #ifdef CONFIG_X86_32
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_numa_cpu_node		= noop_x86_32_numa_cpu_node,
 #endif
 };
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index bc7ed04..541a2e4 100644
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
@@ -221,7 +216,6 @@ struct apic apic_bigsmp = {
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
@@ -259,4 +253,5 @@ struct apic apic_bigsmp = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
+	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 5c53d05..3e9de48 100644
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
@@ -649,7 +648,6 @@ struct apic __refdata apic_es7000_cluster = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= es7000_apicid_to_node,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -690,6 +688,7 @@ struct apic __refdata apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
+	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
 
 struct apic __refdata apic_es7000 = {
@@ -715,7 +714,6 @@ struct apic __refdata apic_es7000 = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= es7000_apicid_to_node,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -754,4 +752,5 @@ struct apic __refdata apic_es7000 = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
+	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index f1a8b12..6273eee 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -391,6 +391,15 @@ static inline int numaq_apicid_to_node(int logical_apicid)
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
@@ -501,7 +510,6 @@ struct apic __refdata apic_numaq = {
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
-	.apicid_to_node			= numaq_apicid_to_node,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
@@ -541,4 +549,5 @@ struct apic __refdata apic_numaq = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_numa_cpu_node		= numaq_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0f9a9ab..fc84c7b 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -135,7 +135,6 @@ struct apic apic_default = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= default_apicid_to_node,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
@@ -173,6 +172,7 @@ struct apic apic_default = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
+	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
 
 extern struct apic apic_numaq;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 8c91473..e4b8059 100644
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
@@ -523,7 +514,6 @@ struct apic apic_summit = {
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= summit_apicid_to_node,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -561,4 +551,5 @@ struct apic apic_summit = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
+	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index badc1fd..90949bb 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -206,7 +206,6 @@ struct apic apic_x2apic_cluster = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f28bf4c..c7e6d66 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -195,7 +195,6 @@ struct apic apic_x2apic_phys = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 6027620..3c28928 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -338,7 +338,6 @@ struct apic __refdata apic_x2apic_uv_x = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ca20f6b..5319cdd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -168,10 +168,9 @@ static void unmap_cpu_to_node(int cpu)
 static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
-	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 	int node;
 
-	node = apic->apicid_to_node(logical_apicid);
+	node = apic->x86_32_numa_cpu_node(cpu);
 	if (!node_online(node))
 		node = first_online_node;
 
