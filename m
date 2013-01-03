Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3ACE2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 23:28:16 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62218 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3ACE2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 23:28:13 -0500
X-AuditID: 9c930197-b7c5bae000000e31-c5-50e508d9cd6b
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFC 3/8] bail out when the page is in VOLATILE vma
Date: Thu,  3 Jan 2013 13:28:01 +0900
Message-Id: <1357187286-18759-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357187286-18759-1-git-send-email-minchan@kernel.org>
References: <1357187286-18759-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we found a page is in VOLATILE vma, hurry up discarding
instead of access bit check because it's very unlikey working set.

Next patch will use it.

Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 402d9da..fea01cd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -695,10 +695,12 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 		if (!pte)
 			goto out;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if ((vma->vm_flags & VM_LOCKED) ||
+				(vma->vm_flags & VM_VOLATILE)) {
 			pte_unmap_unlock(pte, ptl);
 			*mapcount = 0;	/* break early from loop */
-			*vm_flags |= VM_LOCKED;
+			*vm_flags |= (vma->vm_flags & VM_LOCKED ?
+					VM_LOCKED : VM_VOLATILE);
 			goto out;
 		}
 
-- 
1.7.9.5

