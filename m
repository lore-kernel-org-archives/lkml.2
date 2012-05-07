Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2EGLk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:40:58 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50897 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab2EGLiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 04/10] mm: bootmem: split out goal-to-node mapping from goal dropping
Date: Mon,  7 May 2012 13:37:46 +0200
Message-Id: <1336390672-14421-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matching the desired goal to the right node is one thing, dropping the
goal when it can not be satisfied is another.  Split this into
separate functions so that subsequent patches can use the node-finding
but drop and handle the goal fallback on their own terms.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/bootmem.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index ceed0df..bafeb2c 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -596,7 +596,7 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 	return NULL;
 }
 
-static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+static void * __init alloc_bootmem_core(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
 					unsigned long limit)
@@ -604,7 +604,6 @@ static void * __init ___alloc_bootmem_nopanic(unsigned long size,
 	bootmem_data_t *bdata;
 	void *region;
 
-restart:
 	region = alloc_arch_preferred_bootmem(NULL, size, align, goal, limit);
 	if (region)
 		return region;
@@ -620,6 +619,20 @@ restart:
 			return region;
 	}
 
+	return NULL;
+}
+
+static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+					      unsigned long align,
+					      unsigned long goal,
+					      unsigned long limit)
+{
+	void *ptr;
+
+restart:
+	ptr = alloc_bootmem_core(size, align, goal, limit);
+	if (ptr)
+		return ptr;
 	if (goal) {
 		goal = 0;
 		goto restart;
-- 
1.7.10

