Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1A1Oje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:39:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:59985 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1A1Ojc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:39:32 -0500
Date: Fri, 28 Jan 2011 14:39:08 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-7-git-send-email-tj@kernel.org>
References: <1295789862-25482-7-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Kill apic->cpu_to_logical_apicid()
Message-ID: <tip-7632611f534340182c832d2b139cb19676f24e1a@git.kernel.org>
Git-Commit-ID: 7632611f534340182c832d2b139cb19676f24e1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:39:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7632611f534340182c832d2b139cb19676f24e1a
Gitweb:     http://git.kernel.org/tip/7632611f534340182c832d2b139cb19676f24e1a
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:06 +0100

x86: Kill apic->cpu_to_logical_apicid()

After the previous patch, apic->cpu_to_logical_apicid() is no
longer used.  Kill it.

For apic types with custom cpu_to_logical_apicid() which is also
used for other purposes, remove the function and modify its
users to do the mapping directly.

#ifdef's on CONFIG_SMP in es7000_32 and summit_32 are ignored
during conversion as they are not used for UP kernels.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-7-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h           |    7 -------
 arch/x86/kernel/apic/apic_flat_64.c   |    2 --
 arch/x86/kernel/apic/apic_noop.c      |    6 ------
 arch/x86/kernel/apic/bigsmp_32.c      |   19 +++++++------------
 arch/x86/kernel/apic/es7000_32.c      |   18 ++----------------
 arch/x86/kernel/apic/numaq_32.c       |    8 --------
 arch/x86/kernel/apic/probe_32.c       |    1 -
 arch/x86/kernel/apic/summit_32.c      |   17 ++---------------
 arch/x86/kernel/apic/x2apic_cluster.c |    1 -
 arch/x86/kernel/apic/x2apic_phys.c    |    1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |    1 -
 11 files changed, 11 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eb139ec..d1aa0c3 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -307,7 +307,6 @@ struct apic {
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid);
-	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
@@ -557,12 +556,6 @@ static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_ma
 	*retmap = *phys_map;
 }
 
-/* Mapping from cpu number to logical apicid */
-static inline int default_cpu_to_logical_apicid(int cpu)
-{
-	return 1 << cpu;
-}
-
 static inline int __default_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 09d3b17..5a9d11a 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -186,7 +186,6 @@ struct apic apic_flat =  {
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
@@ -338,7 +337,6 @@ struct apic apic_physflat =  {
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index e31b9ff..f3d19b2 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -54,11 +54,6 @@ static u64 noop_apic_icr_read(void)
 	return 0;
 }
 
-static int noop_cpu_to_logical_apicid(int cpu)
-{
-	return 0;
-}
-
 static int noop_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return 0;
@@ -155,7 +150,6 @@ struct apic apic_noop = {
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= noop_apicid_to_node,
 
-	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index cb804c5..4c62592 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -93,14 +93,6 @@ static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 	return BAD_APICID;
 }
 
-/* Mapping from cpu number to logical apicid */
-static inline int bigsmp_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_physical_id(cpu);
-}
-
 static void bigsmp_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
@@ -115,7 +107,11 @@ static int bigsmp_check_phys_apicid_present(int phys_apicid)
 /* As we are using single CPU as destination, pick only one CPU here */
 static unsigned int bigsmp_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return bigsmp_cpu_to_logical_apicid(cpumask_first(cpumask));
+	int cpu = cpumask_first(cpumask);
+
+	if (cpu < nr_cpu_ids)
+		return cpu_physical_id(cpu);
+	return BAD_APICID;
 }
 
 static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
@@ -129,9 +125,9 @@ static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 */
 	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
+			return cpu_physical_id(cpu);
 	}
-	return bigsmp_cpu_to_logical_apicid(cpu);
+	return BAD_APICID;
 }
 
 static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
@@ -220,7 +216,6 @@ struct apic apic_bigsmp = {
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= bigsmp_apicid_to_node,
-	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 7cb73e1..6840681 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -528,18 +528,6 @@ static void es7000_apicid_to_cpu_present(int phys_apicid, physid_mask_t *retmap)
 	++cpu_id;
 }
 
-/* Mapping from cpu number to logical apicid */
-static int es7000_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
 static void es7000_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
@@ -561,7 +549,7 @@ static unsigned int es7000_cpu_mask_to_apicid(const struct cpumask *cpumask)
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu(cpu, cpumask) {
-		int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			WARN(1, "Not a valid mask!");
@@ -578,7 +566,7 @@ static unsigned int
 es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
-	int apicid = es7000_cpu_to_logical_apicid(0);
+	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
@@ -656,7 +644,6 @@ struct apic __refdata apic_es7000_cluster = {
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= es7000_apicid_to_node,
-	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -721,7 +708,6 @@ struct apic __refdata apic_es7000 = {
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= es7000_apicid_to_node,
-	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 4ed90c4..2b434d5 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -373,13 +373,6 @@ static inline void numaq_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask
 	return physids_promote(0xFUL, retmap);
 }
 
-static inline int numaq_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-}
-
 /*
  * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
  * cpu to APIC ID relation to properly interact with the intelligent
@@ -509,7 +502,6 @@ struct apic __refdata apic_numaq = {
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
 	.apicid_to_node			= numaq_apicid_to_node,
-	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 99d2fe0..24a6828 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -131,7 +131,6 @@ struct apic apic_default = {
 	.setup_apic_routing		= setup_apic_flat_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
-	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 82cfc3e..1ef4c14 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -241,18 +241,6 @@ static int summit_apicid_to_node(int logical_apicid)
 #endif
 }
 
-/* Mapping from cpu number to logical apicid */
-static inline int summit_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
 static int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
@@ -286,7 +274,7 @@ static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu(cpu, cpumask) {
-		int new_apicid = summit_cpu_to_logical_apicid(cpu);
+		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			printk("%s: Not a valid mask!\n", __func__);
@@ -301,7 +289,7 @@ static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 static unsigned int summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
-	int apicid = summit_cpu_to_logical_apicid(0);
+	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
@@ -529,7 +517,6 @@ struct apic apic_summit = {
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= summit_apicid_to_node,
-	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index cf69c59..badc1fd 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -207,7 +207,6 @@ struct apic apic_x2apic_cluster = {
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8972f38..f28bf4c 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -196,7 +196,6 @@ struct apic apic_x2apic_phys = {
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index bd16b58..6027620 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -339,7 +339,6 @@ struct apic __refdata apic_x2apic_uv_x = {
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
