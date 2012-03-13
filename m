Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2CMASG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:18:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:46782 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab2CMAR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 023/196] nilfs2: fix data loss in mmap page write for hole blocks
Date: Mon, 12 Mar 2012 20:12:31 -0400
Message-Id: <1331597724-31358-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 34094537943113467faee98fe67c8a3d3f9a0a8b upstream.

>From the result of a function test of mmap, mmap write to shared pages
turned out to be broken for hole blocks.  It doesn't write out filled
blocks and the data will be lost after umount.  This is due to a bug
that the target file is not queued for log writer when filling hole
blocks.

Also, nilfs_page_mkwrite function exits normal code path even after
successfully filled hole blocks due to a change of block_page_mkwrite
function; just after nilfs was merged into the mainline,
block_page_mkwrite() started to return VM_FAULT_LOCKED instead of zero
by the patch "mm: close page_mkwrite races" (commit:
b827e496c893de0c).  The current nilfs_page_mkwrite() is not handling
this value properly.

This corrects nilfs_page_mkwrite() and will resolve the data loss
problem in mmap write.

[This should be applied to every kernel since 2.6.30 but a fix is
 needed for 2.6.37 and prior kernels]

[PG: add sb as 1st arg to nilfs_set_file_dirty() as per 34 codebase]

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nilfs2/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 30292df..584e0b0 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -72,10 +72,9 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	/*
 	 * check to see if the page is mapped already (no holes)
 	 */
-	if (PageMappedToDisk(page)) {
-		unlock_page(page);
+	if (PageMappedToDisk(page))
 		goto mapped;
-	}
+
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
 		int fully_mapped = 1;
@@ -90,7 +89,6 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 		if (fully_mapped) {
 			SetPageMappedToDisk(page);
-			unlock_page(page);
 			goto mapped;
 		}
 	}
@@ -105,16 +103,18 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
-	if (unlikely(ret)) {
+	if (ret != VM_FAULT_LOCKED) {
 		nilfs_transaction_abort(inode->i_sb);
 		return ret;
 	}
+	nilfs_set_file_dirty(NILFS_SB(inode->i_sb), inode,
+		1 << (PAGE_SHIFT - inode->i_blkbits));
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
 	SetPageChecked(page);
 	wait_on_page_writeback(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 }
 
 static const struct vm_operations_struct nilfs_file_vm_ops = {
-- 
1.7.9.3

