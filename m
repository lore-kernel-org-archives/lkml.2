Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0DGXSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:18:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0DGXSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:18:51 -0400
Message-ID: <4BBD12DA.30209@suse.com>
Date: Wed, 07 Apr 2010 19:18:50 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-2.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] reiserfs: Fix permissions on .reiserfs_priv
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

 Commit 677c9b2e393a0cd203bd54e9c18b012b2c73305a removed the magic
 from the lookup code to hide the .reiserfs_priv directory since it
 was getting loaded at mount-time instead. The intent was that the
 entry would be hidden from the user via a poisoned d_compare, but
 this was faulty.

 This introduced a security issue where unpriviledged users could
 access and modify extended attributes or ACLs belonging to other
 users, including root.

 This patch resolves the issue by properly hiding .reiserfs_priv. This
 was the intent of the xattr poisoning code, but it appears to have
 never worked as expected. This is fixed by using d_revalidate instead
 of d_compare.

 This patch makes -oexpose_privroot a no-op. I'm fine leaving it this
 way. The effort involved in working out the corner cases wrt permissions
 and caching outweigh the benefit of the feature.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
- ---

 fs/reiserfs/dir.c   |    2 --
 fs/reiserfs/xattr.c |   17 ++++-------------
 2 files changed, 4 insertions(+), 15 deletions(-)

- --- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -45,8 +45,6 @@ static inline bool is_privroot_deh(struc
 				   struct reiserfs_de_head *deh)
 {
 	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
- -	if (reiserfs_expose_privroot(dir->d_sb))
- -		return 0;
 	return (dir == dir->d_parent && privroot->d_inode &&
 	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
 }
- --- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -972,21 +972,13 @@ int reiserfs_permission(struct inode *in
 	return generic_permission(inode, mask, NULL);
 }
 
- -/* This will catch lookups from the fs root to .reiserfs_priv */
- -static int
- -xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
+static int xattr_hide_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
- -	struct dentry *priv_root = REISERFS_SB(dentry->d_sb)->priv_root;
- -	if (container_of(q1, struct dentry, d_name) == priv_root)
- -		return -ENOENT;
- -	if (q1->len == name->len &&
- -		   !memcmp(q1->name, name->name, name->len))
- -		return 0;
- -	return 1;
+	return -EPERM;
 }
 
 static const struct dentry_operations xattr_lookup_poison_ops = {
- -	.d_compare = xattr_lookup_poison,
+	.d_revalidate = xattr_hide_revalidate,
 };
 
 int reiserfs_lookup_privroot(struct super_block *s)
@@ -1000,8 +992,7 @@ int reiserfs_lookup_privroot(struct supe
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
- -		if (!reiserfs_expose_privroot(s))
- -			s->s_root->d_op = &xattr_lookup_poison_ops;
+		dentry->d_op = &xattr_lookup_poison_ops;
 		if (dentry->d_inode)
 			dentry->d_inode->i_flags |= S_PRIVATE;
 	} else
- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAku9EtoACgkQLPWxlyuTD7LxOACdHf0maAVkCXKqrsMk6XP5dNT8
XPIAoIUB9xlvRigutaWf1XBre/mzyBAk
=G+Lo
-----END PGP SIGNATURE-----
