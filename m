Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1BHAsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:48:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:21250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1BHAsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QRnsAEghgTLNNQ7wl33jCiwkMxQWDkICUuUtvHDE+3ACEbCUOQRIq20thHm0L2gc5v
         6/FZ6jiSgcJdtaaKxo3g==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mlock: fix race when munlocking pages in do_wp_page()
Date: Mon,  7 Feb 2011 16:47:35 -0800
Message-Id: <1297126056-14322-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297126056-14322-1-git-send-email-walken@google.com>
References: <1297126056-14322-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmscan can lazily find pages that are mapped within VM_LOCKED vmas,
and set the PageMlocked bit on these pages, transfering them onto the
unevictable list. When do_wp_page() breaks COW within a VM_LOCKED vma,
it may need to clear PageMlocked on the old page and set it on the
new page instead.

This change fixes an issue where do_wp_page() was clearing PageMlocked on
the old page while the pte was still pointing to it (as well as rmap).
Therefore, we were not protected against vmscan immediately trasnfering
the old page back onto the unevictable list. This could cause pages to
get stranded there forever.

I propose to move the corresponding code to the end of do_wp_page(),
after the pte (and rmap) have been pointed to the new page. Additionally,
we can use munlock_vma_page() instead of clear_page_mlock(), so that
the old page stays mlocked if there are still other VM_LOCKED vmas
mapping it.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/memory.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 31250fa..32df03c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2219,7 +2219,6 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 							 &ptl);
 			if (!pte_same(*page_table, orig_pte)) {
 				unlock_page(old_page);
-				page_cache_release(old_page);
 				goto unlock;
 			}
 			page_cache_release(old_page);
@@ -2289,7 +2288,6 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 							 &ptl);
 			if (!pte_same(*page_table, orig_pte)) {
 				unlock_page(old_page);
-				page_cache_release(old_page);
 				goto unlock;
 			}
 
@@ -2367,16 +2365,6 @@ gotten:
 	}
 	__SetPageUptodate(new_page);
 
-	/*
-	 * Don't let another task, with possibly unlocked vma,
-	 * keep the mlocked page.
-	 */
-	if ((vma->vm_flags & VM_LOCKED) && old_page) {
-		lock_page(old_page);	/* for LRU manipulation */
-		clear_page_mlock(old_page);
-		unlock_page(old_page);
-	}
-
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
@@ -2444,10 +2432,20 @@ gotten:
 
 	if (new_page)
 		page_cache_release(new_page);
-	if (old_page)
-		page_cache_release(old_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
+	if (old_page) {
+		/*
+		 * Don't let another task, with possibly unlocked vma,
+		 * keep the mlocked page.
+		 */
+		if ((ret & VM_FAULT_WRITE) && (vma->vm_flags & VM_LOCKED)) {
+			lock_page(old_page);	/* LRU manipulation */
+			munlock_vma_page(old_page);
+			unlock_page(old_page);
+		}
+		page_cache_release(old_page);
+	}
 	return ret;
 oom_free_new:
 	page_cache_release(new_page);
-- 
1.7.3.1
