Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab0G3RcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:32:18 -0400
Received: from kroah.org ([198.145.64.141]:51942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab0G3RTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.417014159@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [108/165] ext4: Issue the discard operation *before* releasing the blocks to be reused
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit b90f687018e6d6c77d981b09203780f7001407e5 upstream (as of v2.6.34-rc6)

Otherwise, we can end up having data corruption because the blocks
could get reused and then discarded!

https://bugzilla.kernel.org/show_bug.cgi?id=15579

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2537,6 +2537,17 @@ static void release_blocks_on_commit(jou
 		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 			 entry->count, entry->group, entry);
 
+		if (test_opt(sb, DISCARD)) {
+			ext4_fsblk_t discard_block;
+
+			discard_block = entry->start_blk +
+				ext4_group_first_block_no(sb, entry->group);
+			trace_ext4_discard_blocks(sb,
+					(unsigned long long)discard_block,
+					entry->count);
+			sb_issue_discard(sb, discard_block, entry->count);
+		}
+
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
 		BUG_ON(err != 0);
@@ -2558,19 +2569,6 @@ static void release_blocks_on_commit(jou
 			page_cache_release(e4b.bd_bitmap_page);
 		}
 		ext4_unlock_group(sb, entry->group);
-		if (test_opt(sb, DISCARD)) {
-			ext4_fsblk_t discard_block;
-			struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-
-			discard_block = (ext4_fsblk_t)entry->group *
-						EXT4_BLOCKS_PER_GROUP(sb)
-					+ entry->start_blk
-					+ le32_to_cpu(es->s_first_data_block);
-			trace_ext4_discard_blocks(sb,
-					(unsigned long long)discard_block,
-					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
-		}
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
 	}


