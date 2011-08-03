Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1HCXaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:30:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab1HCX3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:29:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:51 2011
Message-Id: <20110803221251.585512951@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Casey Bodley <cbodley@citi.umich.edu>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [075/102] nfsd: dont break lease on CLAIM_DELEGATE_CUR
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Casey Bodley <cbodley@citi.umich.edu>

commit 0c12eaffdf09466f36a9ffe970dda8f4aeb6efc0 upstream.

CLAIM_DELEGATE_CUR is used in response to a broken lease; allowing it
to break the lease and return EAGAIN leaves the client unable to make
progress in returning the delegation

nfs4_get_vfs_file() now takes struct nfsd4_open for access to the
claim type, and calls nfsd_open() with NFSD_MAY_NOT_BREAK_LEASE when
claim type is CLAIM_DELEGATE_CUR

Signed-off-by: Casey Bodley <cbodley@citi.umich.edu>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2556,12 +2556,18 @@ static inline int nfs4_access_to_access(
 	return flags;
 }
 
-static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file
-*fp, struct svc_fh *cur_fh, u32 nfs4_access)
+static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
+		struct svc_fh *cur_fh, struct nfsd4_open *open)
 {
 	__be32 status;
-	int oflag = nfs4_access_to_omode(nfs4_access);
-	int access = nfs4_access_to_access(nfs4_access);
+	int oflag = nfs4_access_to_omode(open->op_share_access);
+	int access = nfs4_access_to_access(open->op_share_access);
+
+	/* CLAIM_DELEGATE_CUR is used in response to a broken lease;
+	 * allowing it to break the lease and return EAGAIN leaves the
+	 * client unable to make progress in returning the delegation */
+	if (open->op_claim_type == NFS4_OPEN_CLAIM_DELEGATE_CUR)
+		access |= NFSD_MAY_NOT_BREAK_LEASE;
 
 	if (!fp->fi_fds[oflag]) {
 		status = nfsd_open(rqstp, cur_fh, S_IFREG, access,
@@ -2586,7 +2592,7 @@ nfs4_new_open(struct svc_rqst *rqstp, st
 	if (stp == NULL)
 		return nfserr_resource;
 
-	status = nfs4_get_vfs_file(rqstp, fp, cur_fh, open->op_share_access);
+	status = nfs4_get_vfs_file(rqstp, fp, cur_fh, open);
 	if (status) {
 		kmem_cache_free(stateid_slab, stp);
 		return status;
@@ -2619,7 +2625,7 @@ nfs4_upgrade_open(struct svc_rqst *rqstp
 
 	new_access = !test_bit(op_share_access, &stp->st_access_bmap);
 	if (new_access) {
-		status = nfs4_get_vfs_file(rqstp, fp, cur_fh, op_share_access);
+		status = nfs4_get_vfs_file(rqstp, fp, cur_fh, open);
 		if (status)
 			return status;
 	}


