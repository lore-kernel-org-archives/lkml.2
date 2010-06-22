Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab0FVBWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:22:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34269 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0FVBWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:22:06 -0400
Date: Tue, 22 Jun 2010 11:22:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Eric Van Hensbergen <ericvh@gmail.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20100622112201.08505101.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

After merging the vfs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

fs/9p/vfs_inode.c: In function 'v9fs_vfs_setattr_dotl':
fs/9p/vfs_inode.c:1056: error: implicit declaration of function 'inode_setattr'

Caused by commit 463942d48d7f05812f0d6426dd8051ff53ea24a3 ("9p: Implement
client side of setattr for 9P2000.L protocol") from the v9fs tree
interacting with commit 3d9bf66940b6001a30aa30d5ac9f816326d9b3a0 ("remove
inode_setattr") from the vfs tree.

I have applied the following patch (using the changes in the above vfs
tree commit as a guide) as a merge fix for today, but am not sure if it
is correct.  I assume that this (or something similar) could be applied
to the v9fs tree now - is that correct Christoph?

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 22 Jun 2010 11:15:01 +1000
Subject: [PATCH] v9fs: fixup for inode_setattr being removed

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/9p/vfs_inode.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f027a42..2ec7bfa 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1052,10 +1052,19 @@ static int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 		return PTR_ERR(fid);
 
 	retval = p9_client_setattr(fid, &p9attr);
-	if (retval >= 0)
-		retval = inode_setattr(dentry->d_inode, iattr);
+	if (retval < 0)
+		return retval;
 
-	return retval;
+	if ((iattr->ia_valid & ATTR_SIZE) &&
+	    iattr->ia_size != i_size_read(dentry->d_inode)) {
+		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
+		if (retval)
+			return retval;
+	}
+
+	setattr_copy(dentry->d_inode, iattr);
+	mark_inode_dirty(dentry->d_inode);
+	return 0;
 }
 
 /**
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
