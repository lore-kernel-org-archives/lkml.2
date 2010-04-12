Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0DLU2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:28:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366Ab0DLU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:28:00 -0400
Date: Mon, 12 Apr 2010 13:23:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH 2/4] vma_adjust: fix the copying of anon_vma chains
In-Reply-To: <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com>
 <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Apr 2010 15:22:30 -0700
Subject: [PATCH 2/4] vma_adjust: fix the copying of anon_vma chains

When we move the boundaries between two vma's due to things like
mprotect, we need to make sure that the anon_vma of the pages that got
moved from one vma to another gets properly copied around.  And that was
not always the case, in this rather hard-to-follow code sequence.

Clarify the code, and fix it so that it copies the anon_vma from the
right source.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/mmap.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index acb023e..f90ea92 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -507,11 +507,12 @@ int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	struct address_space *mapping = NULL;
 	struct prio_tree_root *root = NULL;
 	struct file *file = vma->vm_file;
-	struct anon_vma *anon_vma = NULL;
 	long adjust_next = 0;
 	int remove_next = 0;
 
 	if (next && !insert) {
+		struct vm_area_struct *exporter = NULL;
+
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
@@ -519,7 +520,7 @@ int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 			 */
 again:			remove_next = 1 + (end > next->vm_end);
 			end = next->vm_end;
-			anon_vma = next->anon_vma;
+			exporter = next;
 			importer = vma;
 		} else if (end > next->vm_start) {
 			/*
@@ -527,7 +528,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 			 * mprotect case 5 shifting the boundary up.
 			 */
 			adjust_next = (end - next->vm_start) >> PAGE_SHIFT;
-			anon_vma = next->anon_vma;
+			exporter = next;
 			importer = vma;
 		} else if (end < vma->vm_end) {
 			/*
@@ -536,28 +537,19 @@ again:			remove_next = 1 + (end > next->vm_end);
 			 * mprotect case 4 shifting the boundary down.
 			 */
 			adjust_next = - ((vma->vm_end - end) >> PAGE_SHIFT);
-			anon_vma = next->anon_vma;
+			exporter = vma;
 			importer = next;
 		}
-	}
 
-	/*
-	 * When changing only vma->vm_end, we don't really need anon_vma lock.
-	 */
-	if (vma->anon_vma && (insert || importer || start != vma->vm_start))
-		anon_vma = vma->anon_vma;
-	if (anon_vma) {
 		/*
 		 * Easily overlooked: when mprotect shifts the boundary,
 		 * make sure the expanding vma has anon_vma set if the
 		 * shrinking vma had, to cover any anon pages imported.
 		 */
-		if (importer && !importer->anon_vma) {
-			/* Block reverse map lookups until things are set up. */
-			if (anon_vma_clone(importer, vma)) {
+		if (exporter && exporter->anon_vma && !importer->anon_vma) {
+			if (anon_vma_clone(importer, exporter))
 				return -ENOMEM;
-			}
-			importer->anon_vma = anon_vma;
+			importer->anon_vma = exporter->anon_vma;
 		}
 	}
 
-- 
1.7.1.rc1.dirty

