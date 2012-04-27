Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab2D0Wyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:54:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab2D0Wyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:54:43 -0400
Date: Fri, 27 Apr 2012 17:54:38 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 54/62] nfsd: fix error values returned by nfsd4_lockt() when
 nfsd_open() fails
Message-ID: <20120427225438.GG2821@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223246.607005556@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223246.607005556@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> 3.3-stable review patch.
[...]
> commit 04da6e9d63427b2d0fd04766712200c250b3278f upstream.
>
> nfsd_open() already returns an NFS error value; only vfs_test_lock()
> result needs to be fed through nfserrno().  Broken by commit 55ef12
> (nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT)
> three years ago...

The regression was introduced in v2.6.29-rc1~177^2~14, so presumably
2.6.32.y and 3.0.y need this.  Here's a blind backport to 3.0.y ---
the only conflict encountered is of the unrelated-changes-on-adjacent-
lines kind, against

  v3.2-rc1~80^2~63 nfsd4: eliminate unused lt_stateowner
  v3.2-rc1~80^2~58 nfsd4: split stateowners into open and lockowners

Untested, so thoughts and testing would be welcome as usual.

-- >8 --
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 13 Apr 2012 00:00:04 -0400

commit 04da6e9d63427b2d0fd04766712200c250b3278f upstream.

nfsd_open() already returns an NFS error value; only vfs_test_lock()
result needs to be fed through nfserrno().  Broken by commit 55ef12
(nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT)
three years ago...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Thanks,
Jonathan

 fs/nfsd/nfs4state.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index ecd8152965ee..92f7eb7c5863 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3956,16 +3956,14 @@ out:
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
 
@@ -3978,7 +3976,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 {
 	struct inode *inode;
 	struct file_lock file_lock;
-	int error;
 	__be32 status;
 
 	if (locks_in_grace())
@@ -4030,12 +4027,10 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
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

