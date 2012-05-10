Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab2EJRjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:39:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49544 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760619Ab2EJRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:37:04 -0400
Message-Id: <20120510173137.245210711@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Orion Poplawski <orion@cora.nwra.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 50/52] nfsd: dont fail unchecked creates of non-special files
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 9dc4e6c4d1182d34604ea40fef641775f5b15456 upstream.

Allow a v3 unchecked open of a non-regular file succeed as if it were a
lookup; typically a client in such a case will want to fall back on a
local open, so succeeding and giving it the filehandle is more useful
than failing with nfserr_exist, which makes it appear that nothing at
all exists by that name.

Similarly for v4, on an open-create, return the same errors we would on
an attempt to open a non-regular file, instead of returning
nfserr_exist.

This fixes a problem found doing a v4 open of a symlink with
O_RDONLY|O_CREAT, which resulted in the current client returning EEXIST.

Thanks also to Trond for analysis.

Reported-by: Orion Poplawski <orion@cora.nwra.com>
Tested-by: Orion Poplawski <orion@cora.nwra.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2 and 3.3: use &resfh, not resfh]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    8 ++++----
 fs/nfsd/vfs.c      |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -231,17 +231,17 @@ do_open_lookup(struct svc_rqst *rqstp, s
 		 */
 		if (open->op_createmode == NFS4_CREATE_EXCLUSIVE && status == 0)
 			open->op_bmval[1] = (FATTR4_WORD1_TIME_ACCESS |
-						FATTR4_WORD1_TIME_MODIFY);
+							FATTR4_WORD1_TIME_MODIFY);
 	} else {
 		status = nfsd_lookup(rqstp, current_fh,
 				     open->op_fname.data, open->op_fname.len, &resfh);
 		fh_unlock(current_fh);
-		if (status)
-			goto out;
-		status = nfsd_check_obj_isreg(&resfh);
 	}
 	if (status)
 		goto out;
+	status = nfsd_check_obj_isreg(&resfh);
+	if (status)
+		goto out;
 
 	if (is_create_with_attrs(open) && open->op_acl != NULL)
 		do_set_nfs4_acl(rqstp, &resfh, open->op_acl, open->op_bmval);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1450,7 +1450,7 @@ do_nfsd_create(struct svc_rqst *rqstp, s
 		switch (createmode) {
 		case NFS3_CREATE_UNCHECKED:
 			if (! S_ISREG(dchild->d_inode->i_mode))
-				err = nfserr_exist;
+				goto out;
 			else if (truncp) {
 				/* in nfsv4, we need to treat this case a little
 				 * differently.  we don't want to truncate the


