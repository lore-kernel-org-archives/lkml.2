Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2KUSZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:25:45 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53821 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2KUSZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:25:43 -0500
Date: Wed, 21 Nov 2012 19:25:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/46] mm: numa: Use a two-stage filter to restrict pages
 being migrated for unlikely task<->node relationships
Message-ID: <20121121182537.GB29893@gmail.com>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <1353493312-8069-37-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353493312-8069-37-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> While it is desirable that all threads in a process run on its home
> node, this is not always possible or necessary. There may be more
> threads than exist within the node or the node might over-subscribed
> with unrelated processes.
> 
> This can cause a situation whereby a page gets migrated off its home
> node because the threads clearing pte_numa were running off-node. This
> patch uses page->last_nid to build a two-stage filter before pages get
> migrated to avoid problems with short or unlikely task<->node
> relationships.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/mempolicy.c |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4c1c8d8..fd20e28 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2317,9 +2317,37 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
>  	}
>  
>  	/* Migrate the page towards the node whose CPU is referencing it */
> -	if (pol->flags & MPOL_F_MORON)
> +	if (pol->flags & MPOL_F_MORON) {
> +		int last_nid;
> +
>  		polnid = numa_node_id();
>  
> +		/*
> +		 * Multi-stage node selection is used in conjunction
> +		 * with a periodic migration fault to build a temporal
> +		 * task<->page relation. By using a two-stage filter we
> +		 * remove short/unlikely relations.
> +		 *
> +		 * Using P(p) ~ n_p / n_t as per frequentist
> +		 * probability, we can equate a task's usage of a
> +		 * particular page (n_p) per total usage of this
> +		 * page (n_t) (in a given time-span) to a probability.
> +		 *
> +		 * Our periodic faults will sample this probability and
> +		 * getting the same result twice in a row, given these
> +		 * samples are fully independent, is then given by
> +		 * P(n)^2, provided our sample period is sufficiently
> +		 * short compared to the usage pattern.
> +		 *
> +		 * This quadric squishes small probabilities, making
> +		 * it less likely we act on an unlikely task<->page
> +		 * relation.
> +		 */
> +		last_nid = page_xchg_last_nid(page, polnid);
> +		if (last_nid != polnid)
> +			goto out;
> +	}
> +
>  	if (curnid != polnid)
>  		ret = polnid;
>  out:

As mentioned in my other mail, this patch of yours looks very 
similar to the numa/core commit attached below, mostly written 
by Peter:

  30f93abc6cb3 sched, numa, mm: Add the scanning page fault machinery

Thanks,

	Ingo

--------------------->
>From 30f93abc6cb3fd387a134d6b94ff5ac396be1c88 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 13 Nov 2012 12:58:32 +0100
Subject: [PATCH] sched, numa, mm: Add the scanning page fault machinery

Add the NUMA working set scanning/hinting page fault machinery,
with no policy yet.

[ The earliest versions had the mpol_misplaced() function from
  Lee Schermerhorn - this was heavily modified later on. ]

Also-written-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
[ split it out of the main policy patch - as suggested by Mel Gorman ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/init_task.h |   8 +++
 include/linux/mempolicy.h |   6 +-
 include/linux/mm_types.h  |   4 ++
 include/linux/sched.h     |  41 ++++++++++++--
 init/Kconfig              |  73 +++++++++++++++++++-----
 kernel/sched/core.c       |  15 +++++
 kernel/sysctl.c           |  31 ++++++++++-
 mm/huge_memory.c          |   1 +
 mm/mempolicy.c            | 137 ++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 294 insertions(+), 22 deletions(-)

[...]

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..318043a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2175,6 +2175,143 @@ static void sp_free(struct sp_node *n)
 	kmem_cache_free(sn_cache, n);
 }
 
+/*
+ * Multi-stage node selection is used in conjunction with a periodic
+ * migration fault to build a temporal task<->page relation. By
+ * using a two-stage filter we remove short/unlikely relations.
+ *
+ * Using P(p) ~ n_p / n_t as per frequentist probability, we can
+ * equate a task's usage of a particular page (n_p) per total usage
+ * of this page (n_t) (in a given time-span) to a probability.
+ *
+ * Our periodic faults will then sample this probability and getting
+ * the same result twice in a row, given these samples are fully
+ * independent, is then given by P(n)^2, provided our sample period
+ * is sufficiently short compared to the usage pattern.
+ *
+ * This quadric squishes small probabilities, making it less likely
+ * we act on an unlikely task<->page relation.
+ *
+ * Return the best node ID this page should be on, or -1 if it should
+ * stay where it is.
+ */
+static int
+numa_migration_target(struct page *page, int page_nid,
+		      struct task_struct *p, int this_cpu,
+		      int cpu_last_access)
+{
+	int nid_last_access;
+	int this_nid;
+
+	if (task_numa_shared(p) < 0)
+		return -1;
+
+	/*
+	 * Possibly migrate towards the current node, depends on
+	 * task_numa_placement() and access details.
+	 */
+	nid_last_access = cpu_to_node(cpu_last_access);
+	this_nid = cpu_to_node(this_cpu);
+
+	if (nid_last_access != this_nid) {
+		/*
+		 * 'Access miss': the page got last accessed from a remote node.
+		 */
+		return -1;
+	}
+	/*
+	 * 'Access hit': the page got last accessed from our node.
+	 *
+	 * Migrate the page if needed.
+	 */
+
+	/* The page is already on this node: */
+	if (page_nid == this_nid)
+		return -1;
+
+	return this_nid;
+}
[...]
