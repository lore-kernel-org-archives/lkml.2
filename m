Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2L1Tex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:34:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55475 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290Ab2L1TTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:07 -0500
Message-Id: <20121228190345.245504428@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 072/173] NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit 6bdb5f213c4344324f600dde885f25768fbd14db upstream.

If I mount an NFS v4.1 server to a single client multiple times and then
run xfstests over each mountpoint I usually get the client into a state
where recovery deadlocks.  The server informs the client of a
cb_path_down sequence error, the client then does a
bind_connection_to_session and checks the status of the lease.

I found that bind_connection_to_session sets the NFS4_SESSION_DRAINING
flag on the client, but this flag is never unset before
nfs4_check_lease() reaches nfs4_proc_sequence().  This causes the client
to deadlock, halting all NFS activity to the server.  nfs4_proc_sequence()
is only called by the state manager, so I can change it to run in privileged
mode to bypass the NFS4_SESSION_DRAINING check and avoid the deadlock.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6300cdd..a32d953 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6136,13 +6136,26 @@ static void nfs41_sequence_prepare(struct rpc_task *task, void *data)
 	rpc_call_start(task);
 }
 
+static void nfs41_sequence_prepare_privileged(struct rpc_task *task, void *data)
+{
+	rpc_task_set_priority(task, RPC_PRIORITY_PRIVILEGED);
+	nfs41_sequence_prepare(task, data);
+}
+
 static const struct rpc_call_ops nfs41_sequence_ops = {
 	.rpc_call_done = nfs41_sequence_call_done,
 	.rpc_call_prepare = nfs41_sequence_prepare,
 	.rpc_release = nfs41_sequence_release,
 };
 
-static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struct rpc_cred *cred)
+static const struct rpc_call_ops nfs41_sequence_privileged_ops = {
+	.rpc_call_done = nfs41_sequence_call_done,
+	.rpc_call_prepare = nfs41_sequence_prepare_privileged,
+	.rpc_release = nfs41_sequence_release,
+};
+
+static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struct rpc_cred *cred,
+					     const struct rpc_call_ops *seq_ops)
 {
 	struct nfs4_sequence_data *calldata;
 	struct rpc_message msg = {
@@ -6152,7 +6165,7 @@ static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struct rpc_
 	struct rpc_task_setup task_setup_data = {
 		.rpc_client = clp->cl_rpcclient,
 		.rpc_message = &msg,
-		.callback_ops = &nfs41_sequence_ops,
+		.callback_ops = seq_ops,
 		.flags = RPC_TASK_ASYNC | RPC_TASK_SOFT,
 	};
 
@@ -6179,7 +6192,7 @@ static int nfs41_proc_async_sequence(struct nfs_client *clp, struct rpc_cred *cr
 
 	if ((renew_flags & NFS4_RENEW_TIMEOUT) == 0)
 		return 0;
-	task = _nfs41_proc_sequence(clp, cred);
+	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_ops);
 	if (IS_ERR(task))
 		ret = PTR_ERR(task);
 	else
@@ -6193,7 +6206,7 @@ static int nfs4_proc_sequence(struct nfs_client *clp, struct rpc_cred *cred)
 	struct rpc_task *task;
 	int ret;
 
-	task = _nfs41_proc_sequence(clp, cred);
+	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_privileged_ops);
 	if (IS_ERR(task)) {
 		ret = PTR_ERR(task);
 		goto out;


