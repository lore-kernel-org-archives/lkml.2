Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031080Ab2I1Tde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:33:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965432Ab2I1TBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <andi@firstfloor.org>, David Binderman <dcb314@hotmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 149/262] NFS: Fix the initialisation of the readdir cookieverf array
Date: Fri, 28 Sep 2012 11:51:18 -0700
Message-Id: <20120928183015.636940504@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/inode.c         |    2 +-
 fs/nfs/nfs3proc.c      |    2 +-
 fs/nfs/nfs4proc.c      |    4 ++--
 include/linux/nfs_fs.h |    5 -----
 4 files changed, 4 insertions(+), 9 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -152,7 +152,7 @@ static void nfs_zap_caches_locked(struct
 	nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 	nfsi->attrtimeo_timestamp = jiffies;
 
-	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
+	memset(NFS_I(inode)->cookieverf, 0, sizeof(NFS_I(inode)->cookieverf));
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
 		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
 	else
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -643,7 +643,7 @@ nfs3_proc_readdir(struct dentry *dentry,
 		  u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct inode		*dir = dentry->d_inode;
-	__be32			*verf = NFS_COOKIEVERF(dir);
+	__be32			*verf = NFS_I(dir)->cookieverf;
 	struct nfs3_readdirargs	arg = {
 		.fh		= NFS_FH(dir),
 		.cookie		= cookie,
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3189,11 +3189,11 @@ static int _nfs4_proc_readdir(struct den
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
 
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -265,11 +265,6 @@ static inline const struct nfs_rpc_ops *
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


