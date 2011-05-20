Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab1ETNl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:41:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934290Ab1ETNlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:41:25 -0400
Date: Fri, 20 May 2011 13:41:14 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-a27d0b5e7d913b38880678ac05690f1dc737c4fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110519234637.337024125@sbsiddha-MOBL3.sc.intel.com>
References: <20110519234637.337024125@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, x2apic: Remove duplicate code for IPI mask routines
Git-Commit-ID: a27d0b5e7d913b38880678ac05690f1dc737c4fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:41:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a27d0b5e7d913b38880678ac05690f1dc737c4fd
Gitweb:     http://git.kernel.org/tip/a27d0b5e7d913b38880678ac05690f1dc737c4fd
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 19 May 2011 16:45:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:41:06 +0200

x86, x2apic: Remove duplicate code for IPI mask routines

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: steiner@sgi.com
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110519234637.337024125@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_cluster.c |   48 +++++++++++----------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   45 ++++++++++--------------------
 2 files changed, 31 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 2967bab..b261799 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -54,64 +54,48 @@ static void
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
  * writes.
  */
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+static void
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
 	unsigned long query_cpu;
+	unsigned long this_cpu;
 	unsigned long flags;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
+
+	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
+		if (apic_dest == APIC_DEST_ALLBUT && query_cpu == this_cpu)
+			continue;
 		__x2apic_send_IPI_dest(
 			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 			vector, apic->dest_logical);
 	}
+
 	local_irq_restore(flags);
 }
 
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
 static int x2apic_apic_id_registered(void)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8f21771..6ef49e3 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -55,61 +55,46 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
 	native_x2apic_icr_write(cfg, apicid);
 }
 
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+static void
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
 	unsigned long query_cpu;
+	unsigned long this_cpu;
 	unsigned long flags;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
+
+	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
+		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
+			continue;
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_apicid, query_cpu),
-				vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
-				       vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
 static int x2apic_apic_id_registered(void)
