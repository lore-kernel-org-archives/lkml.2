Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0FHRuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:50:15 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:51152 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0FHRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:50:13 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 10/10] NFSD: Server implementation of MAC Labeling
Date: Tue,  8 Jun 2010 12:22:56 -0400
Message-Id: <1276014176-20315-11-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to encode and decode file labels on the server for
the purpose of sending them to the client and also to process label change
requests from the client.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfsd/export.c   |    3 +
 fs/nfsd/nfs4proc.c |   33 ++++++++++++++++
 fs/nfsd/nfs4xdr.c  |  109 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/nfsd/vfs.c      |   30 ++++++++++++++
 fs/nfsd/vfs.h      |    2 +
 5 files changed, 171 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 872a5ef..39cd1f7 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1422,6 +1422,9 @@ static struct flags {
 	{ NFSEXP_ALLSQUASH, {"all_squash", ""}},
 	{ NFSEXP_ASYNC, {"async", "sync"}},
 	{ NFSEXP_GATHERED_WRITES, {"wdelay", "no_wdelay"}},
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	{ NFSEXP_SECURITY_LABEL, {"security_label", ""}},
+#endif
 	{ NFSEXP_NOHIDE, {"nohide", ""}},
 	{ NFSEXP_CROSSMOUNT, {"crossmnt", ""}},
 	{ NFSEXP_NOSUBTREECHECK, {"no_subtree_check", ""}},
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2ab9e85..8ce1704 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -39,6 +39,10 @@
 #include "xdr4.h"
 #include "vfs.h"
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
 static u32 nfsd_attrmask[] = {
@@ -204,6 +208,18 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_o
 					(u32 *)open->op_verf.data,
 					&open->op_truncate, &created);
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (!status && open->op_label != NULL) {
+			struct inode *inode = resfh.fh_dentry->d_inode;
+
+			mutex_lock(&inode->i_mutex);
+			/* Is it appropriate to just kick back an error? */
+			status = security_inode_setsecctx(resfh.fh_dentry,
+					open->op_label->label, open->op_label->len);
+			mutex_unlock(&inode->i_mutex);
+		}
+#endif
+
 		/*
 		 * Following rfc 3530 14.2.16, use the returned bitmask
 		 * to indicate which attributes we used to store the
@@ -553,6 +569,18 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfserr_badtype;
 	}
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (!status && create->cr_label != NULL) {
+		struct inode *inode = resfh.fh_dentry->d_inode;
+
+		mutex_lock(&inode->i_mutex);
+		/* Is it appropriate to just kick back an error? */
+		status = security_inode_setsecctx(resfh.fh_dentry,
+				create->cr_label->label, create->cr_label->len);
+		mutex_unlock(&inode->i_mutex);
+	}
+#endif
+
 	if (status)
 		goto out;
 
@@ -803,6 +831,11 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 					    setattr->sa_acl);
 	if (status)
 		goto out;
+	if (setattr->sa_label != NULL)
+		status = nfsd4_set_nfs4_label(rqstp, &cstate->current_fh,
+					    setattr->sa_label);
+	if (status)
+		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &setattr->sa_iattr,
 				0, (time_t)0);
 out:
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 34ccf81..acb7d90 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -51,6 +51,10 @@
 #include "xdr4.h"
 #include "vfs.h"
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
 /*
@@ -239,7 +243,8 @@ nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 
 static __be32
 nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
-		   struct iattr *iattr, struct nfs4_acl **acl)
+		   struct iattr *iattr, struct nfs4_acl **acl,
+		   struct nfs4_label **label)
 {
 	int expected_len, len = 0;
 	u32 dummy32;
@@ -383,6 +388,39 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			goto xdr_error;
 		}
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval[1] & FATTR4_WORD1_SECURITY_LABEL) {
+		READ_BUF(4);
+		len += 4;
+		READ32(dummy32);
+		READ_BUF(dummy32);
+		len += (XDR_QUADLEN(dummy32) << 2);
+		READMEM(buf, dummy32);
+
+		if (dummy32 > NFS4_MAXLABELLEN)
+			return nfserr_resource;
+
+		*label = kzalloc(sizeof(struct nfs4_label), GFP_KERNEL);
+		if (*label == NULL) {
+			host_err = -ENOMEM;
+			goto out_nfserr;
+		}
+
+		(*label)->label = kmalloc(dummy32 + 1, GFP_KERNEL);
+		if ((*label)->label == NULL) {
+			host_err = -ENOMEM;
+			kfree(*label);
+			goto out_nfserr;
+		}
+
+		(*label)->len = dummy32;
+		memcpy((*label)->label, buf, dummy32);
+		((char *)(*label)->label)[dummy32] = '\0';
+
+		defer_free(argp, kfree, (*label)->label);
+		defer_free(argp, kfree, *label);
+	}
+#endif
 	if (bmval[0] & ~NFSD_WRITEABLE_ATTRS_WORD0
 	    || bmval[1] & ~NFSD_WRITEABLE_ATTRS_WORD1
 	    || bmval[2] & ~NFSD_WRITEABLE_ATTRS_WORD2)
@@ -481,7 +519,7 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create
 		return status;
 
 	status = nfsd4_decode_fattr(argp, create->cr_bmval, &create->cr_iattr,
-				    &create->cr_acl);
+				    &create->cr_acl, &create->cr_label);
 	if (status)
 		goto out;
 
@@ -644,7 +682,8 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 		case NFS4_CREATE_UNCHECKED:
 		case NFS4_CREATE_GUARDED:
 			status = nfsd4_decode_fattr(argp, open->op_bmval,
-				&open->op_iattr, &open->op_acl);
+				&open->op_iattr, &open->op_acl,
+				&open->op_label);
 			if (status)
 				goto out;
 			break;
@@ -658,7 +697,7 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 			READ_BUF(8);
 			COPYMEM(open->op_verf.data, 8);
 			status = nfsd4_decode_fattr(argp, open->op_bmval,
-				&open->op_iattr, &open->op_acl);
+				&open->op_iattr, &open->op_acl, &open->op_label);
 			if (status)
 				goto out;
 			break;
@@ -855,7 +894,7 @@ nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *seta
 	if (status)
 		return status;
 	return nfsd4_decode_fattr(argp, setattr->sa_bmval, &setattr->sa_iattr,
-				  &setattr->sa_acl);
+				  &setattr->sa_acl, &setattr->sa_label);
 }
 
 static __be32
@@ -918,7 +957,7 @@ nfsd4_decode_verify(struct nfsd4_compoundargs *argp, struct nfsd4_verify *verify
 	 * nfsd4_proc_verify; however we still decode here just to return
 	 * correct error in case of bad xdr. */
 #if 0
-	status = nfsd4_decode_fattr(ve_bmval, &ve_iattr, &ve_acl);
+	status = nfsd4_decode_fattr(ve_bmval, &ve_iattr, &ve_acl, &ve_label);
 	if (status == nfserr_inval) {
 		status = nfserrno(status);
 		goto out;
@@ -1696,6 +1735,34 @@ nfsd4_encode_aclname(struct svc_rqst *rqstp, int whotype, uid_t id, int group,
 	return nfsd4_encode_name(rqstp, whotype, id, group, p, buflen);
 }
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+static inline __be32
+nfsd4_encode_security_label(struct svc_rqst *rqstp, struct dentry *dentry, __be32 **p, int *buflen)
+{
+	void *context;
+	int err;
+	int len;
+
+	err = 0;
+	(void)security_inode_getsecctx(dentry->d_inode, &context, &len);
+	if (len < 0)
+		return nfserrno(len);
+
+	if (*buflen < ((XDR_QUADLEN(len) << 2) + 4)) {
+		err = nfserr_resource;
+		goto out;
+	}
+
+	*p = xdr_encode_opaque(*p, context, len);
+	*buflen -= (XDR_QUADLEN(len) << 2) + 4;
+	BUG_ON(*buflen < 0);
+
+out:
+	security_release_secctx(context, len);
+	return err;
+}
+#endif
+
 #define WORD0_ABSENT_FS_ATTRS (FATTR4_WORD0_FS_LOCATIONS | FATTR4_WORD0_FSID | \
 			      FATTR4_WORD0_RDATTR_ERROR)
 #define WORD1_ABSENT_FS_ATTRS FATTR4_WORD1_MOUNTED_ON_FILEID
@@ -1791,6 +1858,18 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 				goto out_nfserr;
 		}
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		/* XXX: This is not a good way to handle this. We need
+		 * a better way to determine if the system has labeling support
+		 * turned on here.
+		 */
+		if (/* XXX !selinux_enabled */ 0)
+			bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+	}
+#else
+	bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif
 	if ((buflen -= 16) < 0)
 		goto out_resource;
 
@@ -1818,6 +1897,14 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 			goto out_resource;
 		if (!aclsupport)
 			word0 &= ~FATTR4_WORD0_ACL;
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (exp->ex_flags & NFSEXP_SECURITY_LABEL)
+			word1 |= FATTR4_WORD1_SECURITY_LABEL;
+		else
+			word1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#else
+		word1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif
 		if (!word2) {
 			WRITE32(2);
 			WRITE32(word0);
@@ -2136,6 +2223,16 @@ out_acl:
 		}
 		WRITE64(stat.ino);
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		status = nfsd4_encode_security_label(rqstp, dentry,
+				&p, &buflen);
+		if (status == nfserr_resource)
+			goto out_resource;
+		if (status)
+			goto out;
+	}
+#endif
 	if (bmval2 & FATTR4_WORD2_SUPPATTR_EXCLCREAT) {
 		WRITE32(3);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD0);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6dd5f19..f08ed68 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
+#include <linux/security.h>
 
 #ifdef CONFIG_NFSD_V3
 #include "xdr3.h"
@@ -605,6 +606,35 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_ac
 	return error;
 }
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+__be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
+    struct nfs4_label *label)
+{
+	__be32 error;
+	int host_error;
+	struct dentry *dentry;
+
+	/* Get inode */
+	/* XXX: should we have a MAY_SSECCTX? */
+	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
+	if (error)
+		return error;
+
+	dentry = fhp->fh_dentry;
+
+	mutex_lock(&dentry->d_inode->i_mutex);
+	host_error = security_inode_setsecctx(dentry, label->label, label->len);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	return nfserrno(host_error);
+}
+#else
+__be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
+    struct nfs4_label *label)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* defined(CONFIG_NFS_V4) */
 
 #ifdef CONFIG_NFSD_V3
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 4b1de0a..a20814f 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -47,6 +47,8 @@ int nfsd_mountpoint(struct dentry *, struct svc_export *);
 __be32          nfsd4_set_nfs4_acl(struct svc_rqst *, struct svc_fh *,
                     struct nfs4_acl *);
 int             nfsd4_get_nfs4_acl(struct svc_rqst *, struct dentry *, struct nfs4_acl **);
+__be32          nfsd4_set_nfs4_label(struct svc_rqst *, struct svc_fh *,
+		    struct nfs4_label *);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
-- 
1.6.2.5

