Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2EJFit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:38:49 -0400
Received: from ozlabs.org ([203.10.76.45]:50034 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab2EJFir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:38:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
In-Reply-To: <4FAB2B5B.4020902@gmail.com>
References: <87ipg5c2bk.fsf@rustcorp.com.au> <4FAB1AC9.1050306@gmail.com> <871umsdbm0.fsf@rustcorp.com.au> <4FAB2B5B.4020902@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 10 May 2012 14:24:35 +0930
Message-ID: <87vck4bppw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2012 22:43:39 -0400, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> > Or is there a reason we shouldn't even try to allocate here?
> 
> 1) your code always use GFP_KERNEL. it is trouble maker when alloc_pages w/ GFP_ATOMIC.

Oh :(

How about the below instead?

> 2) When CONFIG_CPUMASK_OFFSTACK=n and NR_CPUS is relatively large, cpumask on stack may
> cause stack overflow. because of, alloc_pages() can be called from
> very deep call stack.

You can't have large NR_CPUS without CONFIG_CPUMASK_OFFSTACK=y,
otherwise you'll get many other stack overflows, too.

Thanks,
Rusty.

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 581e74b..7c1db9c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -367,7 +367,7 @@ extern void free_hot_cold_page_list(struct list_head *list, int cold);
 
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_all_pages(void);
+void drain_all_pages(gfp_t gfp_flags);
 void drain_local_pages(void *dummy);
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 97cc273..daf0d7b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -237,7 +237,7 @@ void shake_page(struct page *p, int access)
 		lru_add_drain_all();
 		if (PageLRU(p))
 			return;
-		drain_all_pages();
+		drain_all_pages(GFP_KERNEL);
 		if (PageLRU(p) || is_free_buddy_page(p))
 			return;
 	}
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6629faf..1372a9b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -922,7 +922,7 @@ repeat:
 	if (drain) {
 		lru_add_drain_all();
 		cond_resched();
-		drain_all_pages();
+		drain_all_pages(GFP_KERNEL);
 	}
 
 	pfn = scan_lru_pages(start_pfn, end_pfn);
@@ -944,7 +944,7 @@ repeat:
 	lru_add_drain_all();
 	yield();
 	/* drain pcp pages , this is synchrouns. */
-	drain_all_pages();
+	drain_all_pages(GFP_KERNEL);
 	/* check again */
 	offlined_pages = check_pages_isolated(start_pfn, end_pfn);
 	if (offlined_pages < 0) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a712fb9..aaac25c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1169,17 +1169,17 @@ void drain_local_pages(void *arg)
  * nothing keeps CPUs from showing up after we populated the cpumask and
  * before the call to on_each_cpu_mask().
  */
-void drain_all_pages(void)
+void drain_all_pages(gfp_t gfp_flags)
 {
 	int cpu;
 	struct per_cpu_pageset *pcp;
 	struct zone *zone;
+	cpumask_var_t cpus_with_pcps;
 
-	/*
-	 * Allocate in the BSS so we wont require allocation in
-	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
-	 */
-	static cpumask_t cpus_with_pcps;
+	if (!zalloc_cpumask_var(&cpus_with_pcps, gfp_flags)) {
+		on_each_cpu(drain_local_pages, NULL, 1);
+		return;
+	}
 
 	/*
 	 * We don't care about racing with CPU hotplug event
@@ -1197,11 +1197,10 @@ void drain_all_pages(void)
 			}
 		}
 		if (has_pcps)
-			cpumask_set_cpu(cpu, &cpus_with_pcps);
-		else
-			cpumask_clear_cpu(cpu, &cpus_with_pcps);
+			cpumask_set_cpu(cpu, cpus_with_pcps);
 	}
-	on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
+	on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
+	free_cpumask_var(cpus_with_pcps);
 }
 
 #ifdef CONFIG_HIBERNATION
@@ -2132,7 +2131,7 @@ retry:
 	 * pages are pinned on the per-cpu lists. Drain them and try again
 	 */
 	if (!page && !drained) {
-		drain_all_pages();
+		drain_all_pages(GFP_ATOMIC);
 		drained = true;
 		goto retry;
 	}
@@ -5532,7 +5531,7 @@ out:
 
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
-		drain_all_pages();
+		drain_all_pages(GFP_KERNEL);
 	return ret;
 }
 
