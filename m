Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab1DNSKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:10:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:42102 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700Ab1DNR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Neil Brown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 163/209] nfsd: Fix possible BUG_ON firing in set_change_info
Date: Thu, 14 Apr 2011 13:55:21 -0400
Message-Id: <1302803767-9715-50-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit c1ac3ffcd0bc7e9617f62be8c7043d53ab84deac upstream.

If vfs_getattr in fill_post_wcc returns an error, we don't
set fh_post_change.
For NFSv4, this can result in set_change_info triggering a BUG_ON.
i.e. fh_post_saved being zero isn't really a bug.

So:
 - instead of BUGging when fh_post_saved is zero, just clear ->atomic.
 - if vfs_getattr fails in fill_post_wcc, take a copy of i_ctime anyway.
   This will be used i seg_change_info, but not overly trusted.
 - While we are there, remove the pointless 'if' statements in set_change_info.
   There is no harm setting all the values.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/nfs3xdr.c |    6 ++++--
 fs/nfsd/xdr4.h    |   21 ++++++++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2a533a0..7e84a85 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -260,9 +260,11 @@ void fill_post_wcc(struct svc_fh *fhp)
 	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
 			&fhp->fh_post_attr);
 	fhp->fh_post_change = fhp->fh_dentry->d_inode->i_version;
-	if (err)
+	if (err) {
 		fhp->fh_post_saved = 0;
-	else
+		/* Grab the ctime anyway - set_change_info might use it */
+		fhp->fh_post_attr.ctime = fhp->fh_dentry->d_inode->i_ctime;
+	} else
 		fhp->fh_post_saved = 1;
 }
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index efa3377..c1aed78 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -479,18 +479,17 @@ static inline bool nfsd4_not_cached(struct nfsd4_compoundres *resp)
 static inline void
 set_change_info(struct nfsd4_change_info *cinfo, struct svc_fh *fhp)
 {
-	BUG_ON(!fhp->fh_pre_saved || !fhp->fh_post_saved);
-	cinfo->atomic = 1;
+	BUG_ON(!fhp->fh_pre_saved);
+	cinfo->atomic = fhp->fh_post_saved;
 	cinfo->change_supported = IS_I_VERSION(fhp->fh_dentry->d_inode);
-	if (cinfo->change_supported) {
-		cinfo->before_change = fhp->fh_pre_change;
-		cinfo->after_change = fhp->fh_post_change;
-	} else {
-		cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
-		cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
-		cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;
-		cinfo->after_ctime_nsec = fhp->fh_post_attr.ctime.tv_nsec;
-	}
+
+	cinfo->before_change = fhp->fh_pre_change;
+	cinfo->after_change = fhp->fh_post_change;
+	cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
+	cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
+	cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;
+	cinfo->after_ctime_nsec = fhp->fh_post_attr.ctime.tv_nsec;
+
 }
 
 int nfs4svc_encode_voidres(struct svc_rqst *, __be32 *, void *);
-- 
1.7.4.4

