Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2HOTs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:48:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:36292 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab2HOTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:48:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 004/165] vm: fix vm_pgoff wrap in stack expansion
Date: Wed, 15 Aug 2012 15:45:48 -0400
Message-ID: <1345060109-9187-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
[PG: .34 doesn't have perf call via 3af9e859 (in .36); adjust accordingly]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index b42b469..fe9b76a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1784,10 +1784,13 @@ static int expand_downwards(struct vm_area_struct *vma,
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
-- 
1.7.12.rc2

