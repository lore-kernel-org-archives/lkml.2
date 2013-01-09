Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3AIV2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:28:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:42524 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467Ab3AIUjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 039/123] NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()
Date: Wed,  9 Jan 2013 12:34:38 -0800
Message-Id: <20130109201503.571037064@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6138,13 +6138,26 @@ static void nfs41_sequence_prepare(struc
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
@@ -6154,7 +6167,7 @@ static struct rpc_task *_nfs41_proc_sequ
 	struct rpc_task_setup task_setup_data = {
 		.rpc_client = clp->cl_rpcclient,
 		.rpc_message = &msg,
-		.callback_ops = &nfs41_sequence_ops,
+		.callback_ops = seq_ops,
 		.flags = RPC_TASK_ASYNC | RPC_TASK_SOFT,
 	};
 
@@ -6181,7 +6194,7 @@ static int nfs41_proc_async_sequence(str
 
 	if ((renew_flags & NFS4_RENEW_TIMEOUT) == 0)
 		return 0;
-	task = _nfs41_proc_sequence(clp, cred);
+	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_ops);
 	if (IS_ERR(task))
 		ret = PTR_ERR(task);
 	else
@@ -6195,7 +6208,7 @@ static int nfs4_proc_sequence(struct nfs
 	struct rpc_task *task;
 	int ret;
 
-	task = _nfs41_proc_sequence(clp, cred);
+	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_privileged_ops);
 	if (IS_ERR(task)) {
 		ret = PTR_ERR(task);
 		goto out;


