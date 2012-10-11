Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab2JKBYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:24:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40049 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933951Ab2JKBYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:24:24 -0400
X-Sasl-enc: XDqcDCggRCHetNyxheBm8h3O8U5Ysp3vXY4dtNZBVFSq 1349918663
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yongqiang Yang <xiaoqiangnk@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 065/120] ext4: dont copy non-existent gdt blocks when resizing
Date: Thu, 11 Oct 2012 10:00:17 +0900
Message-Id: <20121011005837.905501484@linuxfoundation.org>
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

commit 6df935ad2fced9033ab52078825fcaf6365f34b7 upstream.

The resize code was copying blocks at the beginning of each block
group in order to copy the superblock and block group descriptor table
(gdt) blocks.  This was, unfortunately, being done even for block
groups that did not have super blocks or gdt blocks.  This is a
complete waste of perfectly good I/O bandwidth, to skip writing those
blocks for sparse bg's.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -456,6 +456,9 @@ static int setup_new_flex_group_blocks(s
 		gdblocks = ext4_bg_num_gdb(sb, group);
 		start = ext4_group_first_block_no(sb, group);
 
+		if (!ext4_bg_has_super(sb, group))
+			goto handle_itb;
+
 		/* Copy all of the GDT blocks into the backup in this group */
 		for (j = 0, block = start + 1; j < gdblocks; j++, block++) {
 			struct buffer_head *gdb;
@@ -498,6 +501,7 @@ static int setup_new_flex_group_blocks(s
 				goto out;
 		}
 
+handle_itb:
 		/* Initialize group tables of the grop @group */
 		if (!(bg_flags[i] & EXT4_BG_INODE_ZEROED))
 			goto handle_bb;


