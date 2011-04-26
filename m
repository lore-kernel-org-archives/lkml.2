Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab1DZVN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:19974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab1DZVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950930"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: torvalds@linux-foundation.org, hughd@google.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [21/106] mm: avoid wrapping vm_pgoff in mremap()
Message-Id: <20110426211259.D4DF63E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/mremap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/mm/mremap.c
===================================================================
--- linux-2.6.35.y.orig/mm/mremap.c
+++ linux-2.6.35.y/mm/mremap.c
@@ -274,9 +274,16 @@ static struct vm_area_struct *vma_to_res
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
