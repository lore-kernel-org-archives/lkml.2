Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab1DMQXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:23:46 -0400
Received: from kroah.org ([198.145.64.141]:52859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab1DMQND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:45 2011
Message-Id: <20110413161045.849221238@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [32/71] mm: avoid wrapping vm_pgoff in mremap()
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 mm/mremap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -275,9 +275,16 @@ static struct vm_area_struct *vma_to_res
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


