Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2JJXCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:02:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45320 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab2JJXCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:30 -0400
X-Sasl-enc: /xXLhbrOtwpzW2pBV1zesOI0K4+YWyTh8AJ7vX7/RodL 1349910149
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel Drake <dsd@laptop.org>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 046/122] ext4: ignore last group w/o enough space when resizing instead of BUGing
Date: Thu, 11 Oct 2012 07:53:32 +0900
Message-Id: <20121010225346.416926960@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

commit 03c1c29053f678234dbd51bf3d65f3b7529021de upstream.

If the last group does not have enough space for group tables, ignore
it instead of calling BUG_ON().

Reported-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -200,8 +200,11 @@ static void free_flex_gd(struct ext4_new
  * be a partial of a flex group.
  *
  * @sb: super block of fs to which the groups belongs
+ *
+ * Returns 0 on a successful allocation of the metadata blocks in the
+ * block group.
  */
-static void ext4_alloc_group_tables(struct super_block *sb,
+static int ext4_alloc_group_tables(struct super_block *sb,
 				struct ext4_new_flex_group_data *flex_gd,
 				int flexbg_size)
 {
@@ -226,6 +229,8 @@ static void ext4_alloc_group_tables(stru
 	       (last_group & ~(flexbg_size - 1))));
 next_group:
 	group = group_data[0].group;
+	if (src_group >= group_data[0].group + flex_gd->count)
+		return -ENOSPC;
 	start_blk = ext4_group_first_block_no(sb, src_group);
 	last_blk = start_blk + group_data[src_group - group].blocks_count;
 
@@ -235,7 +240,6 @@ next_group:
 
 	start_blk += overhead;
 
-	BUG_ON(src_group >= group_data[0].group + flex_gd->count);
 	/* We collect contiguous blocks as much as possible. */
 	src_group++;
 	for (; src_group <= last_group; src_group++)
@@ -300,6 +304,7 @@ next_group:
 			       group_data[i].free_blocks_count);
 		}
 	}
+	return 0;
 }
 
 static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
@@ -1729,7 +1734,8 @@ int ext4_resize_fs(struct super_block *s
 	 */
 	while (ext4_setup_next_flex_gd(sb, flex_gd, n_blocks_count,
 					      flexbg_size)) {
-		ext4_alloc_group_tables(sb, flex_gd, flexbg_size);
+		if (ext4_alloc_group_tables(sb, flex_gd, flexbg_size) != 0)
+			break;
 		err = ext4_flex_group_add(sb, resize_inode, flex_gd);
 		if (unlikely(err))
 			break;


