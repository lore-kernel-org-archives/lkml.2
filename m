Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2EIFxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38885 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab2EIFxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:13 -0400
Message-Id: <20120509055038.318026845@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>,
        Orion Poplawski <orion@cora.nwra.com>
Subject: [ 061/167] [PATCH] nfsd: dont fail unchecked creates of non-special files
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use &resfh, not resfh]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4proc.c |    8 ++++----
 fs/nfsd/vfs.c      |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -235,17 +235,17 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_o
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
@@ -1458,7 +1458,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		switch (createmode) {
 		case NFS3_CREATE_UNCHECKED:
 			if (! S_ISREG(dchild->d_inode->i_mode))
-				err = nfserr_exist;
+				goto out;
 			else if (truncp) {
 				/* in nfsv4, we need to treat this case a little
 				 * differently.  we don't want to truncate the


