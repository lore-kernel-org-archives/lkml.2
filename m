Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab1D2P3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab1D2P3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=U3LXZSVy5utf2eDgNYhAde5zHknosuLKuW/hRdEG0n4kamFWK9AxJ+MAufzB7Fh3o/
         Wc2gb+056Adr/8hZ/VNUaf0f7cfR2fXauwqoembGo+QZxEvFVa3/LGwwz8J65PmruHlc
         xE8H51elAuhgD5d7EBimpU6/dFQmKItpzK4cM=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/25] x86-32, NUMA: Make apic->x86_32_numa_cpu_node() optional
Date: Fri, 29 Apr 2011 17:28:25 +0200
Message-Id: <1304090924-8197-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMAQ is the only meaningful user of this callback and
setup_local_APIC() the only callsite.  Stop torturing everyone else by
making the callback optional and removing all the boilerplate
implementations and assignments.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/apic.h      |    9 ++++++---
 arch/x86/kernel/apic/apic.c      |   20 +++-----------------
 arch/x86/kernel/apic/apic_noop.c |    9 ---------
 arch/x86/kernel/apic/bigsmp_32.c |    1 -
 arch/x86/kernel/apic/es7000_32.c |    7 -------
 arch/x86/kernel/apic/probe_32.c  |    1 -
 arch/x86/kernel/apic/summit_32.c |    1 -
 7 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2b7d573..a0c46f0 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -363,7 +363,12 @@ struct apic {
 	 */
 	int (*x86_32_early_logical_apicid)(int cpu);
 
-	/* determine CPU -> NUMA node mapping */
+	/*
+	 * Optional method called from setup_local_APIC() after logical
+	 * apicid is guaranteed to be known to initialize apicid -> node
+	 * mapping if NUMA initialization hasn't done so already.  Don't
+	 * add new users.
+	 */
 	int (*x86_32_numa_cpu_node)(int cpu);
 #endif
 };
@@ -537,8 +542,6 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-extern int default_x86_32_numa_cpu_node(int cpu);
-
 #endif
 
 static inline unsigned int
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a6cd02a..0c67b4f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1245,8 +1245,9 @@ void __cpuinit setup_local_APIC(void)
 	 * a bit too late - percpu allocation has already happened without
 	 * proper NUMA affinity.
 	 */
-	set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
-			   apic->x86_32_numa_cpu_node(cpu));
+	if (apic->x86_32_numa_cpu_node)
+		set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
+				   apic->x86_32_numa_cpu_node(cpu));
 #endif
 
 	/*
@@ -2013,21 +2014,6 @@ void default_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-#ifdef CONFIG_X86_32
-int default_x86_32_numa_cpu_node(int cpu)
-{
-#ifdef CONFIG_NUMA
-	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-
-	if (apicid != BAD_APICID)
-		return __apicid_to_node[apicid];
-	return NUMA_NO_NODE;
-#else
-	return 0;
-#endif
-}
-#endif
-
 /*
  * Power management
  */
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index f1baa2d..775b82b 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -119,14 +119,6 @@ static void noop_apic_write(u32 reg, u32 v)
 	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
-#ifdef CONFIG_X86_32
-static int noop_x86_32_numa_cpu_node(int cpu)
-{
-	/* we're always on node 0 */
-	return 0;
-}
-#endif
-
 struct apic apic_noop = {
 	.name				= "noop",
 	.probe				= noop_probe,
@@ -195,6 +187,5 @@ struct apic apic_noop = {
 
 #ifdef CONFIG_X86_32
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
-	.x86_32_numa_cpu_node		= noop_x86_32_numa_cpu_node,
 #endif
 };
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 541a2e4..d84ac5a 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -253,5 +253,4 @@ struct apic apic_bigsmp = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
-	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 3e9de48..70533de 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -510,11 +510,6 @@ static void es7000_setup_apic_routing(void)
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
 }
 
-static int es7000_numa_cpu_node(int cpu)
-{
-	return 0;
-}
-
 static int es7000_cpu_present_to_apicid(int mps_cpu)
 {
 	if (!mps_cpu)
@@ -688,7 +683,6 @@ struct apic __refdata apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
-	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
 
 struct apic __refdata apic_es7000 = {
@@ -752,5 +746,4 @@ struct apic __refdata apic_es7000 = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
-	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index fc84c7b..6541e47 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -172,7 +172,6 @@ struct apic apic_default = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
-	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
 
 extern struct apic apic_numaq;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index e4b8059..35bcd7d 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -551,5 +551,4 @@ struct apic apic_summit = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
-	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
-- 
1.7.1

