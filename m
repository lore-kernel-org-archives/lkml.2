Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2EDUtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:49:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab2EDUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:00 -0400
Message-Id: <20120504204246.694961854@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 21/47] nfsd: fix b0rken error value for setattr on read-only mount
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Al Viro <viro@zeniv.linux.org.uk>

commit 96f6f98501196d46ce52c2697dd758d9300c63f5 upstream.

..._want_write() returns -EROFS on failure, _not_ an NFS error value.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -812,6 +812,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 	      struct nfsd4_setattr *setattr)
 {
 	__be32 status = nfs_ok;
+	int err;
 
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
 		nfs4_lock_state();
@@ -823,9 +824,9 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 			return status;
 		}
 	}
-	status = mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt);
-	if (status)
-		return status;
+	err = mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt);
+	if (err)
+		return nfserrno(err);
 	status = nfs_ok;
 
 	status = check_attr_support(rqstp, cstate, setattr->sa_bmval,


