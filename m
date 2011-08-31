Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1HaBoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 21:44:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57168 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754395Ab1HaBoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 21:44:30 -0400
Subject: [PATCH] mm: vmalloc - Report more vmalloc failures
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 18:44:28 -0700
Message-ID: <1314755068.27632.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some vmalloc failure paths do not report OOM conditions.

Add warn_alloc_failed, which also does a dump_stack,
to those failure paths.

This allows more site specific vmalloc failure
logging message printks to be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/vmalloc.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3122acc..5108e0b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1600,13 +1600,12 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
-		return NULL;
+		goto fail;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC, start, end, node,
 				  gfp_mask, caller);
-
 	if (!area)
-		return NULL;
+		goto fail;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 
@@ -1618,6 +1617,12 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	kmemleak_alloc(addr, real_size, 3, gfp_mask);
 
 	return addr;
+
+fail:
+	warn_alloc_failed(gfp_mask, 0,
+			  "vmalloc: allocation failure: %lu bytes\n",
+			  real_size);
+	return NULL;
 }
 
 /**


