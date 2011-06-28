Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1F1T5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:57:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:57493 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1F1T45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:56:57 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: david@gibson.dropbear.id.au, galak@kernel.crashing.org, wli@holomorphy.com,
        benh@kernel.crashing.org
Subject: [PATCH 1/5] fs/hugetlbfs/inode.c: Fix pgoff alignment checking on 32-bit
Date: Tue, 28 Jun 2011 14:54:44 -0500
Message-Id: <13092909493748-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.3.rc2.29.gc4640f
In-Reply-To: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

This:

vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT)

is incorrect on 32-bit.  It causes us to & the pgoff with
something that looks like this (for a 4m hugepage): 0xfff003ff.
The mask should be flipped and *then* shifted, to give you
0x0000_03fff.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7aafeb8..537a209 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -94,7 +94,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	if (vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT))
+	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
 		return -EINVAL;
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
-- 
1.5.6.5

