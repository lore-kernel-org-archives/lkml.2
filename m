Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0K0PZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:25:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:37952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab0K0PWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:22:50 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/16] x86: Use apic->cpu_to_logical_apicid() to find out logical apic id mapping early during boot
Date: Sat, 27 Nov 2010 16:21:57 +0100
Message-Id: <1290871325-3055-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290871325-3055-1-git-send-email-tj@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 15:22:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_32, non-standard logical apicid mapping can be used by
different NUMA setups.  The mapping can be determined while bringing
up each CPU after apic->init_apic_ldr().  The logical apicid is then
used to deliver IPIs and determine NUMA configuration.

Unfortunately, initializing at SMP bring up is too late for percpu
setup making static percpu variables setup w/o considering NUMA.  This
also is different from how x86_64 is configured making the code
difficult to follow and maintain.

Use the unused apic->cpu_to_logical_apicid() to find out the logical
apic id mapping before SMP bring up.  The callback is called once
during get_smp_config() and the output is recorded in
x86_cpu_to_logical_apicid.  apic implementation is free to return
BAD_APICID from the callback if it can't be determined at the time.
The early mapping is later verified and reinitialized during SMP bring
up.

A stub implementation for apic->cpu_to_logical_apicid() is added for
each non-standard apic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/apic.h      |   14 +++++++++++++-
 arch/x86/kernel/apic/apic.c      |   12 ++++++++++--
 arch/x86/kernel/apic/bigsmp_32.c |   10 ++++++++++
 arch/x86/kernel/apic/es7000_32.c |   11 +++++++++++
 arch/x86/kernel/apic/numaq_32.c  |   10 ++++++++++
 arch/x86/kernel/apic/summit_32.c |   10 ++++++++++
 6 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 8b4ef78..70ced53 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -299,6 +299,19 @@ struct apic {
 	unsigned long (*check_apicid_present)(int apicid);
 
 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	/*
+	 * x86_32 specific method called very early during boot from
+	 * get_smp_config().  It should return the logical apicid.
+	 * x86_[bios]_cpu_to_apicid is initialized before this
+	 * function is called.
+	 *
+	 * If logical apicid can't be determined that early, the
+	 * function may return BAD_APICID.  Logical apicid will be
+	 * automatically configured after init_apic_ldr() while
+	 * bringing up CPUs.  Note that NUMA affinity won't work
+	 * properly during early boot in this case.
+	 */
+	int (*cpu_to_logical_apicid)(int cpu);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -306,7 +319,6 @@ struct apic {
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid);
-	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 543bc37..4931b10 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1254,8 +1254,13 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_32
 	/*
-	 * APIC LDR is initialized.  Fetch and store logical_apic_id.
+	 * APIC LDR is initialized.  If logical_apicid mapping was
+	 * initialized during get_smp_config(), make sure it matches
+	 * the actual value.
 	 */
+	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
+	/* always use the value from LDR */
 	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
 		logical_smp_processor_id();
 #endif
@@ -1984,7 +1989,10 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
-
+#ifdef CONFIG_X86_32
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		apic->cpu_to_logical_apicid(cpu);
+#endif
 	set_cpu_possible(cpu, true);
 	set_cpu_present(cpu, true);
 }
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 4c62592..e4d426b 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -45,6 +45,15 @@ static unsigned long bigsmp_check_apicid_present(int bit)
 	return 1;
 }
 
+static int bigsmp_cpu_to_logical_apicid(int cpu)
+{
+	/*
+	 * This is stub implementation which causes static percpu area
+	 * layout to ignore NUMA affinity.
+	 */
+	return BAD_APICID;
+}
+
 static inline unsigned long calculate_ldr(int cpu)
 {
 	unsigned long val, id;
@@ -210,6 +219,7 @@ struct apic apic_bigsmp = {
 	.check_apicid_present		= bigsmp_check_apicid_present,
 
 	.vector_allocation_domain	= bigsmp_vector_allocation_domain,
+	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 6840681..d6199fc 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -460,6 +460,15 @@ static unsigned long es7000_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
+static int es7000_cpu_to_logical_apicid(int cpu)
+{
+	/*
+	 * This is stub implementation which causes static percpu area
+	 * layout to ignore NUMA affinity.
+	 */
+	return BAD_APICID;
+}
+
 static unsigned long calculate_ldr(int cpu)
 {
 	unsigned long id = per_cpu(x86_bios_cpu_apicid, cpu);
@@ -638,6 +647,7 @@ struct apic __refdata apic_es7000_cluster = {
 	.check_apicid_present		= es7000_check_apicid_present,
 
 	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.init_apic_ldr			= es7000_init_apic_ldr_cluster,
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
@@ -702,6 +712,7 @@ struct apic __refdata apic_es7000 = {
 	.check_apicid_present		= es7000_check_apicid_present,
 
 	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.init_apic_ldr			= es7000_init_apic_ldr,
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 2b434d5..49cae83 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -346,6 +346,15 @@ static inline int numaq_apic_id_registered(void)
 	return 1;
 }
 
+static int numaq_cpu_to_logical_apicid(int cpu)
+{
+	/*
+	 * This is stub implementation which causes static percpu area
+	 * layout to ignore NUMA affinity.
+	 */
+	return BAD_APICID;
+}
+
 static inline void numaq_init_apic_ldr(void)
 {
 	/* Already done in NUMA-Q firmware */
@@ -496,6 +505,7 @@ struct apic __refdata apic_numaq = {
 	.check_apicid_present		= numaq_check_apicid_present,
 
 	.vector_allocation_domain	= numaq_vector_allocation_domain,
+	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.init_apic_ldr			= numaq_init_apic_ldr,
 
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 1ef4c14..fc8bf8a 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -194,6 +194,15 @@ static unsigned long summit_check_apicid_present(int bit)
 	return 1;
 }
 
+static int summit_cpu_to_logical_apicid(int cpu)
+{
+	/*
+	 * This is stub implementation which causes static percpu area
+	 * layout to ignore NUMA affinity.
+	 */
+	return BAD_APICID;
+}
+
 static void summit_init_apic_ldr(void)
 {
 	unsigned long val, id;
@@ -511,6 +520,7 @@ struct apic apic_summit = {
 	.check_apicid_present		= summit_check_apicid_present,
 
 	.vector_allocation_domain	= summit_vector_allocation_domain,
+	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.init_apic_ldr			= summit_init_apic_ldr,
 
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
-- 
1.7.1

