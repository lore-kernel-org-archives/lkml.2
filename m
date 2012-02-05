Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2BEW0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:16 -0500
Received: from 1wt.eu ([62.212.114.60]:61807 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab2BEW0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:07 -0500
Message-Id: <20120205220949.961545423@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Sachin S. Prabhu" <sprabhu@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 12/91] Open with O_CREAT flag set fails to open existing files on non writable directories
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 8 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/fs/nfsd/vfs.c
===================================================================
--- longterm-2.6.27.orig/fs/nfsd/vfs.c	2012-02-05 22:34:34.659915205 +0100
+++ longterm-2.6.27/fs/nfsd/vfs.c	2012-02-05 22:34:36.622917202 +0100
@@ -1334,7 +1334,7 @@
 		goto out;
 	if (!(iap->ia_valid & ATTR_MODE))
 		iap->ia_mode = 0;
-	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
 	if (err)
 		goto out;
 
@@ -1356,6 +1356,13 @@
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


