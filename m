Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2HOUN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:13:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62997 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2HOTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 103/165] vm: fix vm_pgoff wrap in upward expansion
Date: Wed, 15 Aug 2012 15:47:27 -0400
Message-ID: <1345060109-9187-104-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 42c36f63ac1366ab0ecc2d5717821362c259f517 upstream.

Commit a626ca6a6564 ("vm: fix vm_pgoff wrap in stack expansion") fixed
the case of an expanding mapping causing vm_pgoff wrapping when you had
downward stack expansion.  But there was another case where IA64 and
PA-RISC expand mappings: upward expansion.

This fixes that case too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[PG: .34 doesn't have perf call via 3af9e859 (in .36); adjust accordingly]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mmap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index fe9b76a..053c540 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1740,9 +1740,12 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
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
-- 
1.7.12.rc2

