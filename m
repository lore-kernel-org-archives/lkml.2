Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab1KKMx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:53:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63031 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1KKMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:53:24 -0500
MIME-Version: 1.0
Date: Fri, 11 Nov 2011 20:53:23 +0800
Message-ID: <CAJd=RBAhHS4txg-2tnJyER=GeT4X95z6COMzJvRhcwFgXu6oOA@mail.gmail.com>
Subject: [PATCH] mmap: fix loop when adjusting vma
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have more work to do after one vma is removed, we have to reload @end in
case it is clobbered, then try again.

Thanks

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/mmap.c	Fri Nov 11 20:35:46 2011
+++ b/mm/mmap.c	Fri Nov 11 20:41:32 2011
@@ -490,6 +490,7 @@ __vma_unlink(struct mm_struct *mm, struc
 int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
 {
+	unsigned long saved_end = end;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next = vma->vm_next;
 	struct vm_area_struct *importer = NULL;
@@ -634,7 +635,14 @@ again:			remove_next = 1 + (end > next->
 		 */
 		if (remove_next == 2) {
 			next = vma->vm_next;
-			goto again;
+			if (next) {
+				/*
+				 * we have more work, reload @end in case
+				 * it is clobbered.
+				 */
+				end = saved_end;
+				goto again;
+			}
 		}
 	}
