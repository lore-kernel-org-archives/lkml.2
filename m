Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2GFLaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:30:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2GFLaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:30:11 -0400
Date: Fri, 6 Jul 2012 04:29:57 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-d872818dbbeed1bccf58c7f8c7db432154c802f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, gorcunov@openvz.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1340656709-11423-4-git-send-email-suresh.b.siddha@intel.com>
References: <1340656709-11423-4-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/apic/x2apic:
  Use multiple cluster members for the irq destination only with the explicit affinity
Git-Commit-ID: d872818dbbeed1bccf58c7f8c7db432154c802f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:30:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d872818dbbeed1bccf58c7f8c7db432154c802f9
Gitweb:     http://git.kernel.org/tip/d872818dbbeed1bccf58c7f8c7db432154c802f9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 25 Jun 2012 13:38:29 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 11:00:23 +0200

x86/apic/x2apic: Use multiple cluster members for the irq destination only with the explicit affinity

During boot or driver load etc, interrupt destination is setup
using default target cpu's. Later the user (irqbalance etc) or
the driver (irq_set_affinity/ irq_set_affinity_hint) can request
the interrupt to be migrated to some specific set of cpu's.

In the x2apic cluster routing, for the default scenario use
single cpu as the interrupt destination and when there is an
explicit interrupt affinity request, route the interrupt to
multiple members of a x2apic cluster specified in the cpumask of
the migration request.

This will minmize the vector pressure when there are lot of
interrupt sources and relatively few x2apic clusters (for
example a single socket server). This will allow the performance
critical interrupts to be routed to multiple cpu's in the x2apic
cluster (irqbalance for example uses the cache siblings etc
while specifying the interrupt destination) and allow
non-critical interrupts to be serviced by a single logical cpu.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/r/1340656709-11423-4-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/x2apic_cluster.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index bde78d0..c88baa4 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -209,13 +209,30 @@ static int x2apic_cluster_probe(void)
 		return 0;
 }
 
+static const struct cpumask *x2apic_cluster_target_cpus(void)
+{
+	return cpu_all_mask;
+}
+
 /*
  * Each x2apic cluster is an allocation domain.
  */
 static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask,
 					     const struct cpumask *mask)
 {
-	cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
+	/*
+	 * To minimize vector pressure, default case of boot, device bringup
+	 * etc will use a single cpu for the interrupt destination.
+	 *
+	 * On explicit migration requests coming from irqbalance etc,
+	 * interrupts will be routed to the x2apic cluster (cluster-id
+	 * derived from the first cpu in the mask) members specified
+	 * in the mask.
+	 */
+	if (mask == x2apic_cluster_target_cpus())
+		cpumask_copy(retmask, cpumask_of(cpu));
+	else
+		cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 }
 
 static struct apic apic_x2apic_cluster = {
@@ -229,7 +246,7 @@ static struct apic apic_x2apic_cluster = {
 	.irq_delivery_mode		= dest_LowestPrio,
 	.irq_dest_mode			= 1, /* logical */
 
-	.target_cpus			= online_target_cpus,
+	.target_cpus			= x2apic_cluster_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
