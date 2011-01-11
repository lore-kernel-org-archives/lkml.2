Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1AKHKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 02:10:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1AKHKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 02:10:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=G8Hw4/husXj1TG3EMM43m6YXjyWgvRaORexDOFI4VZp21RnNQGCW/d03a6DcdZXuq+
         +Vsx4vdw0Skme6/spTcg==
Date: Mon, 10 Jan 2011 23:10:21 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: fix hugepage migration in the same way
In-Reply-To: <alpine.LSU.2.00.1101102259160.24988@sister.anvils>
Message-ID: <alpine.LSU.2.00.1101102308310.24988@sister.anvils>
References: <alpine.LSU.2.00.1101102259160.24988@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37 added an unmap_and_move_huge_page() for memory failure recovery,
but its anon_vma handling was still based around the 2.6.35 conventions.
Update it to use page_lock_anon_vma, get_anon_vma, page_unlock_anon_vma,
drop_anon_vma in the same way as we're now changing unmap_and_move().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org [2.6.37]
---
I don't particularly like to propose this for stable when I've not seen
its problems in practice nor tested the solution: but it's clearly
out of synch at present.

 mm/migrate.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- 2.6.37/mm/migrate.c	2011-01-10 17:23:39.000000000 -0800
+++ linux/mm/migrate.c	2011-01-10 22:01:16.000000000 -0800
@@ -806,7 +806,6 @@ static int unmap_and_move_huge_page(new_
 	int rc = 0;
 	int *result = NULL;
 	struct page *new_hpage = get_new_page(hpage, private, &result);
-	int rcu_locked = 0;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!new_hpage)
@@ -821,12 +820,10 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (PageAnon(hpage)) {
-		rcu_read_lock();
-		rcu_locked = 1;
-
-		if (page_mapped(hpage)) {
-			anon_vma = page_anon_vma(hpage);
-			atomic_inc(&anon_vma->external_refcount);
+		anon_vma = page_lock_anon_vma(hpage);
+		if (anon_vma) {
+			get_anon_vma(anon_vma);
+			page_unlock_anon_vma(anon_vma);
 		}
 	}
 
@@ -838,16 +835,8 @@ static int unmap_and_move_huge_page(new_
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
 
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount,
-					    &anon_vma->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
-
-	if (rcu_locked)
-		rcu_read_unlock();
+	if (anon_vma)
+		drop_anon_vma(anon_vma);
 out:
 	unlock_page(hpage);
 
