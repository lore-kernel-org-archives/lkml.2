Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0GITOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:14:53 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34342 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0GITMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:22 -0400
Message-Id: <20100709190853.195193717@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:12 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [S+Q2 06/19] slub: Check kasprintf results in kmem_cache_init()
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=slub_check_kasprintf_result
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small allocations may fail during slab bringup which is fatal. Add a BUG_ON()
so that we fail immediately rather than failing later during sysfs
processing.

CC: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-06 15:12:14.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-06 15:13:48.000000000 -0500
@@ -3118,9 +3118,12 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++)
-		kmalloc_caches[i]. name =
-			kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
+	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
+		char *s = kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
+
+		BUG_ON(!s);
+		kmalloc_caches[i].name = s;
+	}
 
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);

