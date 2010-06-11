Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab0FKUl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:41:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54590 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab0FKUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O6MvtvQfQT4qnFVSecdtLQx7OkqcuYpu5rPWGizTYZeMEguOQyHnxrOIJapizpcmDP
         t1r6A0BNJYMTqShO7RvqxBlUGx8YUcARGN7hTH07LbsJdWB/abk84Z1WYkwVLyxJZL+5
         MYUYrq2j1IS/QSmM3vp74Oz6pE8AGOF+gvraE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/6]hfs Fix variable set but not used
Date: Fri, 11 Jun 2010 13:41:07 -0700
Message-Id: <1276288869-16815-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im getting these warnings when compiling
(the patch below gets rid of the warning).

  CC [M]  fs/hfsplus/extents.o
fs/hfsplus/extents.c: In function 'hfsplus_get_block':
fs/hfsplus/extents.c:178:6: warning: variable 'shift' set but not used

 CC [M]  fs/hfs/bnode.o
fs/hfs/bnode.c: In function 'hfs_bnode_copy':
fs/hfs/bnode.c:100:20: warning: variable 'tree' set but not used
fs/hfs/bnode.c: In function '__hfs_bnode_create':
fs/hfs/bnode.c:238:22: warning: variable 'sb' set but not used


 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/hfs/bnode.c       |    4 ----
 fs/hfsplus/extents.c |    4 +---
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index cdb41a1..c6e0bd2 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -97,13 +97,11 @@ void hfs_bnode_clear(struct hfs_bnode *node, int off, int len)
 void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 		struct hfs_bnode *src_node, int src, int len)
 {
-	struct hfs_btree *tree;
 	struct page *src_page, *dst_page;
 
 	dprint(DBG_BNODE_MOD, "copybytes: %u,%u,%u\n", dst, src, len);
 	if (!len)
 		return;
-	tree = src_node->tree;
 	src += src_node->page_offset;
 	dst += dst_node->page_offset;
 	src_page = src_node->page[0];
@@ -235,7 +233,6 @@ struct hfs_bnode *hfs_bnode_findhash(struct hfs_btree *tree, u32 cnid)
 
 static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 {
-	struct super_block *sb;
 	struct hfs_bnode *node, *node2;
 	struct address_space *mapping;
 	struct page *page;
@@ -247,7 +244,6 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 		return NULL;
 	}
 
-	sb = tree->inode->i_sb;
 	size = sizeof(struct hfs_bnode) + tree->pages_per_bnode *
 		sizeof(struct page *);
 	node = kzalloc(size, GFP_KERNEL);
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 0022eec..7b5728d 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -175,12 +175,10 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 	struct super_block *sb;
 	int res = -EIO;
 	u32 ablock, dblock, mask;
-	int shift;
-
+	
 	sb = inode->i_sb;
 
 	/* Convert inode block to disk allocation block */
-	shift = HFSPLUS_SB(sb).alloc_blksz_shift - sb->s_blocksize_bits;
 	ablock = iblock >> HFSPLUS_SB(sb).fs_shift;
 
 	if (iblock >= HFSPLUS_I(inode).fs_blocks) {
-- 
1.7.1.rc1.21.gf3bd6

