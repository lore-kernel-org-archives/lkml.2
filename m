Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab1KJE6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:58:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935182Ab1KJDaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.705046197@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Darrick J. Wong" <djwong@us.ibm.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [160/262] ext4: call ext4_handle_dirty_metadata with correct inode in ext4_dx_add_entry
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 5930ea643805feb50a2f8383ae12eb6f10935e49 upstream.

ext4_dx_add_entry manipulates bh2 and frames[0].bh, which are two buffer_heads
that point to directory blocks assigned to the directory inode.  However, the
function calls ext4_handle_dirty_metadata with the inode of the file that's
being added to the directory, not the directory inode itself.  Therefore,
correct the code to dirty the directory buffers with the directory inode, not
the file inode.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1589,7 +1589,7 @@ static int ext4_dx_add_entry(handle_t *h
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_handle_dirty_metadata(handle, inode, bh2);
+			err = ext4_handle_dirty_metadata(handle, dir, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1615,7 +1615,7 @@ static int ext4_dx_add_entry(handle_t *h
 			if (err)
 				goto journal_error;
 		}
-		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
+		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
 			goto cleanup;


