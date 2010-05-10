Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab0EJXUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:20:50 -0400
Received: from kroah.org ([198.145.64.141]:51619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab0EJW5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:35 2010
Message-Id: <20100510223535.612359414@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [13/98] reiserfs: fix permissions on .reiserfs_priv
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit cac36f707119b792b2396aed371d6b5cdc194890 upstream.

Commit 677c9b2e393a0cd203bd54e9c18b012b2c73305a ("reiserfs: remove
privroot hiding in lookup") removed the magic from the lookup code to hide
the .reiserfs_priv directory since it was getting loaded at mount-time
instead.  The intent was that the entry would be hidden from the user via
a poisoned d_compare, but this was faulty.

This introduced a security issue where unprivileged users could access and
modify extended attributes or ACLs belonging to other users, including
root.

This patch resolves the issue by properly hiding .reiserfs_priv.  This was
the intent of the xattr poisoning code, but it appears to have never
worked as expected.  This is fixed by using d_revalidate instead of
d_compare.

This patch makes -oexpose_privroot a no-op.  I'm fine leaving it this way.
The effort involved in working out the corner cases wrt permissions and
caching outweigh the benefit of the feature.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Reported-by: Matt McCutchen <matt@mattmccutchen.net>
Tested-by: Matt McCutchen <matt@mattmccutchen.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/dir.c   |    2 --
 fs/reiserfs/xattr.c |   17 ++++-------------
 2 files changed, 4 insertions(+), 15 deletions(-)

--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -45,8 +45,6 @@ static inline bool is_privroot_deh(struc
 				   struct reiserfs_de_head *deh)
 {
 	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
-	if (reiserfs_expose_privroot(dir->d_sb))
-		return 0;
 	return (dir == dir->d_parent && privroot->d_inode &&
 	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
 }
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -952,21 +952,13 @@ int reiserfs_permission(struct inode *in
 	return generic_permission(inode, mask, NULL);
 }
 
-/* This will catch lookups from the fs root to .reiserfs_priv */
-static int
-xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
+static int xattr_hide_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	struct dentry *priv_root = REISERFS_SB(dentry->d_sb)->priv_root;
-	if (container_of(q1, struct dentry, d_name) == priv_root)
-		return -ENOENT;
-	if (q1->len == name->len &&
-		   !memcmp(q1->name, name->name, name->len))
-		return 0;
-	return 1;
+	return -EPERM;
 }
 
 static const struct dentry_operations xattr_lookup_poison_ops = {
-	.d_compare = xattr_lookup_poison,
+	.d_revalidate = xattr_hide_revalidate,
 };
 
 int reiserfs_lookup_privroot(struct super_block *s)
@@ -980,8 +972,7 @@ int reiserfs_lookup_privroot(struct supe
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
-		if (!reiserfs_expose_privroot(s))
-			s->s_root->d_op = &xattr_lookup_poison_ops;
+		dentry->d_op = &xattr_lookup_poison_ops;
 		if (dentry->d_inode)
 			dentry->d_inode->i_flags |= S_PRIVATE;
 	} else


