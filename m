Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777Ab0KQMYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:24:45 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11894 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934733Ab0KQMYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:24:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F/b9GhrI8UF1fBqCIjUwcGn4x0mQkvH+vViO44IsMRasiVR1ZuIp39TmPH+FQEOu+2
         Kv5KvlM+OVls+PncDpMw==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 2/3] do_wp_page: clarify dirty_page handling
Date: Wed, 17 Nov 2010 04:23:57 -0800
Message-Id: <1289996638-21439-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289996638-21439-1-git-send-email-walken@google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize the code so that dirty pages are handled closer to the place
that makes them dirty (handling write fault into shared, writable VMAs).
No behavior changes.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/memory.c |   72 +++++++++++++++++++++++++++++++---------------------------
 1 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 810a75f..d4c0c2e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2227,8 +2227,45 @@ reuse:
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (ptep_set_access_flags(vma, address, page_table, entry,1))
 			update_mmu_cache(vma, address, page_table);
+		pte_unmap_unlock(page_table, ptl);
 		ret |= VM_FAULT_WRITE;
-		goto unlock;
+
+		if (!dirty_page)
+			return ret;
+
+		/*
+		 * Yes, Virginia, this is actually required to prevent a race
+		 * with clear_page_dirty_for_io() from clearing the page dirty
+		 * bit after it clear all dirty ptes, but before a racing
+		 * do_wp_page installs a dirty pte.
+		 *
+		 * do_no_page is protected similarly.
+		 */
+		if (!page_mkwrite) {
+			wait_on_page_locked(dirty_page);
+			set_page_dirty_balance(dirty_page, page_mkwrite);
+		}
+		put_page(dirty_page);
+		if (page_mkwrite) {
+			struct address_space *mapping = dirty_page->mapping;
+
+			set_page_dirty(dirty_page);
+			unlock_page(dirty_page);
+			page_cache_release(dirty_page);
+			if (mapping)	{
+				/*
+				 * Some device drivers do not set page.mapping
+				 * but still dirty their pages
+				 */
+				balance_dirty_pages_ratelimited(mapping);
+			}
+		}
+
+		/* file_update_time outside page_lock */
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
+
+		return ret;
 	}
 
 	/*
@@ -2334,39 +2371,6 @@ gotten:
 		page_cache_release(old_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
-	if (dirty_page) {
-		/*
-		 * Yes, Virginia, this is actually required to prevent a race
-		 * with clear_page_dirty_for_io() from clearing the page dirty
-		 * bit after it clear all dirty ptes, but before a racing
-		 * do_wp_page installs a dirty pte.
-		 *
-		 * do_no_page is protected similarly.
-		 */
-		if (!page_mkwrite) {
-			wait_on_page_locked(dirty_page);
-			set_page_dirty_balance(dirty_page, page_mkwrite);
-		}
-		put_page(dirty_page);
-		if (page_mkwrite) {
-			struct address_space *mapping = dirty_page->mapping;
-
-			set_page_dirty(dirty_page);
-			unlock_page(dirty_page);
-			page_cache_release(dirty_page);
-			if (mapping)	{
-				/*
-				 * Some device drivers do not set page.mapping
-				 * but still dirty their pages
-				 */
-				balance_dirty_pages_ratelimited(mapping);
-			}
-		}
-
-		/* file_update_time outside page_lock */
-		if (vma->vm_file)
-			file_update_time(vma->vm_file);
-	}
 	return ret;
 oom_free_new:
 	page_cache_release(new_page);
-- 
1.7.3.1

