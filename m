Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab1KKMfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:35:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab1KKMfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:35:44 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/4] slub: min order when corrupt_dbg
Date: Fri, 11 Nov 2011 13:36:34 +0100
Message-Id: <1321014994-2426-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
References: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable slub debug facilities and allocate slabs at minimal order when
corrupt_dbg > 0 to increase probability to catch random memory
corruption by cpu exception.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 mm/slub.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7d2a996..b0e4318 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2844,7 +2844,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	unsigned long flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
-	int order;
+	int order, min_order;
 
 	/*
 	 * Round up object size to the next word boundary. We can only
@@ -2929,8 +2929,11 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	 */
 	size = ALIGN(size, align);
 	s->size = size;
+	min_order = get_order(size);
 	if (forced_order >= 0)
 		order = forced_order;
+	else if (corrupt_dbg())
+		order = min_order;
 	else
 		order = calculate_order(size, s->reserved);
 
@@ -2951,7 +2954,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	 * Determine the number of objects per slab
 	 */
 	s->oo = oo_make(order, size, s->reserved);
-	s->min = oo_make(get_order(size), size, s->reserved);
+	s->min = oo_make(min_order, size, s->reserved);
 	if (oo_objects(s->oo) > oo_objects(s->max))
 		s->max = s->oo;
 
@@ -3645,6 +3648,9 @@ void __init kmem_cache_init(void)
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
 
+	if (corrupt_dbg())
+		slub_debug = 0;
+
 	kmem_size = offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *);
 
-- 
1.7.1

