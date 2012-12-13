Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab2LMOcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:32:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab2LMOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 166/241] SUNRPC: Fix a UDP transport regression
Date: Thu, 13 Dec 2012 11:58:51 -0200
Message-Id: <1355407206-17100-167-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit f39c1bfb5a03e2d255451bff05be0d7255298fa4 upstream.

Commit 43cedbf0e8dfb9c5610eb7985d5f21263e313802 (SUNRPC: Ensure that
we grab the XPRT_LOCK before calling xprt_alloc_slot) is causing
hangs in the case of NFS over UDP mounts.

Since neither the UDP or the RDMA transport mechanism use dynamic slot
allocation, we can skip grabbing the socket lock for those transports.
Add a new rpc_xprt_op to allow switching between the TCP and UDP/RDMA
case.

Note that the NFSv4.1 back channel assigns the slot directly
through rpc_run_bc_task, so we can ignore that case.

Reported-by: Dick Streefland <dick.streefland@altium.nl>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/sunrpc/xprt.h     |    3 +++
 net/sunrpc/xprt.c               |   34 ++++++++++++++++++++--------------
 net/sunrpc/xprtrdma/transport.c |    1 +
 net/sunrpc/xprtsock.c           |    3 +++
 4 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 77d278d..005b507 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -114,6 +114,7 @@ struct rpc_xprt_ops {
 	void		(*set_buffer_size)(struct rpc_xprt *xprt, size_t sndsize, size_t rcvsize);
 	int		(*reserve_xprt)(struct rpc_xprt *xprt, struct rpc_task *task);
 	void		(*release_xprt)(struct rpc_xprt *xprt, struct rpc_task *task);
+	void		(*alloc_slot)(struct rpc_xprt *xprt, struct rpc_task *task);
 	void		(*rpcbind)(struct rpc_task *task);
 	void		(*set_port)(struct rpc_xprt *xprt, unsigned short port);
 	void		(*connect)(struct rpc_task *task);
@@ -279,6 +280,8 @@ void			xprt_connect(struct rpc_task *task);
 void			xprt_reserve(struct rpc_task *task);
 int			xprt_reserve_xprt(struct rpc_xprt *xprt, struct rpc_task *task);
 int			xprt_reserve_xprt_cong(struct rpc_xprt *xprt, struct rpc_task *task);
+void			xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task);
+void			xprt_lock_and_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task);
 int			xprt_prepare_transmit(struct rpc_task *task);
 void			xprt_transmit(struct rpc_task *task);
 void			xprt_end_transmit(struct rpc_task *task);
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 3c83035..2d5b811 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -969,11 +969,11 @@ static bool xprt_dynamic_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
 	return false;
 }
 
-static void xprt_alloc_slot(struct rpc_task *task)
+void xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 {
-	struct rpc_xprt	*xprt = task->tk_xprt;
 	struct rpc_rqst *req;
 
+	spin_lock(&xprt->reserve_lock);
 	if (!list_empty(&xprt->free)) {
 		req = list_entry(xprt->free.next, struct rpc_rqst, rq_list);
 		list_del(&req->rq_list);
@@ -994,12 +994,29 @@ static void xprt_alloc_slot(struct rpc_task *task)
 	default:
 		task->tk_status = -EAGAIN;
 	}
+	spin_unlock(&xprt->reserve_lock);
 	return;
 out_init_req:
 	task->tk_status = 0;
 	task->tk_rqstp = req;
 	xprt_request_init(task, xprt);
+	spin_unlock(&xprt->reserve_lock);
+}
+EXPORT_SYMBOL_GPL(xprt_alloc_slot);
+
+void xprt_lock_and_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
+{
+	/* Note: grabbing the xprt_lock_write() ensures that we throttle
+	 * new slot allocation if the transport is congested (i.e. when
+	 * reconnecting a stream transport or when out of socket write
+	 * buffer space).
+	 */
+	if (xprt_lock_write(xprt, task)) {
+		xprt_alloc_slot(xprt, task);
+		xprt_release_write(xprt, task);
+	}
 }
+EXPORT_SYMBOL_GPL(xprt_lock_and_alloc_slot);
 
 static void xprt_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
 {
@@ -1083,20 +1100,9 @@ void xprt_reserve(struct rpc_task *task)
 	if (task->tk_rqstp != NULL)
 		return;
 
-	/* Note: grabbing the xprt_lock_write() here is not strictly needed,
-	 * but ensures that we throttle new slot allocation if the transport
-	 * is congested (e.g. if reconnecting or if we're out of socket
-	 * write buffer space).
-	 */
 	task->tk_timeout = 0;
 	task->tk_status = -EAGAIN;
-	if (!xprt_lock_write(xprt, task))
-		return;
-
-	spin_lock(&xprt->reserve_lock);
-	xprt_alloc_slot(task);
-	spin_unlock(&xprt->reserve_lock);
-	xprt_release_write(xprt, task);
+	xprt->ops->alloc_slot(xprt, task);
 }
 
 static inline __be32 xprt_alloc_xid(struct rpc_xprt *xprt)
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 06cdbff..5d9202d 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -713,6 +713,7 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 static struct rpc_xprt_ops xprt_rdma_procs = {
 	.reserve_xprt		= xprt_rdma_reserve_xprt,
 	.release_xprt		= xprt_release_xprt_cong, /* sunrpc/xprt.c */
+	.alloc_slot		= xprt_alloc_slot,
 	.release_request	= xprt_release_rqst_cong,       /* ditto */
 	.set_retrans_timeout	= xprt_set_retrans_timeout_def, /* ditto */
 	.rpcbind		= rpcb_getport_async,	/* sunrpc/rpcb_clnt.c */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 420abf8..1768e22 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2423,6 +2423,7 @@ static void bc_destroy(struct rpc_xprt *xprt)
 static struct rpc_xprt_ops xs_local_ops = {
 	.reserve_xprt		= xprt_reserve_xprt,
 	.release_xprt		= xs_tcp_release_xprt,
+	.alloc_slot		= xprt_alloc_slot,
 	.rpcbind		= xs_local_rpcbind,
 	.set_port		= xs_local_set_port,
 	.connect		= xs_connect,
@@ -2439,6 +2440,7 @@ static struct rpc_xprt_ops xs_udp_ops = {
 	.set_buffer_size	= xs_udp_set_buffer_size,
 	.reserve_xprt		= xprt_reserve_xprt_cong,
 	.release_xprt		= xprt_release_xprt_cong,
+	.alloc_slot		= xprt_alloc_slot,
 	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
@@ -2456,6 +2458,7 @@ static struct rpc_xprt_ops xs_udp_ops = {
 static struct rpc_xprt_ops xs_tcp_ops = {
 	.reserve_xprt		= xprt_reserve_xprt,
 	.release_xprt		= xs_tcp_release_xprt,
+	.alloc_slot		= xprt_lock_and_alloc_slot,
 	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
-- 
1.7.9.5

