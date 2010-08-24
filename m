Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab0HXXQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:16:03 -0400
Received: from kroah.org ([198.145.64.141]:41116 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470Ab0HXXC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:29 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:06 2010
Message-Id: <20100824224505.948376120@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [054/114] mm: make stack guard page logic use vm_prev pointer
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0e8e50e20c837eeec8323bba7dcd25fe5479194c upstream.

Like the mlock() change previously, this makes the stack guard check
code use vma->vm_prev to see what the mapping below the current stack
is, rather than have to look it up with find_vma().

Also, accept an abutting stack segment, since that happens naturally if
you split the stack with mlock or mprotect.

Tested-by: Ian Campbell <ijc@hellion.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2770,11 +2770,18 @@ static inline int check_stack_guard_page
 {
 	address &= PAGE_MASK;
 	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
-		address -= PAGE_SIZE;
-		if (find_vma(vma->vm_mm, address) != vma)
-			return -ENOMEM;
+		struct vm_area_struct *prev = vma->vm_prev;
 
-		expand_stack(vma, address);
+		/*
+		 * Is there a mapping abutting this one below?
+		 *
+		 * That's only ok if it's the same stack mapping
+		 * that has gotten split..
+		 */
+		if (prev && prev->vm_end == address)
+			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
+
+		expand_stack(vma, address - PAGE_SIZE);
 	}
 	return 0;
 }


