Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936018Ab1KJDk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:40:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935989Ab1KJDkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:53 2011
Message-Id: <20111109213153.583418122@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [114/264] nfsd4: stop using nfserr_resource for transitory errors
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 3e77246393c0a433247631a1f0e9ec98d3d78a1c upstream.

The server is returning nfserr_resource for both permanent errors and
for errors (like allocation failures) that might be resolved by retrying
later.  Save nfserr_resource for the former and use delay/jukebox for
the latter.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4proc.c    |    2 +-
 fs/nfsd/nfs4recover.c |    2 +-
 fs/nfsd/nfs4state.c   |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -930,7 +930,7 @@ _nfsd4_verify(struct svc_rqst *rqstp, st
 	count = 4 + (verify->ve_attrlen >> 2);
 	buf = kmalloc(count << 2, GFP_KERNEL);
 	if (!buf)
-		return nfserr_resource;
+		return nfserr_jukebox;
 
 	status = nfsd4_encode_fattr(&cstate->current_fh,
 				    cstate->current_fh.fh_export,
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -88,7 +88,7 @@ nfs4_make_rec_clidname(char *dname, stru
 	struct xdr_netobj cksum;
 	struct hash_desc desc;
 	struct scatterlist sg;
-	__be32 status = nfserr_resource;
+	__be32 status = nfserr_jukebox;
 
 	dprintk("NFSD: nfs4_make_rec_clidname for %.*s\n",
 			clname->len, clname->data);
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1946,7 +1946,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 	 * of 5 bullet points, labeled as CASE0 - CASE4 below.
 	 */
 	unconf = find_unconfirmed_client_by_str(dname, strhashval);
-	status = nfserr_resource;
+	status = nfserr_jukebox;
 	if (!conf) {
 		/*
 		 * RFC 3530 14.2.33 CASE 4:
@@ -2483,7 +2483,7 @@ renew:
 	if (open->op_stateowner == NULL) {
 		sop = alloc_init_open_stateowner(strhashval, clp, open);
 		if (sop == NULL)
-			return nfserr_resource;
+			return nfserr_jukebox;
 		open->op_stateowner = sop;
 	}
 	list_del_init(&sop->so_close_lru);
@@ -2619,7 +2619,7 @@ nfs4_new_open(struct svc_rqst *rqstp, st
 
 	stp = nfs4_alloc_stateid();
 	if (stp == NULL)
-		return nfserr_resource;
+		return nfserr_jukebox;
 
 	status = nfs4_get_vfs_file(rqstp, fp, cur_fh, open);
 	if (status) {
@@ -2850,7 +2850,7 @@ nfsd4_process_open2(struct svc_rqst *rqs
 		status = nfserr_bad_stateid;
 		if (open->op_claim_type == NFS4_OPEN_CLAIM_DELEGATE_CUR)
 			goto out;
-		status = nfserr_resource;
+		status = nfserr_jukebox;
 		fp = alloc_init_file(ino);
 		if (fp == NULL)
 			goto out;
@@ -4035,7 +4035,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		/* XXX: Do we need to check for duplicate stateowners on
 		 * the same file, or should they just be allowed (and
 		 * create new stateids)? */
-		status = nfserr_resource;
+		status = nfserr_jukebox;
 		lock_sop = alloc_init_lock_stateowner(strhashval,
 				open_sop->so_client, open_stp, lock);
 		if (lock_sop == NULL)
@@ -4119,9 +4119,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	case (EDEADLK):
 		status = nfserr_deadlock;
 		break;
-	default:        
+	default:
 		dprintk("NFSD: nfsd4_lock: vfs_lock_file() failed! status %d\n",err);
-		status = nfserr_resource;
+		status = nfserrno(err);
 		break;
 	}
 out:


