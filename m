Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1C1CDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:03:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:31922 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab1C1CDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="902440334"
Subject: [PATCH]mmap: avoid unnecessary anon_vma lock
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 09:58:52 +0800
Message-ID: <1301277532.3981.25.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we only change vma->vm_end, we can avoid taking anon_vma lock even 'insert'
isn't NULL, which is the case of split_vma.
>From my understanding, we need the lock before because rmap must get the
'insert' VMA when we adjust old VMA's vm_end (the 'insert' VMA is linked to
anon_vma list in __insert_vm_struct before).
But now this isn't true any more. The 'insert' VMA is already linked to
anon_vma list in __split_vma(with anon_vma_clone()) instead of
__insert_vm_struct. There is no race rmap can't get required VMAs.
So the anon_vma lock is unnecessary, and this can reduce one locking in brk
case and improve scalability.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>

---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c	2011-03-24 09:08:27.000000000 +0800
+++ linux/mm/mmap.c	2011-03-24 09:14:03.000000000 +0800
@@ -605,7 +605,7 @@ again:			remove_next = 1 + (end > next->
 	 * lock may be shared between many sibling processes.  Skipping
 	 * the lock for brk adjustments makes a difference sometimes.
 	 */
-	if (vma->anon_vma && (insert || importer || start != vma->vm_start)) {
+	if (vma->anon_vma && (importer || start != vma->vm_start)) {
 		anon_vma = vma->anon_vma;
 		anon_vma_lock(anon_vma);
 	}


