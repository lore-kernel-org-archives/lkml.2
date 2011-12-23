Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1LWNf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:35:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42429 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab1LWNf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:35:26 -0500
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 21:35:25 +0800
Message-ID: <CAJd=RBB-d19=Z0og0i5OrbUVCQFozaqMbVs9Fzw23j=-EFc+DQ@mail.gmail.com>
Subject: [PATCH] mm: hugetlb: fix non-atomic enqueue of huge page
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: hugetlb: fix non-atomic enqueue of huge page

If huge page is enqueued under the protection of hugetlb_lock, then
the operation is atomic and safe.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
+++ b/mm/hugetlb.c	Fri Dec 23 21:16:28 2011
@@ -901,7 +901,6 @@ retry:
 	h->resv_huge_pages += delta;
 	ret = 0;

-	spin_unlock(&hugetlb_lock);
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
@@ -915,6 +914,7 @@ retry:
 		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
+	spin_unlock(&hugetlb_lock);

 	/* Free unnecessary surplus pages to the buddy allocator */
 free:
