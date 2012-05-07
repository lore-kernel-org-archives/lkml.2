Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2EGLiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:38:23 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50920 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab2EGLiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 05/10] mm: bootmem: allocate in order node+goal, goal, node, anywhere
Date: Mon,  7 May 2012 13:37:47 +0200
Message-Id: <1336390672-14421-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match the nobootmem version of __alloc_bootmem_node.  Try to satisfy
both the node and the goal, then just the goal, then just the node,
then allocate anywhere before panicking.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/bootmem.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index bafeb2c..b5babdf 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -704,6 +704,7 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 {
 	void *ptr;
 
+again:
 	ptr = alloc_arch_preferred_bootmem(bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
@@ -712,7 +713,18 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 	if (ptr)
 		return ptr;
 
-	return ___alloc_bootmem(size, align, goal, limit);
+	ptr = alloc_bootmem_core(size, align, goal, limit);
+	if (ptr)
+		return ptr;
+
+	if (goal) {
+		goal = 0;
+		goto again;
+	}
+
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
 }
 
 /**
-- 
1.7.10

