Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1DYUc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:32:28 -0400
Received: from 1wt.eu ([62.212.114.60]:34585 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab1DYUZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:25 -0400
Message-Id: <20110425200238.685310786@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 131/173] mm: avoid wrapping vm_pgoff in mremap()
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[wt: 2.6.27 has this code in do_mremap()]

---
 mm/mremap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/mm/mremap.c
===================================================================
--- longterm-2.6.27.orig/mm/mremap.c	2011-04-25 15:24:54.000000000 +0200
+++ longterm-2.6.27/mm/mremap.c	2011-04-25 17:01:30.075279051 +0200
@@ -333,10 +333,21 @@
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
 		goto out;
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
-		if (new_len > old_len)
+
+	/* Need to be careful about a growing mapping */
+	if (new_len > old_len) {
+		unsigned long pgoff;
+
+		if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
+			goto out;
+		pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+		pgoff += vma->vm_pgoff;
+		if (pgoff + (new_len >> PAGE_SHIFT) < pgoff) {
+			ret = -EINVAL;
 			goto out;
+		}
 	}
+
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
 		locked = mm->locked_vm << PAGE_SHIFT;


