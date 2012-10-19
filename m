Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab2JSDIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:08:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:51880 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab2JSCsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 08/76] lockd: per-net NSM client creation and destruction helpers introduced
Date: Thu, 18 Oct 2012 19:46:32 -0700
Message-Id: <20121019024351.422413158@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit e9406db20fecbfcab646bad157b4cfdc7cadddfb upstream.

NSM RPC client can be required on NFSv3 umount, when child reaper is dying (and
destroying it's mount namespace). It means, that current nsproxy is set to
NULL already, but creation of RPC client requires UTS namespace for gaining
hostname string.
This patch introduces reference counted NFS RPC clients creation and
destruction helpers (similar to RPCBIND RPC clients).

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/mon.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/lockd/netns.h |    4 ++++
 fs/lockd/svc.c   |    1 +
 3 files changed, 54 insertions(+), 2 deletions(-)

--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -19,6 +19,8 @@
 
 #include <asm/unaligned.h>
 
+#include "netns.h"
+
 #define NLMDBG_FACILITY		NLMDBG_MONITOR
 #define NSM_PROGRAM		100024
 #define NSM_VERSION		1
@@ -70,7 +72,7 @@ static struct rpc_clnt *nsm_create(struc
 	};
 	struct rpc_create_args args = {
 		.net			= net,
-		.protocol		= XPRT_TRANSPORT_UDP,
+		.protocol		= XPRT_TRANSPORT_TCP,
 		.address		= (struct sockaddr *)&sin,
 		.addrsize		= sizeof(sin),
 		.servername		= "rpc.statd",
@@ -83,6 +85,51 @@ static struct rpc_clnt *nsm_create(struc
 	return rpc_create(&args);
 }
 
+__maybe_unused static struct rpc_clnt *nsm_client_get(struct net *net)
+{
+	static DEFINE_MUTEX(nsm_create_mutex);
+	struct rpc_clnt	*clnt;
+	struct lockd_net *ln = net_generic(net, lockd_net_id);
+
+	spin_lock(&ln->nsm_clnt_lock);
+	if (ln->nsm_users) {
+		ln->nsm_users++;
+		clnt = ln->nsm_clnt;
+		spin_unlock(&ln->nsm_clnt_lock);
+		goto out;
+	}
+	spin_unlock(&ln->nsm_clnt_lock);
+
+	mutex_lock(&nsm_create_mutex);
+	clnt = nsm_create(net);
+	if (!IS_ERR(clnt)) {
+		ln->nsm_clnt = clnt;
+		smp_wmb();
+		ln->nsm_users = 1;
+	}
+	mutex_unlock(&nsm_create_mutex);
+out:
+	return clnt;
+}
+
+__maybe_unused static void nsm_client_put(struct net *net)
+{
+	struct lockd_net *ln = net_generic(net, lockd_net_id);
+	struct rpc_clnt	*clnt = ln->nsm_clnt;
+	int shutdown = 0;
+
+	spin_lock(&ln->nsm_clnt_lock);
+	if (ln->nsm_users) {
+		if (--ln->nsm_users)
+			ln->nsm_clnt = NULL;
+		shutdown = !ln->nsm_users;
+	}
+	spin_unlock(&ln->nsm_clnt_lock);
+
+	if (shutdown)
+		rpc_shutdown_client(clnt);
+}
+
 static int nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res,
 			 struct net *net)
 {
@@ -111,7 +158,7 @@ static int nsm_mon_unmon(struct nsm_hand
 	memset(res, 0, sizeof(*res));
 
 	msg.rpc_proc = &clnt->cl_procinfo[proc];
-	status = rpc_call_sync(clnt, &msg, 0);
+	status = rpc_call_sync(clnt, &msg, RPC_TASK_SOFTCONN);
 	if (status < 0)
 		dprintk("lockd: NSM upcall RPC failed, status=%d\n",
 				status);
--- a/fs/lockd/netns.h
+++ b/fs/lockd/netns.h
@@ -12,6 +12,10 @@ struct lockd_net {
 	struct delayed_work grace_period_end;
 	struct lock_manager lockd_manager;
 	struct list_head grace_list;
+
+	spinlock_t nsm_clnt_lock;
+	unsigned int nsm_users;
+	struct rpc_clnt *nsm_clnt;
 };
 
 extern int lockd_net_id;
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -596,6 +596,7 @@ static int lockd_init_net(struct net *ne
 
 	INIT_DELAYED_WORK(&ln->grace_period_end, grace_ender);
 	INIT_LIST_HEAD(&ln->grace_list);
+	spin_lock_init(&ln->nsm_clnt_lock);
 	return 0;
 }
 


