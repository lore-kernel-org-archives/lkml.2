Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2IECd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 22:33:56 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56744 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2IECdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 22:33:55 -0400
Message-ID: <5046B9EE.7000804@linux.vnet.ibm.com>
Date: Wed, 05 Sep 2012 10:33:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
CC: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] slab: fix the DEADLOCK issue on l3 alien lock
References: <5044692D.7080608@linux.vnet.ibm.com>
In-Reply-To: <5044692D.7080608@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <5044692D.7080608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090502-7014-0000-0000-000001D79FBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

DEADLOCK will be report while running a kernel with NUMA and LOCKDEP enabled,
the process of this fake report is:

	   kmem_cache_free()	//free obj in cachep
	-> cache_free_alien()	//acquire cachep's l3 alien lock
	-> __drain_alien_cache()
	-> free_block()
	-> slab_destroy()
	-> kmem_cache_free()	//free slab in cachep->slabp_cache
	-> cache_free_alien()	//acquire cachep->slabp_cache's l3 alien lock

Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
fake report generated.

This should not happen since we already have init_lock_keys() which will
reassign the lock class for both l3 list and l3 alien.

However, init_lock_keys() was invoked at a wrong position which is before we
invoke enable_cpucache() on each cache.

Since until set slab_state to be FULL, we won't invoke enable_cpucache()
on caches to build their l3 alien while creating them, so although we invoked
init_lock_keys(), the l3 alien lock class won't change since we don't have
them until invoked enable_cpucache() later.

This patch will invoke init_lock_keys() after we done enable_cpucache()
instead of before to avoid the fake DEADLOCK report.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 mm/slab.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index d4715e5..cc679ef 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1780,9 +1780,6 @@ void __init kmem_cache_init_late(void)
 
 	slab_state = UP;
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(cachep, &slab_caches, list)
@@ -1790,6 +1787,9 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&slab_mutex);
 
+	/* Annotate slab for lockdep -- annotate the malloc caches */
+	init_lock_keys();
+
 	/* Done! */
 	slab_state = FULL;
 
-- 
1.7.4.1

