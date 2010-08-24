Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab0HXWyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:54:03 -0400
Received: from kroah.org ([198.145.64.141]:52154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab0HXWxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:55 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:24 2010
Message-Id: <20100824222524.569637694@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [25/59] mm: make the mlock() stack guard page checks stricter
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7798330ac8114c731cfab83e634c6ecedaa233d7 upstream.

If we've split the stack vma, only the lowest one has the guard page.
Now that we have a doubly linked list of vma's, checking this is trivial.

Tested-by: Ian Campbell <ijc@hellion.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mlock.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -138,6 +138,19 @@ void munlock_vma_page(struct page *page)
 	}
 }
 
+/* Is the vma a continuation of the stack vma above it? */
+static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
+{
+	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
+}
+
+static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
+{
+	return (vma->vm_flags & VM_GROWSDOWN) &&
+		(vma->vm_start == addr) &&
+		!vma_stack_continue(vma->vm_prev, addr);
+}
+
 /**
  * __mlock_vma_pages_range() -  mlock a range of pages in the vma.
  * @vma:   target vma
@@ -171,11 +184,9 @@ static long __mlock_vma_pages_range(stru
 		gup_flags |= FOLL_WRITE;
 
 	/* We don't try to access the guard page of a stack vma */
-	if (vma->vm_flags & VM_GROWSDOWN) {
-		if (start == vma->vm_start) {
-			start += PAGE_SIZE;
-			nr_pages--;
-		}
+	if (stack_guard_page(vma, start)) {
+		addr += PAGE_SIZE;
+		nr_pages--;
 	}
 
 	while (nr_pages > 0) {


