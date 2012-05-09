Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab2EIGad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:30:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38732 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190Ab2EIFwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:51 -0400
Message-Id: <20120509055036.653452389@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 050/167] [PATCH] nfsd: fix error values returned by nfsd4_lockt() when
 nfsd_open() fails
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 04da6e9d63427b2d0fd04766712200c250b3278f upstream.

nfsd_open() already returns an NFS error value; only vfs_test_lock()
result needs to be fed through nfserrno().  Broken by commit 55ef12
(nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT)
three years ago...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1841f8b..7f71c69 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4211,16 +4211,14 @@ out:
  * vfs_test_lock.  (Arguably perhaps test_lock should be done with an
  * inode operation.)
  */
-static int nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
+static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
 {
 	struct file *file;
-	int err;
-
-	err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_READ, &file);
-	if (err)
-		return err;
-	err = vfs_test_lock(file, lock);
-	nfsd_close(file);
+	__be32 err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_READ, &file);
+	if (!err) {
+		err = nfserrno(vfs_test_lock(file, lock));
+		nfsd_close(file);
+	}
 	return err;
 }
 
@@ -4234,7 +4232,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct inode *inode;
 	struct file_lock file_lock;
 	struct nfs4_lockowner *lo;
-	int error;
 	__be32 status;
 
 	if (locks_in_grace())
@@ -4280,12 +4277,10 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	nfs4_transform_lock_offset(&file_lock);
 
-	status = nfs_ok;
-	error = nfsd_test_lock(rqstp, &cstate->current_fh, &file_lock);
-	if (error) {
-		status = nfserrno(error);
+	status = nfsd_test_lock(rqstp, &cstate->current_fh, &file_lock);
+	if (status)
 		goto out;
-	}
+
 	if (file_lock.fl_type != F_UNLCK) {
 		status = nfserr_denied;
 		nfs4_set_lock_denied(&file_lock, &lockt->lt_denied);
-- 
1.7.10



