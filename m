Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab2CMAtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:49:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:48122 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab2CMAXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sachin Prabhu <sprabhu@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 114/196] Open with O_CREAT flag set fails to open existing files on non writable directories
Date: Mon, 12 Mar 2012 20:20:27 -0400
Message-Id: <1331598109-31424-69-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Prabhu <sprabhu@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1574dff8996ab1ed92c09012f8038b5566fce313 upstream.

An open on a NFS4 share using the O_CREAT flag on an existing file for
which we have permissions to open but contained in a directory with no
write permissions will fail with EACCES.

A tcpdump shows that the client had set the open mode to UNCHECKED which
indicates that the file should be created if it doesn't exist and
encountering an existing flag is not an error. Since in this case the
file exists and can be opened by the user, the NFS server is wrong in
attempting to check create permissions on the parent directory.

The patch adds a conditional statement to check for create permissions
only if the file doesn't exist.

Signed-off-by: Sachin S. Prabhu <sprabhu@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/vfs.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 054b50b..7de2873 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1387,7 +1387,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out;
 	if (!(iap->ia_valid & ATTR_MODE))
 		iap->ia_mode = 0;
-	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
 	if (err)
 		goto out;
 
@@ -1409,6 +1409,13 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (IS_ERR(dchild))
 		goto out_nfserr;
 
+	/* If file doesn't exist, check for permissions to create one */
+	if (!dchild->d_inode) {
+		err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+		if (err)
+			goto out;
+	}
+
 	err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
 	if (err)
 		goto out;
-- 
1.7.9.3

