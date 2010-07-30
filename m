Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab0G3R16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:27:58 -0400
Received: from kroah.org ([198.145.64.141]:52084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab0G3RTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:11 2010
Message-Id: <20100730171511.136417144@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [127/165] ext4: Avoid crashing on NULL ptr dereference on a filesystem error
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit f70f362b4a6fe47c239dbfb3efc0cc2c10e4f09c upstream (as of v2.6.34-git13)

If the EOFBLOCK_FL flag is set when it should not be and the inode is
zero length, then eh_entries is zero, and ex is NULL, so dereferencing
ex to print ex->ee_block causes a kernel OOPS in
ext4_ext_map_blocks().

On top of that, the error message which is printed isn't very helpful.
So we fix this by printing something more explanatory which doesn't
involve trying to print ex->ee_block.

Addresses-Google-Bug: #2655740

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3281,8 +3281,8 @@ int ext4_ext_get_blocks(handle_t *handle
 	 */
 	if (path[depth].p_ext == NULL && depth != 0) {
 		ext4_error(inode->i_sb, __func__, "bad extent address "
-			   "inode: %lu, iblock: %d, depth: %d",
-			   inode->i_ino, iblock, depth);
+			   "inode: %lu, iblock: %lu, depth: %d",
+			   inode->i_ino, (unsigned long) iblock, depth);
 		err = -EIO;
 		goto out2;
 	}
@@ -3418,8 +3418,11 @@ int ext4_ext_get_blocks(handle_t *handle
 		} else {
 			WARN_ON(eh->eh_entries == 0);
 			ext4_error(inode->i_sb, __func__,
-				"inode#%lu, eh->eh_entries = 0!", inode->i_ino);
-			}
+				   "inode#%lu, eh->eh_entries = 0 and "
+				   "EOFBLOCKS_FL set", inode->i_ino);
+			err = -EIO;
+			goto out2;
+		}
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {


