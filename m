Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab2JKB32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:29:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60353 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934029Ab2JKBY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:24:28 -0400
X-Sasl-enc: kwN0xQr482KS2NUL/AE7dhMwVailMmPLpFWpXcOXmP7O 1349918667
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yongqiang Yang <xiaoqiangnk@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 066/120] ext4: avoid duplicate writes of the backup bg descriptor blocks
Date: Thu, 11 Oct 2012 10:00:18 +0900
Message-Id: <20121011005838.135913092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

commit 2ebd1704ded88a8ae29b5f3998b13959c715c4be upstream.

The resize code was needlessly writing the backup block group
descriptor blocks multiple times (once per block group) during an
online resize.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1302,13 +1302,15 @@ exit_journal:
 		err = err2;
 
 	if (!err) {
-		int i;
+		int gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+		int gdb_num_end = ((group + flex_gd->count - 1) /
+				   EXT4_DESC_PER_BLOCK(sb));
+
 		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
 			       sizeof(struct ext4_super_block));
-		for (i = 0; i < flex_gd->count; i++, group++) {
+		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
-			int gdb_num;
-			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
+
 			gdb_bh = sbi->s_group_desc[gdb_num];
 			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
 				       gdb_bh->b_size);


