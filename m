Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2FFPGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:06:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2FFPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:06:46 -0400
Date: Wed, 6 Jun 2012 08:06:34 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-bf721d3a3bc7a731add45c8078b142b494ab413e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120605112324.GA11449@dhcp-26-207.brq.redhat.com>
References: <20120605112324.GA11449@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Factor out default target_cpus()
  operation
Git-Commit-ID: bf721d3a3bc7a731add45c8078b142b494ab413e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:06:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf721d3a3bc7a731add45c8078b142b494ab413e
Gitweb:     http://git.kernel.org/tip/bf721d3a3bc7a731add45c8078b142b494ab413e
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Tue, 5 Jun 2012 13:23:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 10:22:17 +0200

x86/apic: Factor out default target_cpus() operation

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120605112324.GA11449@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |    5 +++++
 arch/x86/include/asm/x2apic.h         |    9 ---------
 arch/x86/kernel/apic/apic_flat_64.c   |   14 ++------------
 arch/x86/kernel/apic/apic_numachip.c  |    7 +------
 arch/x86/kernel/apic/bigsmp_32.c      |   11 +----------
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    7 +------
 8 files changed, 12 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eaff479..fc38195 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -537,6 +537,11 @@ static inline const struct cpumask *default_target_cpus(void)
 #endif
 }
 
+static inline const struct cpumask *online_target_cpus(void)
+{
+	return cpu_online_mask;
+}
+
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
 
diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
index 7a5a832..f90f0a5 100644
--- a/arch/x86/include/asm/x2apic.h
+++ b/arch/x86/include/asm/x2apic.h
@@ -9,15 +9,6 @@
 #include <asm/ipi.h>
 #include <linux/cpumask.h>
 
-/*
- * Need to use more than cpu 0, because we need more vectors
- * when MSI-X are used.
- */
-static const struct cpumask *x2apic_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static int x2apic_apic_id_valid(int apicid)
 {
 	return 1;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index de279b3..61ac1af 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -36,11 +36,6 @@ static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 1;
 }
 
-static const struct cpumask *flat_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -186,7 +181,7 @@ static struct apic apic_flat =  {
 	.irq_delivery_mode		= dest_LowestPrio,
 	.irq_dest_mode			= 1, /* logical */
 
-	.target_cpus			= flat_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
@@ -262,11 +257,6 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static const struct cpumask *physflat_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
@@ -345,7 +335,7 @@ static struct apic apic_physflat =  {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= physflat_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 6ec6d5d..3255a60 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -72,11 +72,6 @@ static int numachip_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
-static const struct cpumask *numachip_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void numachip_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
@@ -253,7 +248,7 @@ static struct apic apic_numachip __refconst = {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= numachip_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 31fbdbf..c288e81 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -26,15 +26,6 @@ static int bigsmp_apic_id_registered(void)
 	return 1;
 }
 
-static const struct cpumask *bigsmp_target_cpus(void)
-{
-#ifdef CONFIG_SMP
-	return cpu_online_mask;
-#else
-	return cpumask_of(0);
-#endif
-}
-
 static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
@@ -205,7 +196,7 @@ static struct apic apic_bigsmp = {
 	/* phys delivery to target CPU: */
 	.irq_dest_mode			= 0,
 
-	.target_cpus			= bigsmp_target_cpus,
+	.target_cpus			= default_target_cpus,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= bigsmp_check_apicid_used,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 2919e45..612622c 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -241,7 +241,7 @@ static struct apic apic_x2apic_cluster = {
 	.irq_delivery_mode		= dest_LowestPrio,
 	.irq_dest_mode			= 1, /* logical */
 
-	.target_cpus			= x2apic_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 93b2570..b1a8b39 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -140,7 +140,7 @@ static struct apic apic_x2apic_phys = {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= x2apic_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c6d03f7..16efb92 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -185,11 +185,6 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-static const struct cpumask *uv_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
 static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
@@ -362,7 +357,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 0, /* physical */
 
-	.target_cpus			= uv_target_cpus,
+	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
