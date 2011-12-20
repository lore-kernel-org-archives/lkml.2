Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1LTWuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:50:54 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:47531 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1LTWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:50:52 -0500
From: kosaki.motohiro@gmail.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/3=67% 
	,commit_signer:19/24=79%),
        Stephen Wilson <wilsons@start.ca> (commit_signer:2/3=67% 
	,commit_signer:6/24=25%),
        Andrea Arcangeli <aarcange@redhat.com> (commit_signer:5/24=21%),
        Johannes Weiner <hannes@cmpxchg.org> (commit_signer:3/24=12%)
Subject: [PATCH] mm,mempolicy: mpol_equal() use bool
Date: Tue, 20 Dec 2011 17:50:28 -0500
Message-Id: <1324421434-14342-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

mpol_equal() logically return boolean. then it should be used bool.
This change slightly improve readability.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mempolicy.h |   10 +++++-----
 mm/mempolicy.c            |   14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 7978eec..7c727a9 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -164,11 +164,11 @@ static inline void mpol_get(struct mempolicy *pol)
 		atomic_inc(&pol->refcnt);
 }
 
-extern int __mpol_equal(struct mempolicy *a, struct mempolicy *b);
-static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
+extern bool __mpol_equal(struct mempolicy *a, struct mempolicy *b);
+static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	if (a == b)
-		return 1;
+		return true;
 	return __mpol_equal(a, b);
 }
 
@@ -257,9 +257,9 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 
 struct mempolicy {};
 
-static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
+static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
-	return 1;
+	return true;
 }
 
 static inline void mpol_put(struct mempolicy *p)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index adc3954..475f1c7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1974,28 +1974,28 @@ struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
 }
 
 /* Slow path of a mempolicy comparison */
-int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
+bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	if (!a || !b)
-		return 0;
+		return false;
 	if (a->mode != b->mode)
-		return 0;
+		return false;
 	if (a->flags != b->flags)
-		return 0;
+		return false;
 	if (mpol_store_user_nodemask(a))
 		if (!nodes_equal(a->w.user_nodemask, b->w.user_nodemask))
-			return 0;
+			return false;
 
 	switch (a->mode) {
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
-		return nodes_equal(a->v.nodes, b->v.nodes);
+		return !!nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
 		return a->v.preferred_node == b->v.preferred_node;
 	default:
 		BUG();
-		return 0;
+		return false;
 	}
 }
 
-- 
1.7.1

