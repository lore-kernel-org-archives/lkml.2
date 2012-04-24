Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2DXWgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:46 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2DXWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:43 -0400
Message-Id: <20120424223246.607005556@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 54/62] nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fails
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 04da6e9d63427b2d0fd04766712200c250b3278f upstream.

nfsd_open() already returns an NFS error value; only vfs_test_lock()
result needs to be fed through nfserrno().  Broken by commit 55ef12
(nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT)
three years ago...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4109,16 +4109,14 @@ out:
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
 
@@ -4132,7 +4130,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 	struct inode *inode;
 	struct file_lock file_lock;
 	struct nfs4_lockowner *lo;
-	int error;
 	__be32 status;
 
 	if (locks_in_grace())
@@ -4178,12 +4175,10 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 
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


