Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2EIGYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:24:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38835 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab2EIFxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:06 -0400
Message-Id: <20120509055036.518520916@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 049/167] nfsd: fix b0rken error value for setattr on read-only mount
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

commit 96f6f98501196d46ce52c2697dd758d9300c63f5 upstream.

..._want_write() returns -EROFS on failure, _not_ an NFS error value.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


