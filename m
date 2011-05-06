Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1EFA15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:27:57 -0400
Received: from kroah.org ([198.145.64.141]:37668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab1EFA1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:11 2011
Message-Id: <20110506002610.953245622@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Sachin S. Prabhu" <sprabhu@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [38/43] Open with O_CREAT flag set fails to open existing files on non writable directories
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1387,7 +1387,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 	if (!(iap->ia_valid & ATTR_MODE))
 		iap->ia_mode = 0;
-	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
 	if (err)
 		goto out;
 
@@ -1409,6 +1409,13 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
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


