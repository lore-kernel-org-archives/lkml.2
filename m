Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983Ab1KCBnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:43:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934957Ab1KCBn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:48 2011
Message-Id: <20111102222748.725734410@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hugh Dickins <hughd@google.com>
Subject: [098/101] vm: fix vm_pgoff wrap in upward expansion
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 42c36f63ac1366ab0ecc2d5717821362c259f517 upstream.

Commit a626ca6a6564 ("vm: fix vm_pgoff wrap in stack expansion") fixed
the case of an expanding mapping causing vm_pgoff wrapping when you had
downward stack expansion.  But there was another case where IA64 and
PA-RISC expand mappings: upward expansion.

This fixes that case too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1677,9 +1677,12 @@ int expand_upwards(struct vm_area_struct
 		size = address - vma->vm_start;
 		grow = (address - vma->vm_end) >> PAGE_SHIFT;
 
-		error = acct_stack_growth(vma, size, grow);
-		if (!error)
-			vma->vm_end = address;
+		error = -ENOMEM;
+		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error)
+				vma->vm_end = address;
+		}
 	}
 	anon_vma_unlock(vma);
 	return error;


