Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab0HKX7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:46 -0400
Received: from kroah.org ([198.145.64.141]:43711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310Ab0HKX7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:25 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:04 2010
Message-Id: <20100811235504.727607946@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>
Subject: [099/111] reiserfs: fix oops while creating privroot with selinux enabled
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 6cb4aff0a77cc0e6bae9475d62205319e3ebbf3f upstream.

Commit 57fe60df ("reiserfs: add atomic addition of selinux attributes
during inode creation") contains a bug that will cause it to oops when
mounting a file system that didn't previously contain extended attributes
on a system using security.* xattrs.

The issue is that while creating the privroot during mount
reiserfs_security_init calls reiserfs_xattr_jcreate_nblocks which
dereferences the xattr root.  The xattr root doesn't exist, so we get an
oops.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15309

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/xattr_security.c   |    2 +-
 include/linux/reiserfs_xattr.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -75,7 +75,7 @@ int reiserfs_security_init(struct inode
 		return error;
 	}
 
-	if (sec->length) {
+	if (sec->length && reiserfs_xattrs_initialized(inode->i_sb)) {
 		blocks = reiserfs_xattr_jcreate_nblocks(inode) +
 			 reiserfs_xattr_nblocks(inode, sec->length);
 		/* We don't want to count the directories twice if we have
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -70,6 +70,11 @@ int reiserfs_security_write(struct reise
 void reiserfs_security_free(struct reiserfs_security_handle *sec);
 #endif
 
+static inline int reiserfs_xattrs_initialized(struct super_block *sb)
+{
+	return REISERFS_SB(sb)->priv_root != NULL;
+}
+
 #define xattr_size(size) ((size) + sizeof(struct reiserfs_xattr_header))
 static inline loff_t reiserfs_xattr_nblocks(struct inode *inode, loff_t size)
 {


