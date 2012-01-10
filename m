Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2AJNEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 08:04:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34636 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab2AJNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 08:04:45 -0500
Subject: [PATCH v2 4/5] NFS: remove RPC PipeFS mount point reference from
 blocklayout routines
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Tue, 10 Jan 2012 17:04:40 +0400
Message-ID: <20120110130440.1672.43785.stgit@localhost6.localdomain6>
In-Reply-To: <20120110130323.1672.97025.stgit@localhost6.localdomain6>
References: <20120110130323.1672.97025.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch. We don't need this reference anymore, because
blocklayout pipes dentries now creates and destroys in per-net operations and
on PipeFS mount/umount notification.
Note that nfs4blocklayout_register_net() now returns 0 instead of -ENOENT in
case of PipeFS superblock absence. This is ok, because blocklayout pipe dentry
will be created on PipeFS mount event.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 fs/nfs/blocklayout/blocklayout.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 322d920..2c70202 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -1034,7 +1034,7 @@ static struct dentry *nfs4blocklayout_register_net(struct net *net,
 
 	pipefs_sb = rpc_get_sb_net(net);
 	if (!pipefs_sb)
-		return ERR_PTR(-ENOENT);
+		return 0;
 	dentry = nfs4blocklayout_register_sb(pipefs_sb, pipe);
 	rpc_put_sb_net(net);
 	return dentry;
@@ -1085,7 +1085,6 @@ static struct pernet_operations nfs4blocklayout_net_ops = {
 
 static int __init nfs4blocklayout_init(void)
 {
-	struct vfsmount *mnt;
 	int ret;
 
 	dprintk("%s: NFSv4 Block Layout Driver Registering...\n", __func__);
@@ -1095,12 +1094,6 @@ static int __init nfs4blocklayout_init(void)
 		goto out;
 
 	init_waitqueue_head(&bl_wq);
-
-	mnt = rpc_get_mount();
-	if (IS_ERR(mnt)) {
-		ret = PTR_ERR(mnt);
-		goto out_remove;
-	}
 	ret = rpc_pipefs_notifier_register(&nfs4blocklayout_block);
 	if (ret)
 		goto out_remove;

