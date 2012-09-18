Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2IROR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:17:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40636 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab2IRORA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:17:00 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <devel@openvz.org>, Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v3 13/16] slab: slab-specific propagation changes.
Date: Tue, 18 Sep 2012 18:12:07 +0400
Message-Id: <1347977530-29755-14-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347977530-29755-1-git-send-email-glommer@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a parent cache does tune_cpucache, we need to propagate that to the
children as well. For that, we unfortunately need to tap into the slab core.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Suleiman Souhlal <suleiman@google.com>
---
 mm/slab.c        | 28 +++++++++++++++++++++++++++-
 mm/slab_common.c |  1 +
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index d5c196b..bd9928f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4104,7 +4104,7 @@ static void do_ccupdate_local(void *info)
 }
 
 /* Always called with the slab_mutex held */
-static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
+static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 				int batchcount, int shared, gfp_t gfp)
 {
 	struct ccupdate_struct *new;
@@ -4147,6 +4147,32 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	return alloc_kmemlist(cachep, gfp);
 }
 
+static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
+				int batchcount, int shared, gfp_t gfp)
+{
+	int ret;
+#ifdef CONFIG_MEMCG_KMEM
+	struct kmem_cache *c;
+	struct mem_cgroup_cache_params *p;
+#endif
+
+	ret = __do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
+#ifdef CONFIG_MEMCG_KMEM
+	if (slab_state < FULL)
+		return ret;
+
+	if ((ret < 0) || (cachep->memcg_params.id == -1))
+		return ret;
+
+	list_for_each_entry(p, &cachep->memcg_params.sibling_list, sibling_list) {
+		c = container_of(p, struct kmem_cache, memcg_params);
+		/* return value determined by the parent cache only */
+		__do_tune_cpucache(c, limit, batchcount, shared, gfp);
+	}
+#endif
+	return ret;
+}
+
 /* Called with slab_mutex held always */
 static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index c6fb4a7..341c3e1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -124,6 +124,7 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 #ifdef CONFIG_MEMCG_KMEM
 		s->memcg_params.memcg = memcg;
 		s->memcg_params.parent = parent_cache;
+		s->memcg_params.id = -1; /* not registered yet */
 #endif
 		s->name = kstrdup(name, GFP_KERNEL);
 		if (!s->name) {
-- 
1.7.11.4

