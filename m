Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423291Ab2KNSys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:54:48 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:1186 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423233Ab2KNSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:54:45 -0500
From: Glauber Costa <glommer@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 4/7] memcg: replace __always_inline with plain inline
Date: Thu, 15 Nov 2012 06:54:50 +0400
Message-Id: <1352948093-2315-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352948093-2315-1-git-send-email-glommer@parallels.com>
References: <1352948093-2315-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the pattern found in the allocators, where we do our best to
the fast paths function-call free, all the externally visible functions
for kmemcg were marked __always_inline.

It is fair to say, however, that this should be up to the compiler.  We
will still keep as much of the flag testing as we can in memcontrol.h to
give the compiler the option to inline it, but won't force it.

I tested this with 4.7.2, it will inline all three functions anyway when
compiling with -O2, and will refrain from it when compiling with -Os.
This seems like a good behavior.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c91e3c1..17d0d41 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -467,7 +467,7 @@ void kmem_cache_destroy_memcg_children(struct kmem_cache *s);
  * We return true automatically if this allocation is not to be accounted to
  * any memcg.
  */
-static __always_inline bool
+static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
 {
 	if (!memcg_kmem_enabled())
@@ -499,7 +499,7 @@ memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
  *
  * there is no need to specify memcg here, since it is embedded in page_cgroup
  */
-static __always_inline void
+static inline void
 memcg_kmem_uncharge_pages(struct page *page, int order)
 {
 	if (memcg_kmem_enabled())
@@ -517,7 +517,7 @@ memcg_kmem_uncharge_pages(struct page *page, int order)
  * charges. Otherwise, it will commit the memcg given by @memcg to the
  * corresponding page_cgroup.
  */
-static __always_inline void
+static inline void
 memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
 {
 	if (memcg_kmem_enabled() && memcg)
-- 
1.7.11.7

