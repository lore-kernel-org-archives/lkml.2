Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1GHFEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab1GHFEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.479533034@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [069/107] NFSv4.1: allow nfs_fhget to succeed with mounted on fileid
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Adamson <andros@netapp.com>

commit 533eb4611c9eea53072eb6a61d5a6393b6a77ed7 upstream.

Commit 28331a46d88459788c8fca72dbb0415cd7f514c9 "Ensure we request the
ordinary fileid when doing readdirplus"
changed the meaning of NFS_ATTR_FATTR_FILEID which used to be set when
FATTR4_WORD1_MOUNTED_ON_FILED was requested.

Allow nfs_fhget to succeed with only a mounted on fileid when crossing
a mountpoint or a referral.

Ask for the fileid of the absent file system if mounted_on_fileid is not
supported.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/inode.c    |    3 ++-
 fs/nfs/internal.h |   11 +++++++++++
 fs/nfs/nfs4proc.c |   33 +++++++++++++++++++++++----------
 3 files changed, 36 insertions(+), 11 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -256,7 +256,8 @@ nfs_fhget(struct super_block *sb, struct
 
 	nfs_attr_check_mountpoint(sb, fattr);
 
-	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) == 0 && (fattr->valid & NFS_ATTR_FATTR_MOUNTPOINT) == 0)
+	if (((fattr->valid & NFS_ATTR_FATTR_FILEID) == 0) &&
+	    !nfs_attr_use_mounted_on_fileid(fattr))
 		goto out_no_inode;
 	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) == 0)
 		goto out_no_inode;
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -45,6 +45,17 @@ static inline void nfs_attr_check_mountp
 		fattr->valid |= NFS_ATTR_FATTR_MOUNTPOINT;
 }
 
+static inline int nfs_attr_use_mounted_on_fileid(struct nfs_fattr *fattr)
+{
+	if (((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID) == 0) ||
+	    (((fattr->valid & NFS_ATTR_FATTR_MOUNTPOINT) == 0) &&
+	     ((fattr->valid & NFS_ATTR_FATTR_V4_REFERRAL) == 0)))
+		return 0;
+
+	fattr->fileid = fattr->mounted_on_fileid;
+	return 1;
+}
+
 struct nfs_clone_mount {
 	const struct super_block *sb;
 	const struct dentry *dentry;
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2265,12 +2265,14 @@ static int nfs4_proc_get_root(struct nfs
 	return nfs4_map_errors(status);
 }
 
+static void nfs_fixup_referral_attributes(struct nfs_fattr *fattr);
 /*
  * Get locations and (maybe) other attributes of a referral.
  * Note that we'll actually follow the referral later when
  * we detect fsid mismatch in inode revalidation
  */
-static int nfs4_get_referral(struct inode *dir, const struct qstr *name, struct nfs_fattr *fattr, struct nfs_fh *fhandle)
+static int nfs4_get_referral(struct inode *dir, const struct qstr *name,
+			     struct nfs_fattr *fattr, struct nfs_fh *fhandle)
 {
 	int status = -ENOMEM;
 	struct page *page = NULL;
@@ -2288,15 +2290,16 @@ static int nfs4_get_referral(struct inod
 		goto out;
 	/* Make sure server returned a different fsid for the referral */
 	if (nfs_fsid_equal(&NFS_SERVER(dir)->fsid, &locations->fattr.fsid)) {
-		dprintk("%s: server did not return a different fsid for a referral at %s\n", __func__, name->name);
+		dprintk("%s: server did not return a different fsid for"
+			" a referral at %s\n", __func__, name->name);
 		status = -EIO;
 		goto out;
 	}
+	/* Fixup attributes for the nfs_lookup() call to nfs_fhget() */
+	nfs_fixup_referral_attributes(&locations->fattr);
 
+	/* replace the lookup nfs_fattr with the locations nfs_fattr */
 	memcpy(fattr, &locations->fattr, sizeof(struct nfs_fattr));
-	fattr->valid |= NFS_ATTR_FATTR_V4_REFERRAL;
-	if (!fattr->mode)
-		fattr->mode = S_IFDIR;
 	memset(fhandle, 0, sizeof(struct nfs_fh));
 out:
 	if (page)
@@ -4657,11 +4660,15 @@ static size_t nfs4_xattr_list_nfs4_acl(s
 	return len;
 }
 
+/*
+ * nfs_fhget will use either the mounted_on_fileid or the fileid
+ */
 static void nfs_fixup_referral_attributes(struct nfs_fattr *fattr)
 {
-	if (!((fattr->valid & NFS_ATTR_FATTR_FILEID) &&
-		(fattr->valid & NFS_ATTR_FATTR_FSID) &&
-		(fattr->valid & NFS_ATTR_FATTR_V4_REFERRAL)))
+	if (!(((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID) ||
+	       (fattr->valid & NFS_ATTR_FATTR_FILEID)) &&
+	      (fattr->valid & NFS_ATTR_FATTR_FSID) &&
+	      (fattr->valid & NFS_ATTR_FATTR_V4_REFERRAL)))
 		return;
 
 	fattr->valid |= NFS_ATTR_FATTR_TYPE | NFS_ATTR_FATTR_MODE |
@@ -4676,7 +4683,6 @@ int nfs4_proc_fs_locations(struct inode
 	struct nfs_server *server = NFS_SERVER(dir);
 	u32 bitmask[2] = {
 		[0] = FATTR4_WORD0_FSID | FATTR4_WORD0_FS_LOCATIONS,
-		[1] = FATTR4_WORD1_MOUNTED_ON_FILEID,
 	};
 	struct nfs4_fs_locations_arg args = {
 		.dir_fh = NFS_FH(dir),
@@ -4695,11 +4701,18 @@ int nfs4_proc_fs_locations(struct inode
 	int status;
 
 	dprintk("%s: start\n", __func__);
+
+	/* Ask for the fileid of the absent filesystem if mounted_on_fileid
+	 * is not supported */
+	if (NFS_SERVER(dir)->attr_bitmask[1] & FATTR4_WORD1_MOUNTED_ON_FILEID)
+		bitmask[1] |= FATTR4_WORD1_MOUNTED_ON_FILEID;
+	else
+		bitmask[0] |= FATTR4_WORD0_FILEID;
+
 	nfs_fattr_init(&fs_locations->fattr);
 	fs_locations->server = server;
 	fs_locations->nlocations = 0;
 	status = nfs4_call_sync(server->client, server, &msg, &args.seq_args, &res.seq_res, 0);
-	nfs_fixup_referral_attributes(&fs_locations->fattr);
 	dprintk("%s: returned status = %d\n", __func__, status);
 	return status;
 }


