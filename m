Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab1FWR4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:56:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:35165 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632Ab1FWRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 154/247] mm: fix possible cause of a page_mapped BUG
Date: Thu, 23 Jun 2011 13:33:42 -0400
Message-Id: <1308850515-15242-95-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a3e8cc643d22d2c8ed36b9be7d9c9ca21efcf7f7 upstream.

Robert Swiecki reported a BUG_ON(page_mapped) from a fuzzer, punching
a hole with madvise(,, MADV_REMOVE).  That path is under mutex, and
cannot be explained by lack of serialization in unmap_mapping_range().

Reviewing the code, I found one place where vm_truncate_count handling
should have been updated, when I switched at the last minute from one
way of managing the restart_addr to another: mremap move changes the
virtual addresses, so it ought to adjust the restart_addr.

But rather than exporting the notion of restart_addr from memory.c, or
converting to restart_pgoff throughout, simply reset vm_truncate_count
to 0 to force a rescan if mremap move races with preempted truncation.

We have no confirmation that this fixes Robert's BUG,
but it is a fix that's worth making anyway.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mremap.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index cde56ee..10d5f62 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -91,9 +91,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		 */
 		mapping = vma->vm_file->f_mapping;
 		spin_lock(&mapping->i_mmap_lock);
-		if (new_vma->vm_truncate_count &&
-		    new_vma->vm_truncate_count != vma->vm_truncate_count)
-			new_vma->vm_truncate_count = 0;
+		new_vma->vm_truncate_count = 0;
 	}
 
 	/*
-- 
1.7.4.4

