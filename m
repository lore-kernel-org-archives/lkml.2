Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0IIOYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:24:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0IIOYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:24:13 -0400
Message-ID: <4C88EE00.70004@kernel.org>
Date: Thu, 09 Sep 2010 16:24:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-next Sept 9] S309 Build break (mm/percpu.c)
References: <4C88D48A.3070702@in.ibm.com>
In-Reply-To: <4C88D48A.3070702@in.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 14:24:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bbddff05 (percpu: use percpu allocator on UP too) incorrectly
excluded pcpu_build_alloc_info() on SMP configurations which use
generic setup_per_cpu_area() like s390.  The config ifdefs are
becoming confusing.  Fix and clean it up by,

* Move pcpu_build_alloc_info() right on top of its two users -
  pcpu_{embed|page}_first_chunk() which are already in CONFIG_SMP
  block.

* Define BUILD_{EMBED|PAGE}_FIRST_CHUNK which indicate whether each
  first chunk function needs to be included and use them to control
  inclusion of the three functions to reduce confusion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sachin Sant <sachinp@in.ibm.com>
---
Can you please test this patch?

Thanks.

 mm/percpu.c |  338 +++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 175 insertions(+), 163 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index fa70122..0cd4bf6 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1075,165 +1075,6 @@ void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 	free_bootmem(__pa(ai), ai->__ai_size);
 }

-#if defined(CONFIG_SMP) && (defined(CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK) || \
-			    defined(CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK))
-/**
- * pcpu_build_alloc_info - build alloc_info considering distances between CPUs
- * @reserved_size: the size of reserved percpu area in bytes
- * @dyn_size: minimum free size for dynamic allocation in bytes
- * @atom_size: allocation atom size
- * @cpu_distance_fn: callback to determine distance between cpus, optional
- *
- * This function determines grouping of units, their mappings to cpus
- * and other parameters considering needed percpu size, allocation
- * atom size and distances between CPUs.
- *
- * Groups are always mutliples of atom size and CPUs which are of
- * LOCAL_DISTANCE both ways are grouped together and share space for
- * units in the same group.  The returned configuration is guaranteed
- * to have CPUs on different nodes on different groups and >=75% usage
- * of allocated virtual address space.
- *
- * RETURNS:
- * On success, pointer to the new allocation_info is returned.  On
- * failure, ERR_PTR value is returned.
- */
-static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
-				size_t reserved_size, size_t dyn_size,
-				size_t atom_size,
-				pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
-{
-	static int group_map[NR_CPUS] __initdata;
-	static int group_cnt[NR_CPUS] __initdata;
-	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int nr_groups = 1, nr_units = 0;
-	size_t size_sum, min_unit_size, alloc_size;
-	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
-	int last_allocs, group, unit;
-	unsigned int cpu, tcpu;
-	struct pcpu_alloc_info *ai;
-	unsigned int *cpu_map;
-
-	/* this function may be called multiple times */
-	memset(group_map, 0, sizeof(group_map));
-	memset(group_cnt, 0, sizeof(group_cnt));
-
-	/* calculate size_sum and ensure dyn_size is enough for early alloc */
-	size_sum = PFN_ALIGN(static_size + reserved_size +
-			    max_t(size_t, dyn_size, PERCPU_DYNAMIC_EARLY_SIZE));
-	dyn_size = size_sum - static_size - reserved_size;
-
-	/*
-	 * Determine min_unit_size, alloc_size and max_upa such that
-	 * alloc_size is multiple of atom_size and is the smallest
-	 * which can accomodate 4k aligned segments which are equal to
-	 * or larger than min_unit_size.
-	 */
-	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
-
-	alloc_size = roundup(min_unit_size, atom_size);
-	upa = alloc_size / min_unit_size;
-	while (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
-		upa--;
-	max_upa = upa;
-
-	/* group cpus according to their proximity */
-	for_each_possible_cpu(cpu) {
-		group = 0;
-	next_group:
-		for_each_possible_cpu(tcpu) {
-			if (cpu == tcpu)
-				break;
-			if (group_map[tcpu] == group && cpu_distance_fn &&
-			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
-			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
-				group++;
-				nr_groups = max(nr_groups, group + 1);
-				goto next_group;
-			}
-		}
-		group_map[cpu] = group;
-		group_cnt[group]++;
-	}
-
-	/*
-	 * Expand unit size until address space usage goes over 75%
-	 * and then as much as possible without using more address
-	 * space.
-	 */
-	last_allocs = INT_MAX;
-	for (upa = max_upa; upa; upa--) {
-		int allocs = 0, wasted = 0;
-
-		if (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
-			continue;
-
-		for (group = 0; group < nr_groups; group++) {
-			int this_allocs = DIV_ROUND_UP(group_cnt[group], upa);
-			allocs += this_allocs;
-			wasted += this_allocs * upa - group_cnt[group];
-		}
-
-		/*
-		 * Don't accept if wastage is over 1/3.  The
-		 * greater-than comparison ensures upa==1 always
-		 * passes the following check.
-		 */
-		if (wasted > num_possible_cpus() / 3)
-			continue;
-
-		/* and then don't consume more memory */
-		if (allocs > last_allocs)
-			break;
-		last_allocs = allocs;
-		best_upa = upa;
-	}
-	upa = best_upa;
-
-	/* allocate and fill alloc_info */
-	for (group = 0; group < nr_groups; group++)
-		nr_units += roundup(group_cnt[group], upa);
-
-	ai = pcpu_alloc_alloc_info(nr_groups, nr_units);
-	if (!ai)
-		return ERR_PTR(-ENOMEM);
-	cpu_map = ai->groups[0].cpu_map;
-
-	for (group = 0; group < nr_groups; group++) {
-		ai->groups[group].cpu_map = cpu_map;
-		cpu_map += roundup(group_cnt[group], upa);
-	}
-
-	ai->static_size = static_size;
-	ai->reserved_size = reserved_size;
-	ai->dyn_size = dyn_size;
-	ai->unit_size = alloc_size / upa;
-	ai->atom_size = atom_size;
-	ai->alloc_size = alloc_size;
-
-	for (group = 0, unit = 0; group_cnt[group]; group++) {
-		struct pcpu_group_info *gi = &ai->groups[group];
-
-		/*
-		 * Initialize base_offset as if all groups are located
-		 * back-to-back.  The caller should update this to
-		 * reflect actual allocation.
-		 */
-		gi->base_offset = unit * ai->unit_size;
-
-		for_each_possible_cpu(cpu)
-			if (group_map[cpu] == group)
-				gi->cpu_map[gi->nr_units++] = cpu;
-		gi->nr_units = roundup(gi->nr_units, upa);
-		unit += gi->nr_units;
-	}
-	BUG_ON(unit != nr_units);
-
-	return ai;
-}
-#endif	/* CONFIG_SMP && (CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
-			  CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK) */
-
 /**
  * pcpu_dump_alloc_info - print out information about pcpu_alloc_info
  * @lvl: loglevel
@@ -1532,8 +1373,180 @@ static int __init percpu_alloc_setup(char *str)
 }
 early_param("percpu_alloc", percpu_alloc_setup);

+/*
+ * pcpu_embed_first_chunk() is used by the generic percpu setup.
+ * Build it if needed by the arch config or the generic setup is going
+ * to be used.
+ */
 #if defined(CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK) || \
 	!defined(CONFIG_HAVE_SETUP_PER_CPU_AREA)
+#define BUILD_EMBED_FIRST_CHUNK
+#endif
+
+/* build pcpu_page_first_chunk() iff needed by the arch config */
+#if defined(CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK)
+#define BUILD_PAGE_FIRST_CHUNK
+#endif
+
+/* pcpu_build_alloc_info() is used by both embed and page first chunk */
+#if defined(BUILD_EMBED_FIRST_CHUNK) || defined(BUILD_PAGE_FIRST_CHUNK)
+/**
+ * pcpu_build_alloc_info - build alloc_info considering distances between CPUs
+ * @reserved_size: the size of reserved percpu area in bytes
+ * @dyn_size: minimum free size for dynamic allocation in bytes
+ * @atom_size: allocation atom size
+ * @cpu_distance_fn: callback to determine distance between cpus, optional
+ *
+ * This function determines grouping of units, their mappings to cpus
+ * and other parameters considering needed percpu size, allocation
+ * atom size and distances between CPUs.
+ *
+ * Groups are always mutliples of atom size and CPUs which are of
+ * LOCAL_DISTANCE both ways are grouped together and share space for
+ * units in the same group.  The returned configuration is guaranteed
+ * to have CPUs on different nodes on different groups and >=75% usage
+ * of allocated virtual address space.
+ *
+ * RETURNS:
+ * On success, pointer to the new allocation_info is returned.  On
+ * failure, ERR_PTR value is returned.
+ */
+static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
+				size_t reserved_size, size_t dyn_size,
+				size_t atom_size,
+				pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
+{
+	static int group_map[NR_CPUS] __initdata;
+	static int group_cnt[NR_CPUS] __initdata;
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
+	int nr_groups = 1, nr_units = 0;
+	size_t size_sum, min_unit_size, alloc_size;
+	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
+	int last_allocs, group, unit;
+	unsigned int cpu, tcpu;
+	struct pcpu_alloc_info *ai;
+	unsigned int *cpu_map;
+
+	/* this function may be called multiple times */
+	memset(group_map, 0, sizeof(group_map));
+	memset(group_cnt, 0, sizeof(group_cnt));
+
+	/* calculate size_sum and ensure dyn_size is enough for early alloc */
+	size_sum = PFN_ALIGN(static_size + reserved_size +
+			    max_t(size_t, dyn_size, PERCPU_DYNAMIC_EARLY_SIZE));
+	dyn_size = size_sum - static_size - reserved_size;
+
+	/*
+	 * Determine min_unit_size, alloc_size and max_upa such that
+	 * alloc_size is multiple of atom_size and is the smallest
+	 * which can accomodate 4k aligned segments which are equal to
+	 * or larger than min_unit_size.
+	 */
+	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
+
+	alloc_size = roundup(min_unit_size, atom_size);
+	upa = alloc_size / min_unit_size;
+	while (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
+		upa--;
+	max_upa = upa;
+
+	/* group cpus according to their proximity */
+	for_each_possible_cpu(cpu) {
+		group = 0;
+	next_group:
+		for_each_possible_cpu(tcpu) {
+			if (cpu == tcpu)
+				break;
+			if (group_map[tcpu] == group && cpu_distance_fn &&
+			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
+			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
+				group++;
+				nr_groups = max(nr_groups, group + 1);
+				goto next_group;
+			}
+		}
+		group_map[cpu] = group;
+		group_cnt[group]++;
+	}
+
+	/*
+	 * Expand unit size until address space usage goes over 75%
+	 * and then as much as possible without using more address
+	 * space.
+	 */
+	last_allocs = INT_MAX;
+	for (upa = max_upa; upa; upa--) {
+		int allocs = 0, wasted = 0;
+
+		if (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
+			continue;
+
+		for (group = 0; group < nr_groups; group++) {
+			int this_allocs = DIV_ROUND_UP(group_cnt[group], upa);
+			allocs += this_allocs;
+			wasted += this_allocs * upa - group_cnt[group];
+		}
+
+		/*
+		 * Don't accept if wastage is over 1/3.  The
+		 * greater-than comparison ensures upa==1 always
+		 * passes the following check.
+		 */
+		if (wasted > num_possible_cpus() / 3)
+			continue;
+
+		/* and then don't consume more memory */
+		if (allocs > last_allocs)
+			break;
+		last_allocs = allocs;
+		best_upa = upa;
+	}
+	upa = best_upa;
+
+	/* allocate and fill alloc_info */
+	for (group = 0; group < nr_groups; group++)
+		nr_units += roundup(group_cnt[group], upa);
+
+	ai = pcpu_alloc_alloc_info(nr_groups, nr_units);
+	if (!ai)
+		return ERR_PTR(-ENOMEM);
+	cpu_map = ai->groups[0].cpu_map;
+
+	for (group = 0; group < nr_groups; group++) {
+		ai->groups[group].cpu_map = cpu_map;
+		cpu_map += roundup(group_cnt[group], upa);
+	}
+
+	ai->static_size = static_size;
+	ai->reserved_size = reserved_size;
+	ai->dyn_size = dyn_size;
+	ai->unit_size = alloc_size / upa;
+	ai->atom_size = atom_size;
+	ai->alloc_size = alloc_size;
+
+	for (group = 0, unit = 0; group_cnt[group]; group++) {
+		struct pcpu_group_info *gi = &ai->groups[group];
+
+		/*
+		 * Initialize base_offset as if all groups are located
+		 * back-to-back.  The caller should update this to
+		 * reflect actual allocation.
+		 */
+		gi->base_offset = unit * ai->unit_size;
+
+		for_each_possible_cpu(cpu)
+			if (group_map[cpu] == group)
+				gi->cpu_map[gi->nr_units++] = cpu;
+		gi->nr_units = roundup(gi->nr_units, upa);
+		unit += gi->nr_units;
+	}
+	BUG_ON(unit != nr_units);
+
+	return ai;
+}
+#endif /* BUILD_EMBED_FIRST_CHUNK || BUILD_PAGE_FIRST_CHUNK */
+
+#if defined(BUILD_EMBED_FIRST_CHUNK)
 /**
  * pcpu_embed_first_chunk - embed the first percpu chunk into bootmem
  * @reserved_size: the size of reserved percpu area in bytes
@@ -1662,10 +1675,9 @@ out_free:
 		free_bootmem(__pa(areas), areas_size);
 	return rc;
 }
-#endif /* CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
-	  !CONFIG_HAVE_SETUP_PER_CPU_AREA */
+#endif /* BUILD_EMBED_FIRST_CHUNK */

-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+#ifdef BUILD_PAGE_FIRST_CHUNK
 /**
  * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
  * @reserved_size: the size of reserved percpu area in bytes
@@ -1773,7 +1785,7 @@ out_free_ar:
 	pcpu_free_alloc_info(ai);
 	return rc;
 }
-#endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
+#endif /* BUILD_PAGE_FIRST_CHUNK */

 #ifndef	CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
