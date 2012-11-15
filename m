Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423304Ab2KNSyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:54:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22761 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250Ab2KNSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:54:45 -0500
From: Glauber Costa <glommer@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 3/7] memcg: remove test for current->mm in memcg_stop/resume_kmem_account
Date: Thu, 15 Nov 2012 06:54:49 +0400
Message-Id: <1352948093-2315-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352948093-2315-1-git-send-email-glommer@parallels.com>
References: <1352948093-2315-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original reason for the existence of this test, was that
memcg_kmem_cache_create could be called from either softirq context
(where memcg_stop/resume_account is not needed), or process context,
(where memcg_stop/resume_account is needed). Just skipping it
in-function was the cleanest way to merge both behaviors. The reason for
that is that we would try to create caches right away through
memcg_kmem_cache_create if the context would allow us to.

However, the final version of the code that merged did not have this
behavior and we always queue up new cache creation. Thus, instead of a
comment explaining why current->mm test is needed, my proposal in this
patch is to remove memcg_stop/resume_account from the worker thread and
make sure all callers have a valid mm context.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memcontrol.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c0c6adf..f9c5981 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3063,17 +3063,13 @@ out:
  */
 static inline void memcg_stop_kmem_account(void)
 {
-	if (!current->mm)
-		return;
-
+	VM_BUG_ON(!current->mm);
 	current->memcg_kmem_skip_account++;
 }
 
 static inline void memcg_resume_kmem_account(void)
 {
-	if (!current->mm)
-		return;
-
+	VM_BUG_ON(!current->mm);
 	current->memcg_kmem_skip_account--;
 }
 
@@ -3206,11 +3202,7 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	if (new_cachep)
 		goto out;
 
-	/* Don't block progress to enqueue caches for internal infrastructure */
-	memcg_stop_kmem_account();
 	new_cachep = kmem_cache_dup(memcg, cachep);
-	memcg_resume_kmem_account();
-
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
 		goto out;
-- 
1.7.11.7

