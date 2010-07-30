Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab0G3Rdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:33:40 -0400
Received: from kroah.org ([198.145.64.141]:51885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218Ab0G3RTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:25 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.762576028@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [101/165] ext4: Fix insertion point of extent in mext_insert_across_blocks()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 5fd5249aa36fad98c9fd5edced352939e54f9324 upstream (as of v2.6.33-git11)

If the leaf node has 2 extent space or fewer and EXT4_IOC_MOVE_EXT
ioctl is called with the file offset where after the 2nd extent
covers, mext_insert_across_blocks() always tries to insert extent into
the first extent.  As a result, the file gets corrupted because of
wrong extent order.  The patch fixes this problem.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -252,6 +252,7 @@ mext_insert_across_blocks(handle_t *hand
 		}
 
 		o_start->ee_len = start_ext->ee_len;
+		eblock = le32_to_cpu(start_ext->ee_block);
 		new_flag = 1;
 
 	} else if (start_ext->ee_len && new_ext->ee_len &&
@@ -262,6 +263,7 @@ mext_insert_across_blocks(handle_t *hand
 		 * orig  |------------------------------|
 		 */
 		o_start->ee_len = start_ext->ee_len;
+		eblock = le32_to_cpu(start_ext->ee_block);
 		new_flag = 1;
 
 	} else if (!start_ext->ee_len && new_ext->ee_len &&
@@ -502,6 +504,7 @@ mext_leaf_block(handle_t *handle, struct
 		le32_to_cpu(oext->ee_block) + oext_alen) {
 		start_ext.ee_len = cpu_to_le16(le32_to_cpu(new_ext.ee_block) -
 					       le32_to_cpu(oext->ee_block));
+		start_ext.ee_block = oext->ee_block;
 		copy_extent_status(oext, &start_ext);
 	} else if (oext > EXT_FIRST_EXTENT(orig_path[depth].p_hdr)) {
 		prev_ext = oext - 1;
@@ -515,6 +518,7 @@ mext_leaf_block(handle_t *handle, struct
 			start_ext.ee_len = cpu_to_le16(
 				ext4_ext_get_actual_len(prev_ext) +
 				new_ext_alen);
+			start_ext.ee_block = oext->ee_block;
 			copy_extent_status(prev_ext, &start_ext);
 			new_ext.ee_len = 0;
 		}


