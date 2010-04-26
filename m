Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0DZORZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:17:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51507 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0DZORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:17:23 -0400
Date: Mon, 26 Apr 2010 17:17:21 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tim.c.chen@intel.com, npiggin@suse.de,
       rientjes@google.com
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <4BD570A8.90304@kernel.org>
Message-ID: <alpine.DEB.2.00.1004261710500.16526@melkki.cs.helsinki.fi>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>  <alpine.DEB.2.00.1004221045270.1204@router.home>  <4BD086D0.9090309@cs.helsinki.fi>  <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>  <1272265147.2078.648.camel@ymzhang.sh.intel.com>
  <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>  <4BD564BE.6020700@kernel.org> <x2o84144f021004260309k9edf9e88t92e4c988d12de234@mail.gmail.com> <4BD570A8.90304@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 12:09 PM, Pekka Enberg wrote:
>>> My wild speculation is that previously the cpu_slub structures of two
>>> neighboring threads ended up on the same cacheline by accident thanks
>>> to the back to back allocation.  W/ the percpu allocator, this no
>>> longer would happen as the allocator groups percpu data together
>>> per-cpu.
>>
>> Yanmin, do we see a lot of remote frees for your hackbench run? IIRC,
>> it's the "deactivate_remote_frees" stat when CONFIG_SLAB_STATS is
>> enabled.

On Mon, 26 Apr 2010, Tejun Heo wrote:
> I'm not familiar with the details or scales here so please take
> whatever I say with a grain of salt.  For hyperthreading configuration
> I think operations don't have to be remote to be affected.  If the
> data for cpu0 and cpu1 were on the same cache line, and cpu0 and cpu1
> are occupying the same physical core thus sharing all the resources it
> would benefit from the sharing whether any operation was remote or not
> as it saves the physical processor one cache line.

Even if the cacheline is dirtied like in the struct kmem_cache_cpu case? 
If that's the case, don't we want the per-CPU allocator to support 
back to back allocation for cores that are in the same package?

Btw, I focused on remote frees initially before I understood what you 
actually meant and scetched the following untested patch to take advantage 
of the fact that struct kmem_cache_cpu doesn't fill a whole cache line. It 
tries amortize remote free costs by "queuing" objects. It would be 
interesting to see if it helps here (or in the other SLUB regressions like 
netperf and the famous Intel one).

 			Pekka

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 0249d41..b554a67 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -34,10 +34,14 @@ enum stat_item {
  	ORDER_FALLBACK,		/* Number of times fallback was necessary */
  	NR_SLUB_STAT_ITEMS };

+#define SLUB_MAX_NR_REMOTES	5
+
  struct kmem_cache_cpu {
  	void **freelist;	/* Pointer to first free per cpu object */
  	struct page *page;	/* The slab from which we are allocating */
  	int node;		/* The node of the page (or -1 for debug) */
+	int nr_remotes;		/* Number of remotely free'd objects */
+	void *remotelist[SLUB_MAX_NR_REMOTES];	/* List of remotely free'd objects */
  #ifdef CONFIG_SLUB_STATS
  	unsigned stat[NR_SLUB_STAT_ITEMS];
  #endif
diff --git a/mm/slub.c b/mm/slub.c
index 7d6c8b1..e8e5523 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1480,6 +1480,24 @@ static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
  	unfreeze_slab(s, page, tail);
  }

+static void __slab_free(struct kmem_cache *s, struct page *page, void *x, unsigned long addr);
+
+static void flush_remotelist(struct kmem_cache *s, struct kmem_cache_cpu *c)
+{
+	int i;
+
+	for (i = 0; i < c->nr_remotes; i++) {
+		struct page *page;
+		void *x;
+
+		x = c->remotelist[i];
+		page = virt_to_head_page(x);
+
+		__slab_free(s, page, x, _RET_IP_);
+	}
+	c->nr_remotes = 0;
+}
+
  static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
  {
  	stat(s, CPUSLAB_FLUSH);
@@ -1496,7 +1514,12 @@ static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
  {
  	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);

-	if (likely(c && c->page))
+	if (unlikely(!c))
+		return;
+
+	flush_remotelist(s, c);
+
+	if (likely(c->page))
  		flush_slab(s, c);
  }

@@ -1709,6 +1732,8 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,

  	local_irq_save(flags);
  	c = __this_cpu_ptr(s->cpu_slab);
+	if (unlikely(c->nr_remotes == SLUB_MAX_NR_REMOTES))
+		flush_remotelist(s, c);
  	object = c->freelist;
  	if (unlikely(!object || !node_match(c, node)))

@@ -1865,8 +1890,12 @@ static __always_inline void slab_free(struct kmem_cache *s,
  		set_freepointer(s, object, c->freelist);
  		c->freelist = object;
  		stat(s, FREE_FASTPATH);
-	} else
-		__slab_free(s, page, x, addr);
+	} else {
+		if (unlikely(c->nr_remotes == SLUB_MAX_NR_REMOTES))
+			flush_remotelist(s, c);
+
+		c->remotelist[c->nr_remotes++] = x;
+	}

  	local_irq_restore(flags);
  }
