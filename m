Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0G3RTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:13 -0400
Received: from kroah.org ([198.145.64.141]:51777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab0G3RTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:08 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.454213622@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [086/165] ext4: Ensure zeroout blocks have no dirty metadata
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 515f41c33a9d44a964264c9511ad2c869af1fac3 upstream (as of v2.6.33-rc3)

This fixes a bug (found by Curt Wohlgemuth) in which new blocks
returned from an extent created with ext4_ext_zeroout() can have dirty
metadata still associated with them.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3029,6 +3029,14 @@ out:
 	return err;
 }
 
+static void unmap_underlying_metadata_blocks(struct block_device *bdev,
+			sector_t block, int count)
+{
+	int i;
+	for (i = 0; i < count; i++)
+                unmap_underlying_metadata(bdev, block + i);
+}
+
 static int
 ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock, unsigned int max_blocks,
@@ -3104,6 +3112,18 @@ out:
 	} else
 		allocated = ret;
 	set_buffer_new(bh_result);
+	/*
+	 * if we allocated more blocks than requested
+	 * we need to make sure we unmap the extra block
+	 * allocated. The actual needed block will get
+	 * unmapped later when we find the buffer_head marked
+	 * new.
+	 */
+	if (allocated > max_blocks) {
+		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
+					newblock + max_blocks,
+					allocated - max_blocks);
+	}
 map_out:
 	set_buffer_mapped(bh_result);
 out1:


