Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2L1TSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675Ab2L1TSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:07 -0500
Message-Id: <20121228190355.631059385@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 121/173] nfsd: avoid permission checks on EXCLUSIVE_CREATE replay
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Brown <neilb@suse.de>

commit 7007c90fb9fef593b4aeaeee57e6a6754276c97c upstream.

With NFSv4, if we create a file then open it we explicit avoid checking
the permissions on the file during the open because the fact that we
created it ensures we should be allow to open it (the create and the
open should appear to be a single operation).

However if the reply to an EXCLUSIVE create gets lots and the client
resends the create, the current code will perform the permission check -
because it doesn't realise that it did the open already..

This patch should fix this.

Note that I haven't actually seen this cause a problem.  I was just
looking at the code trying to figure out a different EXCLUSIVE open
related issue, and this looked wrong.

(Fix confirmed with pynfs 4.0 test OPEN4--bfields)

Signed-off-by: NeilBrown <neilb@suse.de>
[bfields: use OWNER_OVERRIDE and update for 4.1]
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Use current_fh as file handle in do_open_lookup()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4proc.c |    8 +++++---
 fs/nfsd/vfs.c      |   10 ++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -193,6 +193,7 @@ static __be32
 do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	struct svc_fh resfh;
+	int accmode;
 	__be32 status;
 
 	fh_init(&resfh, NFS4_FHSIZE);
@@ -252,9 +253,10 @@ do_open_lookup(struct svc_rqst *rqstp, s
 	/* set reply cache */
 	fh_copy_shallow(&open->op_openowner->oo_owner.so_replay.rp_openfh,
 			&resfh.fh_handle);
-	if (!open->op_created)
-		status = do_open_permission(rqstp, current_fh, open,
-					    NFSD_MAY_NOP);
+	accmode = NFSD_MAY_NOP;
+	if (open->op_created)
+		accmode |= NFSD_MAY_OWNER_OVERRIDE;
+	status = do_open_permission(rqstp, current_fh, open, accmode);
 
 out:
 	fh_put(&resfh);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1458,13 +1458,19 @@ do_nfsd_create(struct svc_rqst *rqstp, s
 		case NFS3_CREATE_EXCLUSIVE:
 			if (   dchild->d_inode->i_mtime.tv_sec == v_mtime
 			    && dchild->d_inode->i_atime.tv_sec == v_atime
-			    && dchild->d_inode->i_size  == 0 )
+			    && dchild->d_inode->i_size  == 0 ) {
+				if (created)
+					*created = 1;
 				break;
+			}
 		case NFS4_CREATE_EXCLUSIVE4_1:
 			if (   dchild->d_inode->i_mtime.tv_sec == v_mtime
 			    && dchild->d_inode->i_atime.tv_sec == v_atime
-			    && dchild->d_inode->i_size  == 0 )
+			    && dchild->d_inode->i_size  == 0 ) {
+				if (created)
+					*created = 1;
 				goto set_attr;
+			}
 			 /* fallthru */
 		case NFS3_CREATE_GUARDED:
 			err = nfserr_exist;


