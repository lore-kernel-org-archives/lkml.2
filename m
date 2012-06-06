Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2FFP5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:57:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab2FFP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:57:09 -0400
Date: Wed, 6 Jun 2012 08:56:56 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-6uc3wk5s9udxtdl9cnku0vtt@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, lkml.alex@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, lkml.alex@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Validate assumptions in sched_init_numa(
 )
Git-Commit-ID: d039ac60800fe8ed8522ec3b9ca796aaf748c18b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:57:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d039ac60800fe8ed8522ec3b9ca796aaf748c18b
Gitweb:     http://git.kernel.org/tip/d039ac60800fe8ed8522ec3b9ca796aaf748c18b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 31 May 2012 21:20:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:52:30 +0200

sched: Validate assumptions in sched_init_numa()

Add some code to validate assumptions we're making and output
warnings if they are not.

If this trigger we want to know about it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <lkml.alex@gmail.com>
Link: http://lkml.kernel.org/n/tip-6uc3wk5s9udxtdl9cnku0vtt@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   99 +++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 80 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 725ee7c..2bdd176 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5556,15 +5556,20 @@ static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
 
 #ifdef CONFIG_SCHED_DEBUG
 
-static __read_mostly int sched_domain_debug_enabled;
+static __read_mostly int sched_debug_enabled;
 
-static int __init sched_domain_debug_setup(char *str)
+static int __init sched_debug_setup(char *str)
 {
-	sched_domain_debug_enabled = 1;
+	sched_debug_enabled = 1;
 
 	return 0;
 }
-early_param("sched_debug", sched_domain_debug_setup);
+early_param("sched_debug", sched_debug_setup);
+
+static inline bool sched_debug(void)
+{
+	return sched_debug_enabled;
+}
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
@@ -5657,7 +5662,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
 	int level = 0;
 
-	if (!sched_domain_debug_enabled)
+	if (!sched_debug_enabled)
 		return;
 
 	if (!sd) {
@@ -5678,6 +5683,10 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
+static inline bool sched_debug(void)
+{
+	return false;
+}
 #endif /* CONFIG_SCHED_DEBUG */
 
 static int sd_degenerate(struct sched_domain *sd)
@@ -6373,7 +6382,6 @@ static struct sched_domain_topology_level *sched_domain_topology = default_topol
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
-static int sched_domains_numa_scale;
 static int *sched_domains_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
@@ -6438,6 +6446,42 @@ static const struct cpumask *sd_numa_mask(int cpu)
 	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
 }
 
+static void sched_numa_warn(const char *str)
+{
+	static int done = false;
+	int i,j;
+
+	if (done)
+		return;
+
+	done = true;
+
+	printk(KERN_WARNING "ERROR: %s\n\n", str);
+
+	for (i = 0; i < nr_node_ids; i++) {
+		printk(KERN_WARNING "  ");
+		for (j = 0; j < nr_node_ids; j++)
+			printk(KERN_CONT "%02d ", node_distance(i,j));
+		printk(KERN_CONT "\n");
+	}
+	printk(KERN_WARNING "\n");
+}
+
+static bool find_numa_distance(int distance)
+{
+	int i;
+
+	if (distance == node_distance(0, 0))
+		return true;
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		if (sched_domains_numa_distance[i] == distance)
+			return true;
+	}
+
+	return false;
+}
+
 static void sched_init_numa(void)
 {
 	int next_distance, curr_distance = node_distance(0, 0);
@@ -6445,7 +6489,6 @@ static void sched_init_numa(void)
 	int level = 0;
 	int i, j, k;
 
-	sched_domains_numa_scale = curr_distance;
 	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
 	if (!sched_domains_numa_distance)
 		return;
@@ -6456,23 +6499,41 @@ static void sched_init_numa(void)
 	 *
 	 * Assumes node_distance(0,j) includes all distances in
 	 * node_distance(i,j) in order to avoid cubic time.
-	 *
-	 * XXX: could be optimized to O(n log n) by using sort()
 	 */
 	next_distance = curr_distance;
 	for (i = 0; i < nr_node_ids; i++) {
 		for (j = 0; j < nr_node_ids; j++) {
-			int distance = node_distance(0, j);
-			if (distance > curr_distance &&
-					(distance < next_distance ||
-					 next_distance == curr_distance))
-				next_distance = distance;
+			for (k = 0; k < nr_node_ids; k++) {
+				int distance = node_distance(i, k);
+
+				if (distance > curr_distance &&
+				    (distance < next_distance ||
+				     next_distance == curr_distance))
+					next_distance = distance;
+
+				/*
+				 * While not a strong assumption it would be nice to know
+				 * about cases where if node A is connected to B, B is not
+				 * equally connected to A.
+				 */
+				if (sched_debug() && node_distance(k, i) != distance)
+					sched_numa_warn("Node-distance not symmetric");
+
+				if (sched_debug() && i && !find_numa_distance(distance))
+					sched_numa_warn("Node-0 not representative");
+			}
+			if (next_distance != curr_distance) {
+				sched_domains_numa_distance[level++] = next_distance;
+				sched_domains_numa_levels = level;
+				curr_distance = next_distance;
+			} else break;
 		}
-		if (next_distance != curr_distance) {
-			sched_domains_numa_distance[level++] = next_distance;
-			sched_domains_numa_levels = level;
-			curr_distance = next_distance;
-		} else break;
+
+		/*
+		 * In case of sched_debug() we verify the above assumption.
+		 */
+		if (!sched_debug())
+			break;
 	}
 	/*
 	 * 'level' contains the number of unique distances, excluding the
