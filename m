Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2D0Wmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:42:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53053 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab2D0Wms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:42:48 -0400
Date: Fri, 27 Apr 2012 17:42:43 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 53/62] nfsd: fix b0rken error value for setattr on read-only
 mount
Message-ID: <20120427224243.GF2821@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223246.518489951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223246.518489951@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> 3.3-stable review patch.
[...]
> commit 96f6f98501196d46ce52c2697dd758d9300c63f5 upstream.
>
> ..._want_write() returns -EROFS on failure, _not_ an NFS error value.

Here's the corresponding change for kernels without

	static inline int fh_want_write(struct svc_fh *fh)
	{
		return mnt_want_write(fh->fh_export->ex_path.mnt);
	}

from v3.3-rc1~170^2~81 ("new helpers: fh_{want,drop}_write()"),
such as the 3.0.y kernel.  Thoughts and testing welcome as usual.

-- >8 --
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 12 Apr 2012 23:47:00 -0400

commit 96f6f98501196d46ce52c2697dd758d9300c63f5 upstream.

..._want_write() returns -EROFS on failure, _not_ an NFS error value.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Thanks,
Jonathan

 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 0b8830c9de73..d06a02c1b1a3 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -812,6 +812,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	      struct nfsd4_setattr *setattr)
 {
 	__be32 status = nfs_ok;
+	int err;
 
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
 		nfs4_lock_state();
@@ -823,9 +824,9 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
-- 
1.7.10

