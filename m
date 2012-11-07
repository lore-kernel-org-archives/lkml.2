Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2KGIRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:17:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGIRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:17:09 -0500
Date: Wed, 7 Nov 2012 00:17:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, mempolicy: remove duplicate code
Message-ID: <alpine.DEB.2.00.1211070016080.21854@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some duplicate code and simplify alloc_pages_vma().  No functional
change.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1907,7 +1907,6 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr, int node)
 {
 	struct mempolicy *pol;
-	struct zonelist *zl;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
@@ -1926,23 +1925,11 @@ retry_cpuset:
 
 		return page;
 	}
-	zl = policy_zonelist(gfp, pol, node);
-	if (unlikely(mpol_needs_cond_ref(pol))) {
-		/*
-		 * slow path: ref counted shared policy
-		 */
-		struct page *page =  __alloc_pages_nodemask(gfp, order,
-						zl, policy_nodemask(gfp, pol));
-		__mpol_put(pol);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
-			goto retry_cpuset;
-		return page;
-	}
-	/*
-	 * fast path:  default or task policy
-	 */
-	page = __alloc_pages_nodemask(gfp, order, zl,
+	page = __alloc_pages_nodemask(gfp, order,
+				      policy_zonelist(gfp, pol, node),
 				      policy_nodemask(gfp, pol));
+	if (unlikely(mpol_needs_cond_ref(pol)))
+		__mpol_put(pol);
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 	return page;
