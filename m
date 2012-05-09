Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab2EIGaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:30:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38735 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576Ab2EIFww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:52 -0400
Message-Id: <20120509055036.920955681@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 052/167] [PATCH] nfsd: fix compose_entry_fh() failure exits
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

commit efe39651f08813180f37dc508d950fc7d92b29a8 upstream.

Restore the original logics ("fail on mountpoints, negatives and in
case of fh_compose() failures").  Since commit 8177e (nfsd: clean up
readdirplus encoding) that got broken -
	rv = fh_compose(fhp, exp, dchild, &cd->fh);
	if (rv)
	       goto out;
	if (!dchild->d_inode)
		goto out;
	rv = 0;
out:
is equivalent to
	rv = fh_compose(fhp, exp, dchild, &cd->fh);
out:
and the second check has no effect whatsoever...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs3xdr.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 08c6e36..43f46cd 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -803,13 +803,13 @@ encode_entry_baggage(struct nfsd3_readdirres *cd, __be32 *p, const char *name,
 	return p;
 }
 
-static int
+static __be32
 compose_entry_fh(struct nfsd3_readdirres *cd, struct svc_fh *fhp,
 		const char *name, int namlen)
 {
 	struct svc_export	*exp;
 	struct dentry		*dparent, *dchild;
-	int rv = 0;
+	__be32 rv = nfserr_noent;
 
 	dparent = cd->fh.fh_dentry;
 	exp  = cd->fh.fh_export;
@@ -817,26 +817,20 @@ compose_entry_fh(struct nfsd3_readdirres *cd, struct svc_fh *fhp,
 	if (isdotent(name, namlen)) {
 		if (namlen == 2) {
 			dchild = dget_parent(dparent);
-			if (dchild == dparent) {
-				/* filesystem root - cannot return filehandle for ".." */
-				dput(dchild);
-				return -ENOENT;
-			}
+			/* filesystem root - cannot return filehandle for ".." */
+			if (dchild == dparent)
+				goto out;
 		} else
 			dchild = dget(dparent);
 	} else
 		dchild = lookup_one_len(name, dparent, namlen);
 	if (IS_ERR(dchild))
-		return -ENOENT;
-	rv = -ENOENT;
+		return rv;
 	if (d_mountpoint(dchild))
 		goto out;
-	rv = fh_compose(fhp, exp, dchild, &cd->fh);
-	if (rv)
-		goto out;
 	if (!dchild->d_inode)
 		goto out;
-	rv = 0;
+	rv = fh_compose(fhp, exp, dchild, &cd->fh);
 out:
 	dput(dchild);
 	return rv;
@@ -845,7 +839,7 @@ out:
 static __be32 *encode_entryplus_baggage(struct nfsd3_readdirres *cd, __be32 *p, const char *name, int namlen)
 {
 	struct svc_fh	fh;
-	int err;
+	__be32 err;
 
 	fh_init(&fh, NFS3_FHSIZE);
 	err = compose_entry_fh(cd, &fh, name, namlen);
-- 
1.7.10



