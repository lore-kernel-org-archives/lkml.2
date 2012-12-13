Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2LMPFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:05:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2LMOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 035/241] NFSv4.1: We must release the sequence id when we fail to get a session slot
Date: Thu, 13 Dec 2012 11:56:40 -0200
Message-Id: <1355407206-17100-36-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2240a9e2d013d8269ea425b73e1d7a54c7bc141f upstream.

If we do not release the sequence id in cases where we fail to get a
session slot, then we can deadlock if we hit a recovery scenario.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/nfs4proc.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index aa321ac..e690a13 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1496,9 +1496,11 @@ static void nfs4_open_prepare(struct rpc_task *task, void *calldata)
 	data->timestamp = jiffies;
 	if (nfs4_setup_sequence(data->o_arg.server,
 				&data->o_arg.seq_args,
-				&data->o_res.seq_res, task))
-		return;
-	rpc_call_start(task);
+				&data->o_res.seq_res,
+				task) != 0)
+		nfs_release_seqid(data->o_arg.seqid);
+	else
+		rpc_call_start(task);
 	return;
 unlock_no_action:
 	rcu_read_unlock();
@@ -2138,9 +2140,10 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 	if (nfs4_setup_sequence(NFS_SERVER(calldata->inode),
 				&calldata->arg.seq_args,
 				&calldata->res.seq_res,
-				task))
-		goto out;
-	rpc_call_start(task);
+				task) != 0)
+		nfs_release_seqid(calldata->arg.seqid);
+	else
+		rpc_call_start(task);
 out:
 	dprintk("%s: done!\n", __func__);
 }
@@ -4355,9 +4358,11 @@ static void nfs4_locku_prepare(struct rpc_task *task, void *data)
 	calldata->timestamp = jiffies;
 	if (nfs4_setup_sequence(calldata->server,
 				&calldata->arg.seq_args,
-				&calldata->res.seq_res, task))
-		return;
-	rpc_call_start(task);
+				&calldata->res.seq_res,
+				task) != 0)
+		nfs_release_seqid(calldata->arg.seqid);
+	else
+		rpc_call_start(task);
 }
 
 static const struct rpc_call_ops nfs4_locku_ops = {
@@ -4502,7 +4507,7 @@ static void nfs4_lock_prepare(struct rpc_task *task, void *calldata)
 	/* Do we need to do an open_to_lock_owner? */
 	if (!(data->arg.lock_seqid->sequence->flags & NFS_SEQID_CONFIRMED)) {
 		if (nfs_wait_on_sequence(data->arg.open_seqid, task) != 0)
-			return;
+			goto out_release_lock_seqid;
 		data->arg.open_stateid = &state->stateid;
 		data->arg.new_lock_owner = 1;
 		data->res.open_seqid = data->arg.open_seqid;
@@ -4511,10 +4516,15 @@ static void nfs4_lock_prepare(struct rpc_task *task, void *calldata)
 	data->timestamp = jiffies;
 	if (nfs4_setup_sequence(data->server,
 				&data->arg.seq_args,
-				&data->res.seq_res, task))
+				&data->res.seq_res,
+				task) == 0) {
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
-- 
1.7.9.5

