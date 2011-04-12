Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1DLOib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:31 -0400
Received: from kroah.org ([198.145.64.141]:57627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1DLOi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143554.819093370@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [064/105] mm: avoid wrapping vm_pgoff in mremap()
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -277,9 +277,16 @@ static struct vm_area_struct *vma_to_res
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


