Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1BZMU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 07:20:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1BZMU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 07:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nbeduuFTX6Y8Ax1aND0W3GGaFgruVoVHFodRGKDi+JgeJu6Q+qk6i8ZsvpwJBkfbXp
         fragMYhRsrOdPq5fAO7qTF6+hOYs/5tPn5wDZbd3l0cPwB14gRMnCx21Ir8LBRrvgEUN
         ODXfhHw7pjORTZw+/TTNkt6EfLM5yZk7/cLIQ=
Date: Sat, 26 Feb 2011 13:20:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH x86-mm] mm: Move early_node_map[] reverse scan helpers
 under HAVE_MEMBLOCK
Message-ID: <20110226122022.GA12392@htj.dyndns.org>
References: <20110226065215.GA28222@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226065215.GA28222@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cc28989437de5617875a2943697fe6ba51a0da8f Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Sat, 26 Feb 2011 13:05:43 +0100

Heiko found recent memblock change triggers these warnings on s390:

  mm/page_alloc.c:3623:22: warning: 'last_active_region_index_in_nid' defined but not used
  mm/page_alloc.c:3638:22: warning: 'previous_active_region_index_in_nid' defined but not used

Need to move those two function under HAVE_MEMBLOCK with its only
user, find_memory_core_early().

-tj: Minor updates to description.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to x86-mm.  Thanks.

 mm/page_alloc.c |   64 +++++++++++++++++++++++++++---------------------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6035136..da0fe32 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3616,34 +3616,6 @@ static int __meminit next_active_region_index_in_nid(int index, int nid)
 	return -1;
 }
 
-/*
- * Basic iterator support. Return the last range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns last region regardless of node
- */
-static int __meminit last_active_region_index_in_nid(int nid)
-{
-	int i;
-
-	for (i = nr_nodemap_entries - 1; i >= 0; i--)
-		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
-			return i;
-
-	return -1;
-}
-
-/*
- * Basic iterator support. Return the previous active range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns next region regardless of node
- */
-static int __meminit previous_active_region_index_in_nid(int index, int nid)
-{
-	for (index = index - 1; index >= 0; index--)
-		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
-			return index;
-
-	return -1;
-}
-
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
@@ -3695,10 +3667,6 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 	for (i = first_active_region_index_in_nid(nid); i != -1; \
 				i = next_active_region_index_in_nid(i, nid))
 
-#define for_each_active_range_index_in_nid_reverse(i, nid) \
-	for (i = last_active_region_index_in_nid(nid); i != -1; \
-				i = previous_active_region_index_in_nid(i, nid))
-
 /**
  * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
@@ -3731,6 +3699,38 @@ void __init free_bootmem_with_active_regions(int nid,
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK
+/*
+ * Basic iterator support. Return the last range of PFNs for a node
+ * Note: nid == MAX_NUMNODES returns last region regardless of node
+ */
+static int __meminit last_active_region_index_in_nid(int nid)
+{
+	int i;
+
+	for (i = nr_nodemap_entries - 1; i >= 0; i--)
+		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
+			return i;
+
+	return -1;
+}
+
+/*
+ * Basic iterator support. Return the previous active range of PFNs for a node
+ * Note: nid == MAX_NUMNODES returns next region regardless of node
+ */
+static int __meminit previous_active_region_index_in_nid(int index, int nid)
+{
+	for (index = index - 1; index >= 0; index--)
+		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
+			return index;
+
+	return -1;
+}
+
+#define for_each_active_range_index_in_nid_reverse(i, nid) \
+	for (i = last_active_region_index_in_nid(nid); i != -1; \
+				i = previous_active_region_index_in_nid(i, nid))
+
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit)
 {
-- 
1.7.1

