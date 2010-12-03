Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab0LCASH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:18:07 -0500
Received: from smtp-out.google.com ([74.125.121.35]:40441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab0LCARW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b26vg9SzKquELtB9UcDB5WjH7l5RSEnqZpBvtuww1cdEr3XAhEH87dgYrf7NJiEDuw
         5zorPIMgunVGPxCjmfEQ==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/6] mm: move VM_LOCKED check to __mlock_vma_pages_range()
Date: Thu,  2 Dec 2010 16:16:49 -0800
Message-Id: <1291335412-16231-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291335412-16231-1-git-send-email-walken@google.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a single code path for faulting in pages during mlock.

The reason to have it in this patch series is that I did not want to
update both code paths in a later change that releases mmap_sem when
blocking on disk.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/mlock.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 0531173..241a5d2 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -169,7 +169,7 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	VM_BUG_ON(end   > vma->vm_end);
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
-	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
+	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
@@ -178,6 +178,9 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	if (vma->vm_flags & VM_LOCKED)
+		gup_flags |= FOLL_MLOCK;
+
 	/* We don't try to access the guard page of a stack vma */
 	if (stack_guard_page(vma, start)) {
 		addr += PAGE_SIZE;
@@ -456,14 +459,11 @@ static int do_mlock_pages(unsigned long start, size_t len)
 		/*
 		 * Now fault in a range of pages within the first VMA.
 		 */
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = __mlock_vma_pages_range(vma, nstart, nend);
-			if (ret) {
-				ret = __mlock_posix_error_return(ret);
-				break;
-			}
-		} else
-			make_pages_present(nstart, nend);
+		ret = __mlock_vma_pages_range(vma, nstart, nend);
+		if (ret) {
+			ret = __mlock_posix_error_return(ret);
+			break;
+		}
 	}
 	up_read(&mm->mmap_sem);
 	return ret;	/* 0 or negative error code */
-- 
1.7.3.1

