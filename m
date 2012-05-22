Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2EVOLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:11:14 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28968 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2EVOLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:11:13 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] slab: move FULL state transition to an initcall
Date: Tue, 22 May 2012 18:07:59 +0400
Message-Id: <1337695679-10178-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During kmem_cache_init_late(), we transition to the LATE state,
and after some more work, to the FULL state, its last state

This is quite different from slub, that will only transition to
its last state (SYSFS), in a (late)initcall, after a lot more of
the kernel is ready.

This means that in slab, we have no way to taking actions dependent
on the initialization of other pieces of the kernel that are supposed
to start way after kmem_init_late(), such as cgroups initialization.

To achieve more consistency in this behavior, that patch only
transitions to the LATE state in kmem_init_late. In my analysis,
setup_cpu_cache() should be happy to test for >= LATE, instead of
== FULL. It also has passed some tests I've made.

We then only mark FULL state after the reap timers are in place,
meaning that no further setup is expected.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>
---
 mm/slab.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 58e5c9c..bd351a0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1741,9 +1741,6 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&cache_chain_mutex);
 
-	/* Done! */
-	g_cpucache_up = FULL;
-
 	/*
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
@@ -1773,6 +1770,9 @@ static int __init cpucache_init(void)
 	 */
 	for_each_online_cpu(cpu)
 		start_cpu_timer(cpu);
+
+	/* Done! */
+	g_cpucache_up = FULL;
 	return 0;
 }
 __initcall(cpucache_init);
@@ -2260,7 +2260,7 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 
 static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
-	if (g_cpucache_up == FULL)
+	if (g_cpucache_up >= LATE)
 		return enable_cpucache(cachep, gfp);
 
 	if (g_cpucache_up == NONE) {
-- 
1.7.7.6

