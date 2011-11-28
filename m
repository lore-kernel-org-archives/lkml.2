Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1K1Nfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:35:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33157 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1K1Nfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:35:44 -0500
Subject: [PATCH 5/6] NFS: handle NFS idmap pipe PipeFS dentries by network
	namespace aware routines
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Mon, 28 Nov 2011 17:34:02 +0300
Message-ID: <20111128133402.4251.18289.stgit@localhost6.localdomain6>
In-Reply-To: <20111128132805.4251.15252.stgit@localhost6.localdomain6>
References: <20111128132805.4251.15252.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes NFS idmap pipes dentries allocated and destroyed in network
namespace context by PipeFS network namespace aware routines.
Network namespace context is obtained from nfs_client structure.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 fs/nfs/idmap.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 60698a1..0680f63 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -350,6 +350,56 @@ static const struct rpc_pipe_ops idmap_upcall_ops = {
 	.destroy_msg	= idmap_pipe_destroy_msg,
 };
 
+static void __nfs_idmap_unregister(struct rpc_pipe *pipe)
+{
+	if (pipe->dentry)
+		rpc_unlink(pipe->dentry);
+}
+
+static int __nfs_idmap_register(struct dentry *dir,
+				     struct idmap *idmap,
+				     struct rpc_pipe *pipe)
+{
+	struct dentry *dentry;
+
+	dentry = rpc_mkpipe_dentry(dir, "idmap", idmap, pipe);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	pipe->dentry = dentry;
+	return 0;
+}
+
+static void nfs_idmap_unregister(struct nfs_client *clp,
+				      struct rpc_pipe *pipe)
+{
+	struct net *net = clp->net;
+	struct super_block *pipefs_sb;
+
+	pipefs_sb = rpc_get_sb_net(net);
+	if (pipefs_sb) {
+		__nfs_idmap_unregister(pipe);
+		rpc_put_sb_net(net);
+	}
+}
+
+static int nfs_idmap_register(struct nfs_client *clp,
+				   struct idmap *idmap,
+				   struct rpc_pipe *pipe)
+{
+	struct net *net = clp->net;
+	struct super_block *pipefs_sb;
+	int err = 0;
+
+	pipefs_sb = rpc_get_sb_net(net);
+	if (pipefs_sb) {
+		if (clp->cl_rpcclient->cl_dentry)
+			err = __nfs_idmap_register(clp->cl_rpcclient->cl_dentry,
+						   idmap, pipe);
+		rpc_put_sb_net(net);
+	}
+	return err;
+}
+
 int
 nfs_idmap_new(struct nfs_client *clp)
 {
@@ -369,12 +419,8 @@ nfs_idmap_new(struct nfs_client *clp)
 		kfree(idmap);
 		return error;
 	}
-
-	if (clp->cl_rpcclient->cl_dentry)
-		pipe->dentry = rpc_mkpipe_dentry(clp->cl_rpcclient->cl_dentry,
-				"idmap", idmap, pipe);
-	if (IS_ERR(pipe->dentry)) {
-		error = PTR_ERR(pipe->dentry);
+	error = nfs_idmap_register(clp, idmap, pipe);
+	if (error) {
 		rpc_destroy_pipe_data(pipe);
 		kfree(idmap);
 		return error;
@@ -397,8 +443,7 @@ nfs_idmap_delete(struct nfs_client *clp)
 
 	if (!idmap)
 		return;
-	if (idmap->idmap_pipe->dentry)
-		rpc_unlink(idmap->idmap_pipe->dentry);
+	nfs_idmap_unregister(clp, idmap->idmap_pipe);
 	rpc_destroy_pipe_data(idmap->idmap_pipe);
 	clp->cl_idmap = NULL;
 	kfree(idmap);

