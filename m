Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab2KOEVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:21:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:49814 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992814Ab2KOEMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 25/57] NFSv4.1: We must release the sequence id when we fail to get a session slot
Date: Wed, 14 Nov 2012 20:11:33 -0800
Message-Id: <20121115040934.783907749@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2240a9e2d013d8269ea425b73e1d7a54c7bc141f upstream.

If we do not release the sequence id in cases where we fail to get a
session slot, then we can deadlock if we hit a recovery scenario.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1478,9 +1478,11 @@ static void nfs4_open_prepare(struct rpc
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
@@ -2097,9 +2099,10 @@ static void nfs4_close_prepare(struct rp
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
@@ -4323,9 +4326,11 @@ static void nfs4_locku_prepare(struct rp
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
@@ -4470,7 +4475,7 @@ static void nfs4_lock_prepare(struct rpc
 	/* Do we need to do an open_to_lock_owner? */
 	if (!(data->arg.lock_seqid->sequence->flags & NFS_SEQID_CONFIRMED)) {
 		if (nfs_wait_on_sequence(data->arg.open_seqid, task) != 0)
-			return;
+			goto out_release_lock_seqid;
 		data->arg.open_stateid = &state->stateid;
 		data->arg.new_lock_owner = 1;
 		data->res.open_seqid = data->arg.open_seqid;
@@ -4479,10 +4484,15 @@ static void nfs4_lock_prepare(struct rpc
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


