Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab2IROQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:16:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31173 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149Ab2IROQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:16:53 -0400
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
Subject: [PATCH v3 14/16] slub: slub-specific propagation changes.
Date: Tue, 18 Sep 2012 18:12:08 +0400
Message-Id: <1347977530-29755-15-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347977530-29755-1-git-send-email-glommer@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a parent cache changes a sysfs attr, we need to propagate that to
the children as well. For that, we unfortunately need to tap into the
slub core.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Suleiman Souhlal <suleiman@google.com>
---
 mm/slub.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index f90f612..0b68d15 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5174,6 +5174,10 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 	struct slab_attribute *attribute;
 	struct kmem_cache *s;
 	int err;
+#ifdef CONFIG_MEMCG_KMEM
+	struct kmem_cache *c;
+	struct mem_cgroup_cache_params *p;
+#endif
 
 	attribute = to_slab_attr(attr);
 	s = to_slab(kobj);
@@ -5182,7 +5186,19 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 		return -EIO;
 
 	err = attribute->store(s, buf, len);
+#ifdef CONFIG_MEMCG_KMEM
+	if (slab_state < FULL)
+		return err;
 
+	if ((err < 0) || (s->memcg_params.id == -1))
+		return err;
+
+	list_for_each_entry(p, &s->memcg_params.sibling_list, sibling_list) {
+		c = container_of(p, struct kmem_cache, memcg_params);
+		/* return value determined by the parent cache only */
+		attribute->store(c, buf, len);
+	}
+#endif
 	return err;
 }
 
-- 
1.7.11.4

