Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2GaD0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 23:26:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52390 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2GaD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 23:26:54 -0400
Date: Mon, 30 Jul 2012 20:26:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Meelis Roos <mroos@linux.ee>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: change nr_ptes BUG_ON to WARN_ON
Message-ID: <alpine.LSU.2.00.1207302017040.6310@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From time to time an isolated BUG_ON(mm->nr_ptes) gets reported,
indicating that not all the page tables allocated could be found
and freed when exit_mmap() tore down the user address space.

There's usually nothing we can say about it, beyond that it's
probably a sign of some bad memory or memory corruption; though
it might still indicate a bug in vma or page table management
(and did recently reveal a race in THP, fixed a few months ago).

But one overdue change we can make is from BUG_ON to WARN_ON.

It's fairly likely that the system will crash shortly afterwards
in some other way (for example, the BUG_ON(page_mapped(page)) in
__delete_from_page_cache(), once an inode mapped into the lost
page tables gets evicted); but might tell us more before that.

Change the BUG_ON(page_mapped) to WARN_ON too?  Later perhaps:
I'm less eager, since that one has several times led to fixes.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- v3.5/mm/mmap.c	2012-07-21 13:58:29.000000000 -0700
+++ linux/mm/mmap.c	2012-07-30 19:38:41.977203670 -0700
@@ -2310,7 +2310,7 @@ void exit_mmap(struct mm_struct *mm)
 	}
 	vm_unacct_memory(nr_accounted);
 
-	BUG_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
+	WARN_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
 }
 
 /* Insert vm structure into process list sorted by address
