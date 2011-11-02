Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab1KCBhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645Ab1KCBhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.564844340@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [103/107] vm: fix vm_pgoff wrap in stack expansion
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a626ca6a656450e9f4df91d0dda238fff23285f4 upstream.

Commit 982134ba6261 ("mm: avoid wrapping vm_pgoff in mremap()") fixed
the case of a expanding mapping causing vm_pgoff wrapping when you used
mremap.  But there was another case where we expand mappings hiding in
plain sight: the automatic stack expansion.

This fixes that case too.

This one also found by Robert Święcki, using his nasty system call
fuzzer tool.  Good job.

Reported-and-tested-by: Robert Święcki <robert@swiecki.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1680,10 +1680,13 @@ static int expand_downwards(struct vm_ar
 		size = vma->vm_end - address;
 		grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
-		error = acct_stack_growth(vma, size, grow);
-		if (!error) {
-			vma->vm_start = address;
-			vma->vm_pgoff -= grow;
+		error = -ENOMEM;
+		if (grow <= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error) {
+				vma->vm_start = address;
+				vma->vm_pgoff -= grow;
+			}
 		}
 	}
 	anon_vma_unlock(vma);


