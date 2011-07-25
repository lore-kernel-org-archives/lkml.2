Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1GYDUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 23:20:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48415 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1GYDUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 23:20:33 -0400
Date: Mon, 25 Jul 2011 13:20:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-Id: <20110725132022.9cac27e6aee69728e4de6b97@canb.auug.org.au>
In-Reply-To: <20110716164404.0f791c640332bbad6ab8ea34@canb.auug.org.au>
References: <20110716164404.0f791c640332bbad6ab8ea34@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Sat, 16 Jul 2011 16:44:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/read.c: In function 'nfs_do_read':
> fs/nfs/read.c:246:42: error: 'struct nfs_open_context' has no member named 'path'
> 
> Caused by commit 6e4efd568574 ("NFS: Clean up nfs_read_rpcsetup and
> nfs_write_rpcsetup") from the nfs tree interacting with commit
> b98aad31afdc ("nfs_open_context doesn't need struct path either").
> 
> I have applied the following merge fixup patch:

This patch (repeasted here) is now required after mergeing the nfs tree
and Linus' tree:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sat, 16 Jul 2011 16:32:06 +1000
Subject: [PATCH] vfs/nfs: fixup for nfs_open_context change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nfs/read.c |    2 +-
 fs/nfs/write.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 3170712..2171c04 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -243,7 +243,7 @@ static void nfs_read_rpcsetup(struct nfs_page *req, struct nfs_read_data *data,
 static int nfs_do_read(struct nfs_read_data *data,
 		const struct rpc_call_ops *call_ops)
 {
-	struct inode *inode = data->args.context->path.dentry->d_inode;
+	struct inode *inode = data->args.context->dentry->d_inode;
 
 	return nfs_initiate_read(data, NFS_CLIENT(inode), call_ops);
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 2d2c773..ebed518 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -889,7 +889,7 @@ static int nfs_do_write(struct nfs_write_data *data,
 		const struct rpc_call_ops *call_ops,
 		int how)
 {
-	struct inode *inode = data->args.context->path.dentry->d_inode;
+	struct inode *inode = data->args.context->dentry->d_inode;
 
 	return nfs_initiate_write(data, NFS_CLIENT(inode), call_ops, how);
 }
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
