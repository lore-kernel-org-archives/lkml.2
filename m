Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2IQAvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33450 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143Ab2IQAtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:46 -0400
Message-Id: <20120917003639.084506426@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Andi Kleen <andi@firstfloor.org>, David Binderman <dcb314@hotmail.com>
Subject: [ 093/135] NFS: Fix the initialisation of the readdir cookieverf array
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c3f52af3e03013db5237e339c817beaae5ec9e3a upstream.

When the NFS_COOKIEVERF helper macro was converted into a static
inline function in commit 99fadcd764 (nfs: convert NFS_*(inode)
helpers to static inline), we broke the initialisation of the
readdir cookies, since that depended on doing a memset with an
argument of 'sizeof(NFS_COOKIEVERF(inode))' which therefore
changed from sizeof(be32 cookieverf[2]) to sizeof(be32 *).

At this point, NFS_COOKIEVERF seems to be more of an obfuscation
than a helper, so the best thing would be to just get rid of it.

Also see: https://bugzilla.kernel.org/show_bug.cgi?id=46881

Reported-by: Andi Kleen <andi@firstfloor.org>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/inode.c         |    2 +-
 fs/nfs/nfs3proc.c      |    2 +-
 fs/nfs/nfs4proc.c      |    4 ++--
 include/linux/nfs_fs.h |    5 -----
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index c6e895f..9b47610 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -154,7 +154,7 @@ static void nfs_zap_caches_locked(struct inode *inode)
 	nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 	nfsi->attrtimeo_timestamp = jiffies;
 
-	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
+	memset(NFS_I(inode)->cookieverf, 0, sizeof(NFS_I(inode)->cookieverf));
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
 		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
 	else
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index d6b3b5f..6932209 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -643,7 +643,7 @@ nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 		  u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct inode		*dir = dentry->d_inode;
-	__be32			*verf = NFS_COOKIEVERF(dir);
+	__be32			*verf = NFS_I(dir)->cookieverf;
 	struct nfs3_readdirargs	arg = {
 		.fh		= NFS_FH(dir),
 		.cookie		= cookie,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6352741..86b4c73 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3215,11 +3215,11 @@ static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 			dentry->d_parent->d_name.name,
 			dentry->d_name.name,
 			(unsigned long long)cookie);
-	nfs4_setup_readdir(cookie, NFS_COOKIEVERF(dir), dentry, &args);
+	nfs4_setup_readdir(cookie, NFS_I(dir)->cookieverf, dentry, &args);
 	res.pgbase = args.pgbase;
 	status = nfs4_call_sync(NFS_SERVER(dir)->client, NFS_SERVER(dir), &msg, &args.seq_args, &res.seq_res, 0);
 	if (status >= 0) {
-		memcpy(NFS_COOKIEVERF(dir), res.verifier.data, NFS4_VERIFIER_SIZE);
+		memcpy(NFS_I(dir)->cookieverf, res.verifier.data, NFS4_VERIFIER_SIZE);
 		status += args.pgbase;
 	}
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 1f8fc7f..4b03f56 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -265,11 +265,6 @@ static inline const struct nfs_rpc_ops *NFS_PROTO(const struct inode *inode)
 	return NFS_SERVER(inode)->nfs_client->rpc_ops;
 }
 
-static inline __be32 *NFS_COOKIEVERF(const struct inode *inode)
-{
-	return NFS_I(inode)->cookieverf;
-}
-
 static inline unsigned NFS_MINATTRTIMEO(const struct inode *inode)
 {
 	struct nfs_server *nfss = NFS_SERVER(inode);


