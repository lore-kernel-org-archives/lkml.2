Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2KNF5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:57:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398Ab2KNFu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:58 -0500
Message-Id: <20121114053939.961796275@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 44/82] NFSv4.1: We must release the sequence id when we fail to get a
 session slot
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2240a9e2d013d8269ea425b73e1d7a54c7bc141f upstream.

If we do not release the sequence id in cases where we fail to get a
session slot, then we can deadlock if we hit a recovery scenario.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2:
 - Adjust context
 - nfs4_setup_sequence() has an additional 'cache_reply' parameter]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1463,9 +1463,11 @@ static void nfs4_open_prepare(struct rpc
 	data->timestamp = jiffies;
 	if (nfs4_setup_sequence(data->o_arg.server,
 				&data->o_arg.seq_args,
-				&data->o_res.seq_res, 1, task))
-		return;
-	rpc_call_start(task);
+				&data->o_res.seq_res,
+				1, task) != 0)
+		nfs_release_seqid(data->o_arg.seqid);
+	else
+		rpc_call_start(task);
 	return;
 unlock_no_action:
 	rcu_read_unlock();
@@ -2045,9 +2047,10 @@ static void nfs4_close_prepare(struct rp
 	calldata->timestamp = jiffies;
 	if (nfs4_setup_sequence(NFS_SERVER(calldata->inode),
 				&calldata->arg.seq_args, &calldata->res.seq_res,
-				1, task))
-		return;
-	rpc_call_start(task);
+				1, task) != 0)
+		nfs_release_seqid(calldata->arg.seqid);
+	else
+		rpc_call_start(task);
 }
 
 static const struct rpc_call_ops nfs4_close_ops = {
@@ -4163,9 +4166,11 @@ static void nfs4_locku_prepare(struct rp
 	calldata->timestamp = jiffies;
 	if (nfs4_setup_sequence(calldata->server,
 				&calldata->arg.seq_args,
-				&calldata->res.seq_res, 1, task))
-		return;
-	rpc_call_start(task);
+				&calldata->res.seq_res,
+				1, task) != 0)
+		nfs_release_seqid(calldata->arg.seqid);
+	else
+		rpc_call_start(task);
 }
 
 static const struct rpc_call_ops nfs4_locku_ops = {
@@ -4309,7 +4314,7 @@ static void nfs4_lock_prepare(struct rpc
 	/* Do we need to do an open_to_lock_owner? */
 	if (!(data->arg.lock_seqid->sequence->flags & NFS_SEQID_CONFIRMED)) {
 		if (nfs_wait_on_sequence(data->arg.open_seqid, task) != 0)
-			return;
+			goto out_release_lock_seqid;
 		data->arg.open_stateid = &state->stateid;
 		data->arg.new_lock_owner = 1;
 		data->res.open_seqid = data->arg.open_seqid;
@@ -4318,10 +4323,15 @@ static void nfs4_lock_prepare(struct rpc
 	data->timestamp = jiffies;
 	if (nfs4_setup_sequence(data->server,
 				&data->arg.seq_args,
-				&data->res.seq_res, 1, task))
+				&data->res.seq_res,
+				1, task) == 0) {
+		rpc_call_start(task);
 		return;
-	rpc_call_start(task);
-	dprintk("%s: done!, ret = %d\n", __func__, data->rpc_status);
+	}
+	nfs_release_seqid(data->arg.open_seqid);
+out_release_lock_seqid:
+	nfs_release_seqid(data->arg.lock_seqid);
+	dprintk("%s: done!, ret = %d\n", __func__, task->tk_status);
 }
 
 static void nfs4_recover_lock_prepare(struct rpc_task *task, void *calldata)


