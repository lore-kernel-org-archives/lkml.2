Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2HOPja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:39:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40253 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2HOPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:39:28 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] slub: try to get cpu partial slab even if we get enough objects for cpu freelist
Date: Thu, 16 Aug 2012 00:38:04 +0900
Message-Id: <1345045084-7292-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s->cpu_partial determine the maximum number of objects kept
in the per cpu partial lists of a processor. Currently, it is used for
not only per cpu partial list but also cpu freelist. Therefore
get_partial_node() doesn't work properly according to our first intention.

Fix it as forcibly assigning 0 to objects count when we get for cpu freelist.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>

diff --git a/mm/slub.c b/mm/slub.c
index efce427..88dca1d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1550,7 +1550,12 @@ static void *get_partial_node(struct kmem_cache *s,
 			c->page = page;
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
-			available =  page->objects - page->inuse;
+
+			/*
+			 * We don't want to stop without trying to get
+			 * cpu partial slab. So, forcibly set 0 to available
+			 */
+			available = 0;
 		} else {
 			available = put_cpu_partial(s, page, 0);
 			stat(s, CPU_PARTIAL_NODE);
-- 
1.7.9.5

