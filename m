Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1HSHtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:49:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1HSHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:48:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=OX8fYtAKhtZ0ffR7ovg41Ja90fYVQ99HlBVatopgpwQGe+2gNpe7xxwvndST4U1JK
	Q4nR6HvY3yChagjnxdtJA==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 2/9] mm: avoid calling get_page_unless_zero() when charging cgroups
Date: Fri, 19 Aug 2011 00:48:24 -0700
Message-Id: <1313740111-27446-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mem_cgroup_move_parent(), we can avoid the get_page_unless_zero()
call by taking a page reference under protection of the zone LRU lock
in mem_cgroup_force_empty_list().

In mc_handle_present_pte(), the page count is already known to be
nonzero as there is a PTE pointing to it and the page table lock is held.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/memcontrol.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e013b8e..f9439ef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2649,7 +2649,7 @@ out:
 }
 
 /*
- * move charges to its parent.
+ * move charges to its parent. Caller must hold a reference on page.
  */
 
 static int mem_cgroup_move_parent(struct page *page,
@@ -2669,10 +2669,8 @@ static int mem_cgroup_move_parent(struct page *page,
 		return -EINVAL;
 
 	ret = -EBUSY;
-	if (!get_page_unless_zero(page))
-		goto out;
 	if (isolate_lru_page(page))
-		goto put;
+		goto out;
 
 	nr_pages = hpage_nr_pages(page);
 
@@ -2692,8 +2690,6 @@ static int mem_cgroup_move_parent(struct page *page,
 		compound_unlock_irqrestore(page, flags);
 put_back:
 	putback_lru_page(page);
-put:
-	put_page(page);
 out:
 	return ret;
 }
@@ -3732,11 +3728,12 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
 			continue;
 		}
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
-
 		page = lookup_cgroup_page(pc);
+		get_page(page);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
+		put_page(page);
 		if (ret == -ENOMEM)
 			break;
 
@@ -5133,9 +5130,12 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
 		return NULL;
-	if (!get_page_unless_zero(page))
-		return NULL;
 
+	/*
+	 * The page reference count is guaranteed to be nonzero since
+	 * ptent points to that page and the page table lock is held.
+	 */
+	get_page(page);
 	return page;
 }
 
-- 
1.7.3.1

