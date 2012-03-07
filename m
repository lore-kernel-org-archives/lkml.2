Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2CGVXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab2CGVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:14 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 11/25] nfs: don't use intents for checking atomic open
Date: Wed,  7 Mar 2012 22:22:28 +0100
Message-Id: <1331155362-11132-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

is_atomic_open() is now only used by nfs4_lookup_revalidate() to check whether
it's okay to skip normal revalidation.

It does a racy check for mount read-onlyness and falls back to normal
revalidation if the open would fail.  This makes little sense now that this
function isn't used for determining whether to actually open the file or not.

The d_mountpoint() check still makes sense since it is an indication that we
might be following a mount and so open may not revalidate the dentry.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index cd35abb..36a12b4 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1343,24 +1343,6 @@ const struct dentry_operations nfs4_dentry_operations = {
 	.d_release	= nfs_d_release,
 };
 
-/*
- * Use intent information to determine whether we need to substitute
- * the NFSv4-style stateful OPEN for the LOOKUP call
- */
-static int is_atomic_open(struct nameidata *nd)
-{
-	if (nd == NULL || nfs_lookup_check_intent(nd, LOOKUP_OPEN) == 0)
-		return 0;
-	/* NFS does not (yet) have a stateful open for directories */
-	if (nd->flags & LOOKUP_DIRECTORY)
-		return 0;
-	/* Are we trying to write to a read only partition? */
-	if (__mnt_is_readonly(nd->path.mnt) &&
-	    (nd->intent.open.flags & (O_CREAT|O_TRUNC|O_ACCMODE)))
-		return 0;
-	return 1;
-}
-
 static fmode_t flags_to_mode(int flags)
 {
 	fmode_t res = (__force fmode_t)flags & FMODE_EXEC;
@@ -1507,10 +1489,12 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (nd->flags & LOOKUP_RCU)
 		return -ECHILD;
 
-	inode = dentry->d_inode;
-	if (!is_atomic_open(nd) || d_mountpoint(dentry))
+	if (!(nd->flags & LOOKUP_OPEN) || (nd->flags & LOOKUP_DIRECTORY))
+		goto no_open;
+	if (d_mountpoint(dentry))
 		goto no_open;
 
+	inode = dentry->d_inode;
 	parent = dget_parent(dentry);
 	dir = parent->d_inode;
 
-- 
1.7.7

