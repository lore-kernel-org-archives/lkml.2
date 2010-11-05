Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0KEDJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:09:09 -0400
Received: from mail.perches.com ([173.55.12.10]:4174 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0KEDJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 39/49] fs/reiserfs: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:03 -0700
Message-Id: <3d1cffb03168ee990700bb6a2943d18f6600d8e6.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/reiserfs/journal.c |    9 +++------
 fs/reiserfs/resize.c  |    4 +---
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 076c8b1..d8a2592 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -292,14 +292,13 @@ int reiserfs_allocate_list_bitmaps(struct super_block *sb,
 	for (i = 0; i < JOURNAL_NUM_BITMAPS; i++) {
 		jb = jb_array + i;
 		jb->journal_list = NULL;
-		jb->bitmaps = vmalloc(mem);
+		jb->bitmaps = vzalloc(mem);
 		if (!jb->bitmaps) {
 			reiserfs_warning(sb, "clm-2000", "unable to "
 					 "allocate bitmaps for journal lists");
 			failed = 1;
 			break;
 		}
-		memset(jb->bitmaps, 0, mem);
 	}
 	if (failed) {
 		free_list_bitmaps(sb, jb_array);
@@ -354,11 +353,10 @@ static struct reiserfs_journal_cnode *allocate_cnodes(int num_cnodes)
 	if (num_cnodes <= 0) {
 		return NULL;
 	}
-	head = vmalloc(num_cnodes * sizeof(struct reiserfs_journal_cnode));
+	head = vzalloc(num_cnodes * sizeof(struct reiserfs_journal_cnode));
 	if (!head) {
 		return NULL;
 	}
-	memset(head, 0, num_cnodes * sizeof(struct reiserfs_journal_cnode));
 	head[0].prev = NULL;
 	head[0].next = head + 1;
 	for (i = 1; i < num_cnodes; i++) {
@@ -2703,14 +2701,13 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	 * dependency inversion warnings.
 	 */
 	reiserfs_write_unlock(sb);
-	journal = SB_JOURNAL(sb) = vmalloc(sizeof(struct reiserfs_journal));
+	journal = SB_JOURNAL(sb) = vzalloc(sizeof(struct reiserfs_journal));
 	if (!journal) {
 		reiserfs_warning(sb, "journal-1256",
 				 "unable to get memory for journal structure");
 		reiserfs_write_lock(sb);
 		return 1;
 	}
-	memset(journal, 0, sizeof(struct reiserfs_journal));
 	INIT_LIST_HEAD(&journal->j_bitmap_nodes);
 	INIT_LIST_HEAD(&journal->j_prealloc_list);
 	INIT_LIST_HEAD(&journal->j_working_list);
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index b3a94d2..cfb5196 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -111,15 +111,13 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 		/* allocate additional bitmap blocks, reallocate array of bitmap
 		 * block pointers */
 		bitmap =
-		    vmalloc(sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
+		    vzalloc(sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
 		if (!bitmap) {
 			/* Journal bitmaps are still supersized, but the memory isn't
 			 * leaked, so I guess it's ok */
 			printk("reiserfs_resize: unable to allocate memory.\n");
 			return -ENOMEM;
 		}
-		memset(bitmap, 0,
-		       sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
 		for (i = 0; i < bmap_nr; i++)
 			bitmap[i] = old_bitmap[i];
 
-- 
1.7.3.1.g432b3.dirty

