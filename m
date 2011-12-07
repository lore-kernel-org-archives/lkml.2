Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab1LGQ0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:26:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933792Ab1LGQ0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:26:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:22 2011
Message-Id: <20111207161222.260209526@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:33 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [091/104] slab, lockdep: Fix silly bug
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 52cef189165d74a5d6030184a8e05595194c69ca upstream.

Commit 30765b92 ("slab, lockdep: Annotate the locks before using
them") moves the init_lock_keys() call from after g_cpucache_up =
FULL, to before it. And overlooks the fact that init_node_lock_keys()
tests for it and ignores everything !FULL.

Introduce a LATE stage and change the lockdep test to be <LATE.

Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slab.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -595,6 +595,7 @@ static enum {
 	PARTIAL_AC,
 	PARTIAL_L3,
 	EARLY,
+	LATE,
 	FULL
 } g_cpucache_up;
 
@@ -671,7 +672,7 @@ static void init_node_lock_keys(int q)
 {
 	struct cache_sizes *s = malloc_sizes;
 
-	if (g_cpucache_up != FULL)
+	if (g_cpucache_up < LATE)
 		return;
 
 	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
@@ -1666,6 +1667,8 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
+	g_cpucache_up = LATE;
+
 	/* Annotate slab for lockdep -- annotate the malloc caches */
 	init_lock_keys();
 


