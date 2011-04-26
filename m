Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab1DZViv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:38:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:61741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550Ab1DZVNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684326786"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: konishi.ryusuke@lab.ntt.co.jp, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [11/106] nilfs2: fix data loss in mmap page write for hole blocks
Message-Id: <20110426211249.564E83E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

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

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/fs/nilfs2/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/nilfs2/file.c
+++ linux-2.6.35.y/fs/nilfs2/file.c
@@ -72,10 +72,9 @@ static int nilfs_page_mkwrite(struct vm_
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
@@ -90,7 +89,6 @@ static int nilfs_page_mkwrite(struct vm_
 
 		if (fully_mapped) {
 			SetPageMappedToDisk(page);
-			unlock_page(page);
 			goto mapped;
 		}
 	}
@@ -105,16 +103,18 @@ static int nilfs_page_mkwrite(struct vm_
 		return VM_FAULT_SIGBUS;
 
 	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
-	if (unlikely(ret)) {
+	if (ret != VM_FAULT_LOCKED) {
 		nilfs_transaction_abort(inode->i_sb);
 		return ret;
 	}
+	nilfs_set_file_dirty(NILFS_SB(inode->i_sb), inode,
+			     1 << (PAGE_SHIFT - inode->i_blkbits));
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
 	SetPageChecked(page);
 	wait_on_page_writeback(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 }
 
 static const struct vm_operations_struct nilfs_file_vm_ops = {
