Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2FNHuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab2FNHuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:50:01 -0400
Date: Thu, 14 Jun 2012 09:49:55 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/6] x86/apic: Fix ugly casting and branching in
 cpu_mask_to_apicid_and()
Message-ID: <20120614074954.GF3383@dhcp-26-207.brq.redhat.com>
References: <cover.1339657103.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1339657103.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/apic.c        |    8 ++++----
 arch/x86/kernel/apic/es7000_32.c   |    2 +-
 arch/x86/kernel/apic/summit_32.c   |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 048a4f8..c421512 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2127,19 +2127,19 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 				   const struct cpumask *andmask,
 				   unsigned int *apicid)
 {
-	int cpu;
+	unsigned int cpu;
 
 	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
 
-	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+	if (likely(cpu < nr_cpu_ids)) {
 		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
 		return 0;
-	} else {
-		return -EINVAL;
 	}
+
+	return -EINVAL;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 2c5317e..effece2 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -529,7 +529,7 @@ static inline int
 es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
-	int cpu, uninitialized_var(apicid);
+	unsigned int cpu, uninitialized_var(apicid);
 
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index bbad180..b53fd6c 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -267,7 +267,7 @@ static inline int
 summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
-	int cpu, apicid = 0;
+	unsigned int cpu, apicid = 0;
 
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 026de01..8cfade9 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -274,7 +274,7 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			  const struct cpumask *andmask,
 			  unsigned int *apicid)
 {
-	int cpu;
+	int unsigned cpu;
 
 	/*
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
@@ -285,12 +285,12 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+	if (likely(cpu < nr_cpu_ids)) {
 		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
 		return 0;
-	} else {
-		return -EINVAL;
 	}
+
+	return -EINVAL;
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
