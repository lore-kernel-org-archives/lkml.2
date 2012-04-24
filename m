Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab2DXWuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:50:00 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab2DXWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:40 -0400
Message-Id: <20120424223246.518489951@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 53/62] nfsd: fix b0rken error value for setattr on read-only mount
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 96f6f98501196d46ce52c2697dd758d9300c63f5 upstream.

..._want_write() returns -EROFS on failure, _not_ an NFS error value.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -826,6 +826,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 	      struct nfsd4_setattr *setattr)
 {
 	__be32 status = nfs_ok;
+	int err;
 
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
 		nfs4_lock_state();
@@ -837,9 +838,9 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 			return status;
 		}
 	}
-	status = fh_want_write(&cstate->current_fh);
-	if (status)
-		return status;
+	err = fh_want_write(&cstate->current_fh);
+	if (err)
+		return nfserrno(err);
 	status = nfs_ok;
 
 	status = check_attr_support(rqstp, cstate, setattr->sa_bmval,


