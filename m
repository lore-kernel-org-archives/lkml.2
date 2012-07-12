Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2GLF5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:57:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41844 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2GLF5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:57:14 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] bootmem: Make ___alloc_bootmem_node_nopanic() to be real nopanic
Date: Wed, 11 Jul 2012 22:56:59 -0700
Message-Id: <1342072619-13357-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20120711210254.AFF6D20004E@hpza10.eem.corp.google.com>
References: <20120711210254.AFF6D20004E@hpza10.eem.corp.google.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after
| From 99ab7b19440a72ebdf225f99b20f8ef40decee86 Mon Sep 17 00:00:00 2001
| Date: Wed, 11 Jul 2012 14:02:53 -0700
| Subject: [PATCH] mm: sparse: fix usemap allocation above node descriptor
 section

Johannes said:
| while backporting the below patch, I realised that your fix busted
| f5bf18fa22f8 again.  The problem was not a panicking version on
| allocation failure but when the usemap size was too large such that
| goal + size > limit triggers the BUG_ON in the bootmem allocator.  So
| we need a version that passes limit ONLY if the usemap is smaller than
| the section.

after checking the code, the name of ___alloc_bootmem_node_nopanic() does not
reflect the fact.

Make bootmem really not panic.

Hope will kill bootmem sooner.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org

---
 mm/bootmem.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -710,6 +710,10 @@ again:
 	if (ptr)
 		return ptr;
 
+	/* do not panic in alloc_bootmem_bdata() */
+	if (limit && goal + size > limit)
+		limit = 0;
+
 	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
