Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab2FELXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939Ab2FELXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:23:51 -0400
Date: Tue, 5 Jun 2012 13:23:44 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/8] x86: apic: Factor out default cpu_mask_to_apicid()
 operations
Message-ID: <20120605112340.GA11454@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/apic.h          |   13 ++++++++--
 arch/x86/kernel/apic/apic.c          |   28 +++++++++++++++++++++++
 arch/x86/kernel/apic/apic_flat_64.c  |   40 +++------------------------------
 arch/x86/kernel/apic/apic_noop.c     |    4 +-
 arch/x86/kernel/apic/apic_numachip.c |   36 +----------------------------
 arch/x86/kernel/apic/bigsmp_32.c     |   30 +-----------------------
 arch/x86/kernel/apic/probe_32.c      |    4 +-
 arch/x86/kernel/apic/x2apic_phys.c   |   36 +----------------------------
 8 files changed, 52 insertions(+), 139 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5bc64bf..41190ae 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -575,14 +575,14 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 #endif
 
 static inline unsigned int
-default_cpu_mask_to_apicid(const struct cpumask *cpumask)
+flat_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static inline unsigned int
-default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			       const struct cpumask *andmask)
+flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			    const struct cpumask *andmask)
 {
 	unsigned long mask1 = cpumask_bits(cpumask)[0];
 	unsigned long mask2 = cpumask_bits(andmask)[0];
@@ -591,6 +591,13 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
+extern unsigned int
+default_cpu_mask_to_apicid(const struct cpumask *cpumask);
+
+extern unsigned int
+default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			       const struct cpumask *andmask);
+
 static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return physid_isset(apicid, *map);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index edc2448..7dca3ce 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2117,6 +2117,34 @@ void default_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
+unsigned int default_cpu_mask_to_apicid(const struct cpumask *cpumask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	cpu = cpumask_first(cpumask);
+	if (likely((unsigned)cpu < nr_cpu_ids))
+		return per_cpu(x86_cpu_to_apicid, cpu);
+
+	return BAD_APICID;
+}
+
+unsigned int
+default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			       const struct cpumask *andmask)
+{
+	int cpu;
+
+	for_each_cpu_and(cpu, cpumask, andmask) {
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	}
+	return per_cpu(x86_cpu_to_apicid, cpu);
+}
+
 /*
  * Power management
  */
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 5ebaeba..9f778f0 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -205,8 +205,8 @@ static struct apic apic_flat =  {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu << 24,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= flat_send_IPI_mask,
 	.send_IPI_mask_allbutself	= flat_send_IPI_mask_allbutself,
@@ -283,38 +283,6 @@ static void physflat_send_IPI_all(int vector)
 	physflat_send_IPI_mask(cpu_online_mask, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	cpu = cpumask_first(cpumask);
-	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-	else
-		return BAD_APICID;
-}
-
-static unsigned int
-physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-				const struct cpumask *andmask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
-	}
-	return per_cpu(x86_cpu_to_apicid, cpu);
-}
-
 static int physflat_probe(void)
 {
 	if (apic == &apic_physflat || num_possible_cpus() > 8)
@@ -359,8 +327,8 @@ static struct apic apic_physflat =  {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu << 24,
 
-	.cpu_mask_to_apicid		= physflat_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= physflat_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= physflat_send_IPI_mask,
 	.send_IPI_mask_allbutself	= physflat_send_IPI_mask_allbutself,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 634ae6c..fc680d1 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -159,8 +159,8 @@ struct apic apic_noop = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= noop_send_IPI_mask,
 	.send_IPI_mask_allbutself	= noop_send_IPI_mask_allbutself,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 55b5560..6d78c8f 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -152,38 +152,6 @@ static void numachip_send_IPI_self(int vector)
 	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
-static unsigned int numachip_cpu_mask_to_apicid(const struct cpumask *cpumask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	cpu = cpumask_first(cpumask);
-	if (likely((unsigned)cpu < nr_cpu_ids))
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
-}
-
-static unsigned int
-numachip_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-				const struct cpumask *andmask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
-	}
-	return per_cpu(x86_cpu_to_apicid, cpu);
-}
-
 static int __init numachip_probe(void)
 {
 	return apic == &apic_numachip;
@@ -272,8 +240,8 @@ static struct apic apic_numachip __refconst = {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xffU << 24,
 
-	.cpu_mask_to_apicid		= numachip_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= numachip_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= numachip_send_IPI_mask,
 	.send_IPI_mask_allbutself	= numachip_send_IPI_mask_allbutself,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 6915f9d..142f5c2 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -96,32 +96,6 @@ static int bigsmp_check_phys_apicid_present(int phys_apicid)
 	return 1;
 }
 
-/* As we are using single CPU as destination, pick only one CPU here */
-static unsigned int bigsmp_cpu_mask_to_apicid(const struct cpumask *cpumask)
-{
-	int cpu = cpumask_first(cpumask);
-
-	if (cpu < nr_cpu_ids)
-		return cpu_physical_id(cpu);
-	return BAD_APICID;
-}
-
-static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			      const struct cpumask *andmask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			return cpu_physical_id(cpu);
-	}
-	return BAD_APICID;
-}
-
 static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
@@ -220,8 +194,8 @@ static struct apic apic_bigsmp = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= bigsmp_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= bigsmp_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= bigsmp_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index ff2c1b9..0ac67ed 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -123,8 +123,8 @@ static struct apic apic_default = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= default_send_IPI_mask_logical,
 	.send_IPI_mask_allbutself	= default_send_IPI_mask_allbutself_logical,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index ddf5fa8..beab139 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -76,38 +76,6 @@ static void x2apic_send_IPI_all(int vector)
 	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
-{
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	int cpu = cpumask_first(cpumask);
-
-	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-	else
-		return BAD_APICID;
-}
-
-static unsigned int
-x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			      const struct cpumask *andmask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
-	}
-
-	return per_cpu(x86_cpu_to_apicid, cpu);
-}
-
 static void init_x2apic_ldr(void)
 {
 }
@@ -155,8 +123,8 @@ static struct apic apic_x2apic_phys = {
 	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
-	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= x2apic_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= x2apic_send_IPI_mask,
 	.send_IPI_mask_allbutself	= x2apic_send_IPI_mask_allbutself,
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
