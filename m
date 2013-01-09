Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab3AIVTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:19:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:42723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574Ab3AIUj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 42/80] nfsd: avoid permission checks on EXCLUSIVE_CREATE replay
Date: Wed,  9 Jan 2013 12:35:34 -0800
Message-Id: <20130109201505.795752243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    8 +++++---
 fs/nfsd/vfs.c      |   10 ++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -194,6 +194,7 @@ static __be32
 do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	struct svc_fh *resfh;
+	int accmode;
 	__be32 status;
 
 	resfh = kmalloc(sizeof(struct svc_fh), GFP_KERNEL);
@@ -253,9 +254,10 @@ do_open_lookup(struct svc_rqst *rqstp, s
 	/* set reply cache */
 	fh_copy_shallow(&open->op_openowner->oo_owner.so_replay.rp_openfh,
 			&resfh->fh_handle);
-	if (!open->op_created)
-		status = do_open_permission(rqstp, resfh, open,
-					    NFSD_MAY_NOP);
+	accmode = NFSD_MAY_NOP;
+	if (open->op_created)
+		accmode |= NFSD_MAY_OWNER_OVERRIDE;
+	status = do_open_permission(rqstp, resfh, open, accmode);
 	set_change_info(&open->op_cinfo, current_fh);
 	fh_dup2(current_fh, resfh);
 out:
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1477,13 +1477,19 @@ do_nfsd_create(struct svc_rqst *rqstp, s
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


