Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab0G3Rcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:32:42 -0400
Received: from kroah.org ([198.145.64.141]:51935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726Ab0G3RTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:31 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.302587758@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [107/165] ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit fd2dd9fbaf9e498ec63eef298921e36556f7214c upstream (as of v2.6.34-rc6)

Calls to ext4_get_inode_loc() returns with a reference to a buffer
head in iloc->bh.  The callers of this function in ext4_write_inode()
when in no journal mode and in ext4_xattr_fiemap() don't release the
buffer head after using it.

Addresses-Google-Bug: #2548165

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3778,6 +3778,7 @@ static int ext4_xattr_fiemap(struct inod
 		physical += offset;
 		length = EXT4_SB(inode->i_sb)->s_inode_size - offset;
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
+		brelse(iloc.bh);
 	} else { /* external block */
 		physical = EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5273,6 +5273,7 @@ int ext4_write_inode(struct inode *inode
 				   (unsigned long long)iloc.bh->b_blocknr);
 			err = -EIO;
 		}
+		brelse(iloc.bh);
 	}
 	return err;
 }


