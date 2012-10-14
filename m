Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2JNPPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:15:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46094 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709Ab2JNOll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:41 -0400
Message-Id: <20121014143536.339219261@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [ 019/147] slab: fix the DEADLOCK issue on l3 alien lock
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Wang <wangyun@linux.vnet.ibm.com>

commit 947ca1856a7e60aa6d20536785e6a42dff25aa6e upstream.

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

Michael traced the problem back to a commit in release 3.0.0:

commit 30765b92ada267c5395fc788623cb15233276f5c
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Jul 28 23:22:56 2011 +0200

    slab, lockdep: Annotate the locks before using them

    Fernando found we hit the regular OFF_SLAB 'recursion' before we
    annotate the locks, cure this.

    The relevant portion of the stack-trace:

    > [    0.000000]  [<c085e24f>] rt_spin_lock+0x50/0x56
    > [    0.000000]  [<c04fb406>] __cache_free+0x43/0xc3
    > [    0.000000]  [<c04fb23f>] kmem_cache_free+0x6c/0xdc
    > [    0.000000]  [<c04fb2fe>] slab_destroy+0x4f/0x53
    > [    0.000000]  [<c04fb396>] free_block+0x94/0xc1
    > [    0.000000]  [<c04fc551>] do_tune_cpucache+0x10b/0x2bb
    > [    0.000000]  [<c04fc8dc>] enable_cpucache+0x7b/0xa7
    > [    0.000000]  [<c0bd9d3c>] kmem_cache_init_late+0x1f/0x61
    > [    0.000000]  [<c0bba687>] start_kernel+0x24c/0x363
    > [    0.000000]  [<c0bba0ba>] i386_start_kernel+0xa9/0xaf

    Reported-by: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
    Acked-by: Pekka Enberg <penberg@kernel.org>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1311888176.2617.379.camel@laptop
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

The commit moved init_lock_keys() before we build up the alien, so we
failed to reclass it.

Acked-by: Christoph Lameter <cl@linux.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/slab.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1669,9 +1669,6 @@ void __init kmem_cache_init_late(void)
 
 	g_cpucache_up = LATE;
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
 	list_for_each_entry(cachep, &cache_chain, next)
@@ -1679,6 +1676,9 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&cache_chain_mutex);
 
+	/* Annotate slab for lockdep -- annotate the malloc caches */
+	init_lock_keys();
+
 	/* Done! */
 	g_cpucache_up = FULL;
 


