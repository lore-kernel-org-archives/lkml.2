Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab1DMQMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:12:55 -0400
Received: from kroah.org ([198.145.64.141]:52797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab1DMQMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:44 2011
Message-Id: <20110413161044.683637694@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [21/71] nilfs2: fix data loss in mmap page write for hole blocks
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
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


