Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2JJXKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:10:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51849 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932583Ab2JJXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:55 -0400
X-Sasl-enc: cnoFiR9sVkR5Cy9GRe9Ji1OKagQfRlML/LJGshWbitxQ 1349910174
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Subject: [ 055/122] ext4: fix mtime update in nodelalloc mode
Date: Thu, 11 Oct 2012 07:53:41 +0900
Message-Id: <20121010225347.995548089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 041bbb6d369811e948ae01f3d00414264076be35 upstream.

Commits 5e8830dc85d0 and 41c4d25f78c0 introduced a regression into
v3.6-rc1 for ext4 in nodealloc mode, such that mtime updates would not
take place for files modified via mmap if the page was already in the
page cache.  This would also affect ext3 file systems mounted using
the ext4 file system driver.

The problem was that ext4_page_mkwrite() had a shortcut which would
avoid calling __block_page_mkwrite() under some circumstances, and the
above two commit transferred the responsibility of calling
file_update_time() to __block_page_mkwrite --- which woudln't get
called in some circumstances.

Since __block_page_mkwrite() only has three callers,
block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the
best way to solve this is to move the responsibility for calling
file_update_time() to its caller.

This problem was found via xfstests #215 with a file system mounted
with -o nodelalloc.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/buffer.c      |   13 +++++++------
 fs/ext4/inode.c  |    1 +
 fs/nilfs2/file.c |    1 +
 3 files changed, 9 insertions(+), 6 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2312,12 +2312,6 @@ int __block_page_mkwrite(struct vm_area_
 	loff_t size;
 	int ret;
 
-	/*
-	 * Update file times before taking page lock. We may end up failing the
-	 * fault so this update may be superfluous but who really cares...
-	 */
-	file_update_time(vma->vm_file);
-
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
@@ -2355,6 +2349,13 @@ int block_page_mkwrite(struct vm_area_st
 	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
 
 	sb_start_pagefault(sb);
+
+	/*
+	 * Update file times before taking page lock. We may end up failing the
+	 * fault so this update may be superfluous but who really cares...
+	 */
+	file_update_time(vma->vm_file);
+
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	sb_end_pagefault(sb);
 	return block_page_mkwrite_return(ret);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4787,6 +4787,7 @@ int ext4_page_mkwrite(struct vm_area_str
 	int retries = 0;
 
 	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -116,6 +116,7 @@ static int nilfs_page_mkwrite(struct vm_
 	if (unlikely(ret))
 		goto out;
 
+	file_update_time(vma->vm_file);
 	ret = __block_page_mkwrite(vma, vmf, nilfs_get_block);
 	if (ret) {
 		nilfs_transaction_abort(inode->i_sb);


