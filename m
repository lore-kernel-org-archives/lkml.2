Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0FJLK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:10:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab0FJLKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:51 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: viro@zeniv.linux.org.uk, neilb@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [14/23] NFSD: Fix initialized but not read warnings
Message-Id: <20100610111050.30FCCB1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes at least one real minor bug: the nfs4 recovery dir sysctl
would not return its status properly.

Also I finished Al's 1e41568d7378d ("Take ima_path_check() in nfsd 
past dentry_open() in nfsd_open()") commit, it moved the IMA
code, but left the old path initializer in there.

The rest is just dead code removed I think, although I was not 
fully sure about the "is_borc" stuff. Some more review
would be still good.

Found by gcc 4.6's new warnings.

Cc: viro@zeniv.linux.org.uk
Cc: neilb@suse.de

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfsd/nfs4state.c |    2 --
 fs/nfsd/nfsctl.c    |    2 ++
 fs/nfsd/nfsproc.c   |    2 --
 fs/nfsd/vfs.c       |   11 +----------
 4 files changed, 3 insertions(+), 14 deletions(-)

Index: linux-2.6.35-rc2-gcc/fs/nfsd/nfs4state.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/nfsd/nfs4state.c
+++ linux-2.6.35-rc2-gcc/fs/nfsd/nfs4state.c
@@ -3346,11 +3346,9 @@ static inline void
 nfs4_set_lock_denied(struct file_lock *fl, struct nfsd4_lock_denied *deny)
 {
 	struct nfs4_stateowner *sop;
-	unsigned int hval;
 
 	if (fl->fl_lmops == &nfsd_posix_mng_ops) {
 		sop = (struct nfs4_stateowner *) fl->fl_owner;
-		hval = lockownerid_hashval(sop->so_id);
 		kref_get(&sop->so_ref);
 		deny->ld_sop = sop;
 		deny->ld_clientid = sop->so_client->cl_clientid;
Index: linux-2.6.35-rc2-gcc/fs/nfsd/nfsctl.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/nfsd/nfsctl.c
+++ linux-2.6.35-rc2-gcc/fs/nfsd/nfsctl.c
@@ -1310,6 +1310,8 @@ static ssize_t __write_recoverydir(struc
 			return -EINVAL;
 
 		status = nfs4_reset_recoverydir(recdir);
+		if (status)
+			return status;
 	}
 
 	return scnprintf(buf, SIMPLE_TRANSACTION_LIMIT, "%s\n",
Index: linux-2.6.35-rc2-gcc/fs/nfsd/nfsproc.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/nfsd/nfsproc.c
+++ linux-2.6.35-rc2-gcc/fs/nfsd/nfsproc.c
@@ -290,7 +290,6 @@ nfsd_proc_create(struct svc_rqst *rqstp,
 	 * gospel of sun micro
 	 */
 	if (type != S_IFREG) {
-		int	is_borc = 0;
 		if (type != S_IFBLK && type != S_IFCHR) {
 			rdev = 0;
 		} else if (type == S_IFCHR && !(attr->ia_valid & ATTR_SIZE)) {
@@ -298,7 +297,6 @@ nfsd_proc_create(struct svc_rqst *rqstp,
 			type = S_IFIFO;
 		} else {
 			/* Okay, char or block special */
-			is_borc = 1;
 			if (!rdev)
 				rdev = wanted;
 		}
Index: linux-2.6.35-rc2-gcc/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/nfsd/vfs.c
+++ linux-2.6.35-rc2-gcc/fs/nfsd/vfs.c
@@ -1632,7 +1632,7 @@ nfsd_link(struct svc_rqst *rqstp, struct
 				char *name, int len, struct svc_fh *tfhp)
 {
 	struct dentry	*ddir, *dnew, *dold;
-	struct inode	*dirp, *dest;
+	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
 
@@ -1660,7 +1660,6 @@ nfsd_link(struct svc_rqst *rqstp, struct
 		goto out_nfserr;
 
 	dold = tfhp->fh_dentry;
-	dest = dold->d_inode;
 
 	host_err = mnt_want_write(tfhp->fh_export->ex_path.mnt);
 	if (host_err) {
@@ -2112,15 +2111,7 @@ nfsd_permission(struct svc_rqst *rqstp,
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
 		err = inode_permission(inode, MAY_EXEC);
-	if (err)
-		goto nfsd_out;
 
-	/* Do integrity (permission) checking now, but defer incrementing
-	 * IMA counts to the actual file open.
-	 */
-	path.mnt = exp->ex_path.mnt;
-	path.dentry = dentry;
-nfsd_out:
 	return err? nfserrno(err) : 0;
 }
 
