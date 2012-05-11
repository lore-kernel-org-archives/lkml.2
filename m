Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab2EKRtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:49:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3304 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab2EKRtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:49:09 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH v2 01/29] slab: dup name string
Date: Fri, 11 May 2012 14:44:03 -0300
Message-Id: <1336758272-24284-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336758272-24284-1-git-send-email-glommer@parallels.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slub allocator creates a copy of the name string, and
frees it later. I would like them both to behave the same,
whether it is the slab starting to create a copy of it itself,
or the slub ceasing to.

This is because when I create memcg copies of it, I have to
kmalloc strings for the new names, and having the allocators to
behave differently here, would make it a lot uglier.

My first submission removed the duplication for the slub. But
the code started to get a bit complicated when dealing with
deletion of chained caches. Also, Christoph voiced his opinion
that patching the slab to keep copies would be better.

So here it is.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e901a36..91b9c13 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
 			kfree(l3);
 		}
 	}
+	kfree(cachep->name);
 	kmem_cache_free(&cache_cache, cachep);
 }
 
@@ -2526,7 +2527,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
 	}
 	cachep->ctor = ctor;
-	cachep->name = name;
+	cachep->name = kstrdup(name, GFP_KERNEL);
 
 	if (setup_cpu_cache(cachep, gfp)) {
 		__kmem_cache_destroy(cachep);
-- 
1.7.7.6

