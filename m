Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab1KCBhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1KCBhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.650206488@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hugh Dickins <hughd@google.com>
Subject: [104/107] vm: fix vm_pgoff wrap in upward expansion
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1636,9 +1636,12 @@ int expand_upwards(struct vm_area_struct
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


