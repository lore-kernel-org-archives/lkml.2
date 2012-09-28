Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032653Ab2I1U2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:28:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032636Ab2I1U2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <andi@firstfloor.org>, David Binderman <dcb314@hotmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 120/218] NFS: Fix the initialisation of the readdir cookieverf array
Date: Fri, 28 Sep 2012 13:15:37 -0700
Message-Id: <20120928201515.238799890@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -644,7 +644,7 @@ nfs3_proc_readdir(struct dentry *dentry,
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
@@ -3150,11 +3150,11 @@ static int _nfs4_proc_readdir(struct den
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
@@ -264,11 +264,6 @@ static inline const struct nfs_rpc_ops *
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


