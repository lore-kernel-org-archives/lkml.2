Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab2CMASE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:18:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:46783 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab2CMASA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 034/196] mm: avoid wrapping vm_pgoff in mremap()
Date: Mon, 12 Mar 2012 20:12:42 -0400
Message-Id: <1331597724-31358-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 982134ba62618c2d69fbbbd166d0a11ee3b7e3d8 upstream.

The normal mmap paths all avoid creating a mapping where the pgoff
inside the mapping could wrap around due to overflow.  However, an
expanding mremap() can take such a non-wrapping mapping and make it
bigger and cause a wrapping condition.

Noticed by Robert Swiecki when running a system call fuzzer, where it
caused a BUG_ON() due to terminally confusing the vma_prio_tree code.  A
vma dumping patch by Hugh then pinpointed the crazy wrapped case.

Reported-and-tested-by: Robert Swiecki <robert@swiecki.net>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mremap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 10d5f62..97de5ae 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -274,9 +274,16 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 	if (old_len > vma->vm_end - addr)
 		goto Efault;
 
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
-		if (new_len > old_len)
+	/* Need to be careful about a growing mapping */
+	if (new_len > old_len) {
+		unsigned long pgoff;
+
+		if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 			goto Efault;
+		pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+		pgoff += vma->vm_pgoff;
+		if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
+			goto Einval;
 	}
 
 	if (vma->vm_flags & VM_LOCKED) {
-- 
1.7.9.3

