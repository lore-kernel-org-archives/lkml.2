Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0EVKBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:01:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49564 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0EVKBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:01:19 -0400
Date: Sat, 22 May 2010 12:01:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/8] fs/ceph: Use ERR_CAST
Message-ID: <Pine.LNX.4.64.1005221200560.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

In the case of fs/ceph/inode.c, ERR_CAST is not needed, because the type of
the returned value is the same as the type of the enclosing function.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ceph/dir.c    |    2 +-
 fs/ceph/export.c |    2 +-
 fs/ceph/file.c   |    2 +-
 fs/ceph/inode.c  |    2 +-
 fs/ceph/osdmap.c |    2 +-
 fs/ceph/super.c  |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -u -p a/fs/ceph/dir.c b/fs/ceph/dir.c
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -587,7 +587,7 @@ static struct dentry *ceph_lookup(struct
 		CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
 	req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	/* we only need inode linkage */
diff -u -p a/fs/ceph/export.c b/fs/ceph/export.c
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -133,7 +133,7 @@ static struct dentry *__cfh_to_dentry(st
 		req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPHASH,
 					       USE_ANY_MDS);
 		if (IS_ERR(req))
-			return ERR_PTR(PTR_ERR(req));
+			return ERR_CAST(req);
 
 		req->r_ino1 = vino;
 		req->r_ino2.ino = cfh->parent_ino;
diff -u -p a/fs/ceph/file.c b/fs/ceph/file.c
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -230,7 +230,7 @@ struct dentry *ceph_lookup_open(struct i
 	/* do the open */
 	req = prepare_open_request(dir->i_sb, flags, mode);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	if (flags & O_CREAT) {
diff -u -p a/fs/ceph/inode.c b/fs/ceph/inode.c
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -69,7 +69,7 @@ struct inode *ceph_get_snapdir(struct in
 
 	BUG_ON(!S_ISDIR(parent->i_mode));
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return inode;
 	inode->i_mode = parent->i_mode;
 	inode->i_uid = parent->i_uid;
 	inode->i_gid = parent->i_gid;
diff -u -p a/fs/ceph/osdmap.c b/fs/ceph/osdmap.c
--- a/fs/ceph/osdmap.c
+++ b/fs/ceph/osdmap.c
@@ -706,7 +706,7 @@ struct ceph_osdmap *osdmap_apply_increme
 		     len, *p, end);
 		newcrush = crush_decode(*p, min(*p+len, end));
 		if (IS_ERR(newcrush))
-			return ERR_PTR(PTR_ERR(newcrush));
+			return ERR_CAST(newcrush);
 	}
 
 	/* new flags? */
diff -u -p a/fs/ceph/super.c b/fs/ceph/super.c
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -738,7 +738,7 @@ static struct dentry *open_root_dentry(s
 	dout("open_root_inode opening '%s'\n", path);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 	req->r_path1 = kstrdup(path, GFP_NOFS);
 	req->r_ino1.ino = CEPH_INO_ROOT;
 	req->r_ino1.snap = CEPH_NOSNAP;
