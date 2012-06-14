Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2FNOqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:46:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2FNOqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:46:45 -0400
Date: Thu, 14 Jun 2012 07:46:30 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-a5a391561bc25898ba1a702a0c4b028aa5b11ce9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120614074935.GE3383@dhcp-26-207.brq.redhat.com>
References: <20120614074935.GE3383@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Eliminate cpu_mask_to_apicid() operation
Git-Commit-ID: a5a391561bc25898ba1a702a0c4b028aa5b11ce9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:46:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5a391561bc25898ba1a702a0c4b028aa5b11ce9
Gitweb:     http://git.kernel.org/tip/a5a391561bc25898ba1a702a0c4b028aa5b11ce9
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 14 Jun 2012 09:49:35 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:53:13 +0200

x86/apic: Eliminate cpu_mask_to_apicid() operation

Since there are only two locations where cpu_mask_to_apicid() is
called from, remove the operation and use only
cpu_mask_to_apicid_and() instead.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Suggested-and-acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120614074935.GE3383@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |   33 ++++++++-------------------------
 arch/x86/kernel/apic/apic.c           |   24 ++++++------------------
 arch/x86/kernel/apic/apic_flat_64.c   |    2 --
 arch/x86/kernel/apic/apic_noop.c      |    1 -
 arch/x86/kernel/apic/apic_numachip.c  |    1 -
 arch/x86/kernel/apic/bigsmp_32.c      |    1 -
 arch/x86/kernel/apic/es7000_32.c      |    4 +---
 arch/x86/kernel/apic/io_apic.c        |    3 ++-
 arch/x86/kernel/apic/numaq_32.c       |    8 --------
 arch/x86/kernel/apic/probe_32.c       |    1 -
 arch/x86/kernel/apic/summit_32.c      |    3 +--
 arch/x86/kernel/apic/x2apic_cluster.c |   17 -----------------
 arch/x86/kernel/apic/x2apic_phys.c    |    1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |   29 ++++++-----------------------
 arch/x86/platform/uv/uv_irq.c         |    2 +-
 15 files changed, 25 insertions(+), 105 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1ed3eea..eec240e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -331,8 +331,6 @@ struct apic {
 	unsigned long (*set_apic_id)(unsigned int id);
 	unsigned long apic_id_mask;
 
-	int (*cpu_mask_to_apicid)(const struct cpumask *cpumask,
-				  unsigned int *apicid);
 	int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
 				      const struct cpumask *andmask,
 				      unsigned int *apicid);
@@ -594,9 +592,15 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 #endif
 
 static inline int
-__flat_cpu_mask_to_apicid(unsigned long cpu_mask, unsigned int *apicid)
+flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			    const struct cpumask *andmask,
+			    unsigned int *apicid)
 {
-	cpu_mask = cpu_mask & APIC_ALL_CPUS & cpumask_bits(cpu_online_mask)[0];
+	unsigned long cpu_mask = cpumask_bits(cpumask)[0] &
+				 cpumask_bits(andmask)[0] &
+				 cpumask_bits(cpu_online_mask)[0] &
+				 APIC_ALL_CPUS;
+
 	if (likely(cpu_mask)) {
 		*apicid = (unsigned int)cpu_mask;
 		return 0;
@@ -605,27 +609,6 @@ __flat_cpu_mask_to_apicid(unsigned long cpu_mask, unsigned int *apicid)
 	}
 }
 
-static inline int
-flat_cpu_mask_to_apicid(const struct cpumask *cpumask,
-			unsigned int *apicid)
-{
-	return __flat_cpu_mask_to_apicid(cpumask_bits(cpumask)[0], apicid);
-}
-
-static inline int
-flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			    const struct cpumask *andmask,
-			    unsigned int *apicid)
-{
-	unsigned long mask1 = cpumask_bits(cpumask)[0];
-	unsigned long mask2 = cpumask_bits(andmask)[0];
-	return __flat_cpu_mask_to_apicid(mask1 & mask2, apicid);
-}
-
-extern int
-default_cpu_mask_to_apicid(const struct cpumask *cpumask,
-			   unsigned int *apicid);
-
 extern int
 default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       const struct cpumask *andmask,
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7e9bbe7..048a4f8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2123,23 +2123,6 @@ void default_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline int __default_cpu_to_apicid(int cpu, unsigned int *apicid)
-{
-	if (likely((unsigned int)cpu < nr_cpu_ids)) {
-		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
-		return 0;
-	} else {
-		return -EINVAL;
-	}
-}
-
-int default_cpu_mask_to_apicid(const struct cpumask *cpumask,
-			       unsigned int *apicid)
-{
-	int cpu = cpumask_first_and(cpumask, cpu_online_mask);
-	return __default_cpu_to_apicid(cpu, apicid);
-}
-
 int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 				   const struct cpumask *andmask,
 				   unsigned int *apicid)
@@ -2151,7 +2134,12 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	return __default_cpu_to_apicid(cpu, apicid);
+	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
+		return 0;
+	} else {
+		return -EINVAL;
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index bddc925..00c77cf 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -191,7 +191,6 @@ static struct apic apic_flat =  {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu << 24,
 
-	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= flat_send_IPI_mask,
@@ -308,7 +307,6 @@ static struct apic apic_physflat =  {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu << 24,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= physflat_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index ac9edf2..65c07fc 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -159,7 +159,6 @@ struct apic apic_noop = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= noop_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index c028132..bc552cf 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -234,7 +234,6 @@ static struct apic apic_numachip __refconst = {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xffU << 24,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= numachip_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index df342fe..d50e364 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -188,7 +188,6 @@ static struct apic apic_bigsmp = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= bigsmp_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index b35cfb9..2c5317e 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -525,7 +525,7 @@ static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 	return 1;
 }
 
-static int
+static inline int
 es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
@@ -643,7 +643,6 @@ static struct apic __refdata apic_es7000_cluster = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= es7000_send_IPI_mask,
@@ -710,7 +709,6 @@ static struct apic __refdata apic_es7000 = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= es7000_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0deb773..0540f08 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1492,7 +1492,8 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	 * We use logical delivery to get the timer IRQ
 	 * to the first CPU.
 	 */
-	if (unlikely(apic->cpu_mask_to_apicid(apic->target_cpus(), &dest)))
+	if (unlikely(apic->cpu_mask_to_apicid_and(apic->target_cpus(),
+						  apic->target_cpus(), &dest)))
 		dest = BAD_APICID;
 
 	entry.dest_mode = apic->irq_dest_mode;
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 2b55514..d661ee9 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -407,13 +407,6 @@ static inline int numaq_check_phys_apicid_present(int phys_apicid)
  * physical broadcast to stop people from breaking us
  */
 static int
-numaq_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
-{
-	*apicid = 0x0F;
-	return 0;
-}
-
-static int
 numaq_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			     const struct cpumask *andmask,
 			     unsigned int *apicid)
@@ -499,7 +492,6 @@ static struct apic __refdata apic_numaq = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= numaq_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= numaq_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= numaq_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 2c6f003..eef6bcd 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -108,7 +108,6 @@ static struct apic apic_default = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= default_send_IPI_mask_logical,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 79d360f..bbad180 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -263,7 +263,7 @@ static int summit_check_phys_apicid_present(int physical_apicid)
 	return 1;
 }
 
-static int
+static inline int
 summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
@@ -516,7 +516,6 @@ static struct apic apic_summit = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= summit_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= summit_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= summit_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 1885a73..943d03f 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -97,22 +97,6 @@ static void x2apic_send_IPI_all(int vector)
 }
 
 static int
-x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
-{
-	int cpu = cpumask_first_and(cpumask, cpu_online_mask);
-	int i;
-
-	if (cpu >= nr_cpu_ids)
-		return -EINVAL;
-
-	*apicid = 0;
-	for_each_cpu_and(i, cpumask, per_cpu(cpus_in_cluster, cpu))
-		*apicid |= per_cpu(x86_cpu_to_logical_apicid, i);
-
-	return 0;
-}
-
-static int
 x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			      const struct cpumask *andmask,
 			      unsigned int *apicid)
@@ -270,7 +254,6 @@ static struct apic apic_x2apic_cluster = {
 	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
-	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= x2apic_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= x2apic_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f109388..e03a1e1 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -123,7 +123,6 @@ static struct apic apic_x2apic_phys = {
 	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= x2apic_send_IPI_mask,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 307aa07..026de01 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -269,27 +269,6 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static inline int __uv_cpu_to_apicid(int cpu, unsigned int *apicid)
-{
-	if (likely((unsigned int)cpu < nr_cpu_ids)) {
-		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
-		return 0;
-	} else {
-		return -EINVAL;
-	}
-}
-
-static int
-uv_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
-{
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	int cpu = cpumask_first_and(cpumask, cpu_online_mask);
-	return __uv_cpu_to_apicid(cpu, apicid);
-}
-
 static int
 uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			  const struct cpumask *andmask,
@@ -306,7 +285,12 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	return __uv_cpu_to_apicid(cpu, apicid);
+	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
@@ -384,7 +368,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
-	.cpu_mask_to_apicid		= uv_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= uv_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= uv_send_IPI_mask,
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index dd1ff39..a67c7a6 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -144,7 +144,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	if (err != 0)
 		return err;
 
-	err = apic->cpu_mask_to_apicid(eligible_cpu, &dest);
+	err = apic->cpu_mask_to_apicid_and(eligible_cpu, eligible_cpu, &dest);
 	if (err != 0)
 		return err;
 
