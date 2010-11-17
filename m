Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772Ab0KQMY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:24:28 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11919 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934750Ab0KQMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gJYAhKtt8Xy32T95fWL+DZTgkFwHmfqGzg4D8I0xyDZeH24L6zLYvnhSZ7B+P+zfLU
         ylAOnfkmPFfnmpG7Jz2A==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
Date: Wed, 17 Nov 2010 04:23:58 -0800
Message-Id: <1289996638-21439-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289996638-21439-1-git-send-email-walken@google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When faulting in pages for mlock(), we want to break COW for anonymous
or file pages within VM_WRITABLE, non-VM_SHARED vmas. However, there is
no need to write-fault into VM_SHARED vmas since shared file pages can
be mlocked first and dirtied later, when/if they actually get written to.
Skipping the write fault is desirable, as we don't want to unnecessarily
cause these pages to be dirtied and queued for writeback.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/memory.c |    7 ++++++-
 mm/mlock.c  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d4c0c2e..7f45085 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3291,7 +3291,12 @@ int make_pages_present(unsigned long addr, unsigned long end)
 	vma = find_vma(current->mm, addr);
 	if (!vma)
 		return -ENOMEM;
-	write = (vma->vm_flags & VM_WRITE) != 0;
+	/*
+	 * We want to touch writable mappings with a write fault in order
+	 * to break COW, except for shared mappings because these don't COW
+	 * and we would not want to dirty them for nothing.
+	 */
+	write = (vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
diff --git a/mm/mlock.c b/mm/mlock.c
index b70919c..4f31864 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -171,7 +171,12 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
 	gup_flags = FOLL_TOUCH | FOLL_GET;
-	if (vma->vm_flags & VM_WRITE)
+	/*
+	 * We want to touch writable mappings with a write fault in order
+	 * to break COW, except for shared mappings because these don't COW
+	 * and we would not want to dirty them for nothing.
+	 */
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
 	/* We don't try to access the guard page of a stack vma */
-- 
1.7.3.1

