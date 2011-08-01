Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1HAP3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:29:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1HAP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:29:42 -0400
From: Caspar Zhang <caspar@casparzhang.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Caspar Zhang <caspar@casparzhang.com>, linux-mm <linux-mm@kvack.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/mempolicy.c: fix pgoff in mbind vma merge
Date: Mon,  1 Aug 2011 23:28:55 +0800
Message-Id: <14efb4b829a69f8c13d65de60a4508c0bbb0a5f5.1312212325.git.caspar@casparzhang.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9d8cebd4bcd7c3878462fdfda34bbcdeb4df7ef4 didn't real fix the
mbind vma merge problem due to wrong pgoff value passing to vma_merge(),
which made vma_merge() always return NULL.

Re-tested the patched kernel with the reproducer provided in commit
9d8cebd, got correct result like below:

addr = 0x7ffa5aaa2000
[snip]
7ffa5aaa2000-7ffa5aaa6000 rw-p 00000000 00:00 0
7fffd556f000-7fffd5584000 rw-p 00000000 00:00 0                          [stack]

Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
---
 mm/mempolicy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8b57173..b1f70d6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -636,7 +636,6 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
-	pgoff_t pgoff;
 	unsigned long vmstart;
 	unsigned long vmend;
 
@@ -649,9 +648,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
-		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
+				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+				  new_pol);
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
-- 
1.7.6

