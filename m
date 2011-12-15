Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab1LOP77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:59:59 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23465 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971Ab1LOP75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:59:57 -0500
Subject: [PATCH 1/7] SUNRPC: create rpcbind client in passed network namespace
 context
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Thu, 15 Dec 2011 19:59:51 +0300
Message-ID: <20111215155951.2434.61942.stgit@localhost6.localdomain6>
In-Reply-To: <20111215155252.2434.39434.stgit@localhost6.localdomain6>
References: <20111215155252.2434.39434.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rpcbind clients are per network namespace.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/rpcb_clnt.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 46f5915..43eff03 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -344,11 +344,12 @@ out:
 	return result;
 }
 
-static struct rpc_clnt *rpcb_create(char *hostname, struct sockaddr *srvaddr,
-				    size_t salen, int proto, u32 version)
+static struct rpc_clnt *rpcb_create(struct net *net, char *hostname,
+				    struct sockaddr *srvaddr, size_t salen,
+				    int proto, u32 version)
 {
 	struct rpc_create_args args = {
-		.net		= &init_net,
+		.net		= net,
 		.protocol	= proto,
 		.address	= srvaddr,
 		.addrsize	= salen,
@@ -708,8 +709,8 @@ void rpcb_getport_async(struct rpc_task *task)
 	dprintk("RPC: %5u %s: trying rpcbind version %u\n",
 		task->tk_pid, __func__, bind_version);
 
-	rpcb_clnt = rpcb_create(clnt->cl_server, sap, salen, xprt->prot,
-				bind_version);
+	rpcb_clnt = rpcb_create(xprt->xprt_net, clnt->cl_server, sap, salen,
+				xprt->prot, bind_version);
 	if (IS_ERR(rpcb_clnt)) {
 		status = PTR_ERR(rpcb_clnt);
 		dprintk("RPC: %5u %s: rpcb_create failed, error %ld\n",

