Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1BFXqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:17 -0500
Received: from 1wt.eu ([62.212.114.60]:60316 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab1BFXqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:13 -0500
Message-Id: <20110206232253.081431015@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 13/23] nfsd: Fix possible BUG_ON firing in set_change_info
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 fs/nfsd/nfs3xdr.c         |    6 ++++--
 include/linux/nfsd/xdr4.h |   21 ++++++++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

Index: longterm-2.6.27/fs/nfsd/nfs3xdr.c
===================================================================
--- longterm-2.6.27.orig/fs/nfsd/nfs3xdr.c	2011-01-23 10:52:29.000000000 +0100
+++ longterm-2.6.27/fs/nfsd/nfs3xdr.c	2011-01-29 11:59:54.144063900 +0100
@@ -272,9 +272,11 @@
 
 	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
 			&fhp->fh_post_attr);
-	if (err)
+	if (err) {
 		fhp->fh_post_saved = 0;
-	else
+		/* Grab the ctime anyway - set_change_info might use it */
+		fhp->fh_post_attr.ctime = fhp->fh_dentry->d_inode->i_ctime;
+	} else
 		fhp->fh_post_saved = 1;
 }
 
Index: longterm-2.6.27/include/linux/nfsd/xdr4.h
===================================================================
--- longterm-2.6.27.orig/include/linux/nfsd/xdr4.h	2011-01-23 10:52:35.000000000 +0100
+++ longterm-2.6.27/include/linux/nfsd/xdr4.h	2011-01-29 11:58:59.816063878 +0100
@@ -424,8 +424,8 @@
 static inline void
 set_change_info(struct nfsd4_change_info *cinfo, struct svc_fh *fhp)
 {
-	BUG_ON(!fhp->fh_pre_saved || !fhp->fh_post_saved);
-	cinfo->atomic = 1;
+	BUG_ON(!fhp->fh_pre_saved);
+	cinfo->atomic = fhp->fh_post_saved;
 	cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
 	cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
 	cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;


