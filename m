Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1AEXMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:12:00 -0500
Received: from kroah.org ([198.145.64.141]:50725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1AEXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:19 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:24 2011
Message-Id: <20110105230324.424407145@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [10/49] nfsd: Fix possible BUG_ON firing in set_change_info
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Brown <neilb@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs3xdr.c         |    6 ++++--
 include/linux/nfsd/xdr4.h |   21 ++++++++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -273,9 +273,11 @@ void fill_post_wcc(struct svc_fh *fhp)
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
 
--- a/include/linux/nfsd/xdr4.h
+++ b/include/linux/nfsd/xdr4.h
@@ -480,18 +480,17 @@ static inline bool nfsd4_not_cached(stru
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


