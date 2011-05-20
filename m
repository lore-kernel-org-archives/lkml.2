Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1ETUfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:35:07 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34896 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757705Ab1ETU3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:29:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=geoffthorpe.net;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=c8ahoZmc9Rz96pai70tF7O9tlemo07zNq166+uuNlPO9KbY9Ll5UzRn5lKOzDIr2xQQ6NGHN6zQYVwmGJdbYR3QM1ZMsh3nmFSgyYJvyNFplWj/12LudylICFXf2BHAM;
From: Geoff Thorpe <geoff@geoffthorpe.net>
To: linux-kernel@vger.kernel.org
Cc: Geoff Thorpe <geoff@geoffthorpe.net>
Subject: [PATCH] sched: track "isolated" cpus like other cpu masks.
Date: Fri, 20 May 2011 16:29:34 -0400
Message-Id: <1305923374-13274-1-git-send-email-geoff@geoffthorpe.net>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1644:host132.hostmonster.com:geofftho:geoffthorpe.com} {sentby:smtp auth 208.111.65.4 authed with geoff@geoffthorpe.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a subset of cpus have been isolated, it can be useful for subsystems
or drivers that have cpu-affinity concerns to have access to this mask
(just like the other cpu masks; "possible", "present", "active" and
"online"). Eg. to provide specific handling for isolated cpus, or to
determine the non-isolated cpus (which is what sched.c uses it for).

Signed-off-by: Geoff Thorpe <geoff@geoffthorpe.net>
---

 Hi - please CC me on any replies as I'm not subscribed.

 As part of some work I'm doing, I was using an "isolcpus=" boot-arg to
 control scheduling of user processes, and using this patch to allow my
 driver to obtain the corresponding cpu-mask and make adaptations. That
 isolation awareness was a temporary hack in my driver, and I no longer
 need it, but as part of that work I make the following tidy-up of the
 "isolated" cpu-mask, which I think is an improvement on the existing
 code.

 Right now, all the cpu-masks except "cpu_isolated_map" are statically
 instantiated in kernel/cpu.c. OTOH the isolated mask is internal to
 kernel/sched.c and dynamically allocated, either from bootmem in a
 __setup() hook or later via a zalloc(GFP_NOWAIT) within sched_init(). So
 I think this simplifies things; using the same non-dynamic declaration
 for the isolated mask as the other masks, and providing visibility to it
 beyond sched.c. However I'm working only with one relatively simple arch,
 so perhaps I'm overlooking some portability or scalability considerations
 in sched.c? TIA for any tips.

 NB, this patch is against Linus' tree, node: 257313b2...

 Cheers,
 Geoff

 include/linux/cpumask.h |   11 ++++++++++-
 kernel/cpu.c            |   30 ++++++++++++++++++++++++++++++
 kernel/sched.c          |   22 +++-------------------
 3 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index bae6fe2..6c05ad5 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -37,12 +37,13 @@ extern int nr_cpu_ids;
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present, active and online cpus.
+ * possible, present, active, online, and isolated cpus.
  *
  *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
  *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
  *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
  *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
+ *     cpu_isolated_mask - has bit 'cpu' set iff cpu is isolated
  *
  *  If !CONFIG_HOTPLUG_CPU, present == possible, and active == online.
  *
@@ -79,25 +80,30 @@ extern const struct cpumask *const cpu_possible_mask;
 extern const struct cpumask *const cpu_online_mask;
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
+extern const struct cpumask *const cpu_isolated_mask;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
 #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
+#define num_isolated_cpus()	cpumask_weight(cpu_isolated_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
 #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
 #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
 #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
+#define cpu_isolated(cpu)	cpumask_test_cpu((cpu), cpu_isolated_mask)
 #else
 #define num_online_cpus()	1U
 #define num_possible_cpus()	1U
 #define num_present_cpus()	1U
 #define num_active_cpus()	1U
+#define num_isolated_cpus()	0U
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
 #define cpu_active(cpu)		((cpu) == 0)
+#define cpu_isolated(cpu)	((cpu) != 0)
 #endif
 
 /* verify cpu argument to cpumask_* operators */
@@ -671,9 +677,11 @@ void set_cpu_possible(unsigned int cpu, bool possible);
 void set_cpu_present(unsigned int cpu, bool present);
 void set_cpu_online(unsigned int cpu, bool online);
 void set_cpu_active(unsigned int cpu, bool active);
+void set_cpu_isolated(unsigned int cpu, bool isolated);
 void init_cpu_present(const struct cpumask *src);
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
+void init_cpu_isolated(const struct cpumask *src);
 
 /**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
@@ -739,6 +747,7 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 #define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
 #define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
 #define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
+#define cpu_isolated_map	(*(cpumask_t *)cpu_isolated_mask)
 
 #define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..a7059bc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -548,6 +548,10 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);
 
+static DECLARE_BITMAP(cpu_isolated_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_isolated_mask = to_cpumask(cpu_isolated_bits);
+EXPORT_SYMBOL(cpu_isolated_mask);
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
@@ -580,6 +584,14 @@ void set_cpu_active(unsigned int cpu, bool active)
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
 }
 
+void set_cpu_isolated(unsigned int cpu, bool isolated)
+{
+	if (isolated)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_isolated_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_isolated_bits));
+}
+
 void init_cpu_present(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_present_bits), src);
@@ -594,3 +606,21 @@ void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
 }
+
+void init_cpu_isolated(const struct cpumask *src)
+{
+	cpumask_copy(to_cpumask(cpu_isolated_bits), src);
+}
+
+#ifdef CONFIG_SMP
+
+/* Setup the mask of cpus configured for isolated domains */
+static int __init isolated_cpu_setup(char *str)
+{
+	cpulist_parse(str, to_cpumask(cpu_isolated_bits));
+	return 1;
+}
+
+__setup("isolcpus=", isolated_cpu_setup);
+
+#endif
diff --git a/kernel/sched.c b/kernel/sched.c
index c62acf4..83dc2fe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6780,19 +6780,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	destroy_sched_domains(tmp, cpu);
 }
 
-/* cpus with isolated domains */
-static cpumask_var_t cpu_isolated_map;
-
-/* Setup the mask of cpus configured for isolated domains */
-static int __init isolated_cpu_setup(char *str)
-{
-	alloc_bootmem_cpumask_var(&cpu_isolated_map);
-	cpulist_parse(str, cpu_isolated_map);
-	return 1;
-}
-
-__setup("isolcpus=", isolated_cpu_setup);
-
 #define SD_NODES_PER_DOMAIN 16
 
 #ifdef CONFIG_NUMA
@@ -7371,7 +7358,7 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 	doms_cur = alloc_sched_domains(ndoms_cur);
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
-	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
+	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_mask);
 	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();
@@ -7467,7 +7454,7 @@ match1:
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
 		doms_new = &fallback_doms;
-		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
+		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_mask);
 		WARN_ON_ONCE(dattr_new);
 	}
 
@@ -7653,7 +7640,7 @@ void __init sched_init_smp(void)
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);
-	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
+	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_mask);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
@@ -7967,9 +7954,6 @@ void __init sched_init(void)
 	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
 	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
-	/* May be allocated at isolcpus cmdline parse time */
-	if (cpu_isolated_map == NULL)
-		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	scheduler_running = 1;
-- 
1.7.4.1

