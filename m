Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab0KQMYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:24:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934750Ab0KQMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=STASSs18eDe4J9aZABdXjWjwEaH1S/JDOqcb9hHu5QLc49RQ1xtBD8eXZDLeyaX8N+
         s3XmMiaBGPpyMUd+cBXg==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 1/3] do_wp_page: remove the 'reuse' flag
Date: Wed, 17 Nov 2010 04:23:56 -0800
Message-Id: <1289996638-21439-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289996638-21439-1-git-send-email-walken@google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize the code to remove the 'reuse' flag. No behavior changes.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/memory.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0e18b4d..810a75f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2110,7 +2110,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	struct page *old_page, *new_page;
 	pte_t entry;
-	int reuse = 0, ret = 0;
+	int ret = 0;
 	int page_mkwrite = 0;
 	struct page *dirty_page = NULL;
 
@@ -2147,14 +2147,16 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			}
 			page_cache_release(old_page);
 		}
-		reuse = reuse_swap_page(old_page);
-		if (reuse)
+		if (reuse_swap_page(old_page)) {
 			/*
 			 * The page is all ours.  Move it to our anon_vma so
 			 * the rmap code will not search our parent or siblings.
 			 * Protected against the rmap code by the page lock.
 			 */
 			page_move_anon_rmap(old_page, vma, address);
+			unlock_page(old_page);
+			goto reuse;
+		}
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
@@ -2218,10 +2220,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 		dirty_page = old_page;
 		get_page(dirty_page);
-		reuse = 1;
-	}
 
-	if (reuse) {
 reuse:
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
-- 
1.7.3.1

