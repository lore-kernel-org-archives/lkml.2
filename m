Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab2ICTCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:02:08 -0400
Received: from mx2.netapp.com ([216.240.18.37]:39659 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2ICTCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:02:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,361,1344236400"; 
   d="scan'208";a="685273161"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix memset in NFS zap caches
Thread-Topic: [PATCH] Fix memset in NFS zap caches
Thread-Index: AQHNigLiTnmJlQHzNUyblrA1JsIXkpd5aCAAgAACXACAAAF2AIAAApQA
Date: Mon, 3 Sep 2012 19:02:04 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908F81BDB@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120903183515.GT16230@one.firstfloor.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908F81A8E@SACEXCMBX04-PRD.hq.netapp.com>
	 <20120903184734.GU16230@one.firstfloor.org>
	 <1346698368.3648.6.camel@lade.trondhjem.org>
In-Reply-To: <1346698368.3648.6.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFFEE1EE5D777149BD799083913CFDA9@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q83J2NPr007667

On Mon, 2012-09-03 at 14:52 -0400, Trond Myklebust wrote:
> On Mon, 2012-09-03 at 20:47 +0200, Andi Kleen wrote:
> > > No, this is a gcc bug.
> > > 
> > > NFS_COOKIEVERF(inode) resolves to an array, so the current code is
> > > correct. The above change will cause the 2nd half of the array to remain
> > > uninitialised...
> > 
> > Are you sure?
> > 
> > include/linux/nfs_fs.h:268:static inline __be32 *NFS_COOKIEVERF(const struct inode *inode)
> > 
> > That doesn't look like an array type to me. 
> 
> Argh... It used to be a #define, but got converted in the commit
> 99fadcd7646 static inline blitz...
> 
> OK, let's just get rid of the NFS_COOKIEVERF thing altogether. At this
> point it is clearly just obfuscating the code.
> 
This should do the right thing:

8<------------------------------------------------------------------
>From c8879cbdf7c4697e450c4a001f24b88e04b70857 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 3 Sep 2012 14:56:02 -0400
Subject: [PATCH] NFS: Fix the initialisation of the readdir 'cookieverf'
 array

When the NFS_COOKIEVERF helper macro was converted into a static
inline function, we broke the initialisation of the readdir cookies,
since it depended on a 'sizeof(NFS_COOKIEVERF(inode))'.

At this point, NFS_COOKIEVERF seems to be more of an obfuscation
than a helper, so the best thing would be to just get rid of it.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/inode.c         | 2 +-
 fs/nfs/nfs3proc.c      | 2 +-
 fs/nfs/nfs4proc.c      | 4 ++--
 include/linux/nfs_fs.h | 5 -----
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
index 74f5c26..1e50326 100644
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
-- 
1.7.11.4


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
