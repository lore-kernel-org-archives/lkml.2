Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2CGMLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:00 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46801 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2CGMK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:10:59 -0500
Message-ID: <4F575045.9010904@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 20:10:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: PATCH 1/2] rmap: cleanup anon_vma_prepare
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030712-5564-0000-0000-000001B42FC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the common function anon_vma_chain_link() to link vma and anon_vma

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/rmap.c |   35 ++++++++++++++++-------------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index c8454e0..55c5064 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -120,6 +120,21 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }

+static void anon_vma_chain_link(struct vm_area_struct *vma,
+				struct anon_vma_chain *avc,
+				struct anon_vma *anon_vma)
+{
+	avc->vma = vma;
+	avc->anon_vma = anon_vma;
+	list_add(&avc->same_vma, &vma->anon_vma_chain);
+
+	/*
+	 * It's critical to add new vmas to the tail of the anon_vma,
+	 * see comment in huge_memory.c:__split_huge_page().
+	 */
+	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
+}
+
 /**
  * anon_vma_prepare - attach an anon_vma to a memory region
  * @vma: the memory region in question
@@ -175,10 +190,7 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma = anon_vma;
-			avc->anon_vma = anon_vma;
-			avc->vma = vma;
-			list_add(&avc->same_vma, &vma->anon_vma_chain);
-			list_add_tail(&avc->same_anon_vma, &anon_vma->head);
+			anon_vma_chain_link(vma, avc, anon_vma);
 			allocated = NULL;
 			avc = NULL;
 		}
@@ -224,21 +236,6 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
 		mutex_unlock(&root->mutex);
 }

-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
-{
-	avc->vma = vma;
-	avc->anon_vma = anon_vma;
-	list_add(&avc->same_vma, &vma->anon_vma_chain);
-
-	/*
-	 * It's critical to add new vmas to the tail of the anon_vma,
-	 * see comment in huge_memory.c:__split_huge_page().
-	 */
-	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
-}
-
 /*
  * Attach the anon_vmas from src to dst.
  * Returns 0 on success, -ENOMEM on failure.
-- 
1.7.7.6

