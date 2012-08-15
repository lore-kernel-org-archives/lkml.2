Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2HOTvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:46 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63016 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2HOTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 101/165] NLM: Don't hang forever on NLM unlock requests
Date: Wed, 15 Aug 2012 15:47:25 -0400
Message-ID: <1345060109-9187-102-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0b760113a3a155269a3fba93a409c640031dd68f upstream.

If the NLM daemon is killed on the NFS server, we can currently end up
hanging forever on an 'unlock' request, instead of aborting. Basically,
if the rpcbind request fails, or the server keeps returning garbage, we
really want to quit instead of retrying.

Tested-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[PG: struct rpc_task in sched.h slightly different layout vs. v3.0]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/lockd/clntproc.c          | 8 +++++++-
 include/linux/sunrpc/sched.h | 1 +
 net/sunrpc/clnt.c            | 3 +++
 net/sunrpc/sched.c           | 1 +
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 7932c39..f4ef9d1 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -710,7 +710,13 @@ static void nlmclnt_unlock_callback(struct rpc_task *task, void *data)
 
 	if (task->tk_status < 0) {
 		dprintk("lockd: unlock failed (err = %d)\n", -task->tk_status);
-		goto retry_rebind;
+		switch (task->tk_status) {
+		case -EACCES:
+		case -EIO:
+			goto die;
+		default:
+			goto retry_rebind;
+		}
 	}
 	if (status == NLM_LCK_DENIED_GRACE_PERIOD) {
 		rpc_delay(task, NLMCLNT_GRACE_WAIT);
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 7bc7fd5..f2338ca 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -55,6 +55,7 @@ struct rpc_task {
 	struct rpc_message	tk_msg;		/* RPC call info */
 	__u8			tk_garb_retry;
 	__u8			tk_cred_retry;
+	__u8			tk_rebind_retry;
 
 	/*
 	 * callback	to be executed after waking up
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 0ad7828..018903c 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1053,6 +1053,9 @@ call_bind_status(struct rpc_task *task)
 			status = -EOPNOTSUPP;
 			break;
 		}
+		if (task->tk_rebind_retry == 0)
+			break;
+		task->tk_rebind_retry--;
 		rpc_delay(task, 3*HZ);
 		goto retry_timeout;
 	case -ETIMEDOUT:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 416ca5e..e961e06 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -799,6 +799,7 @@ static void rpc_init_task(struct rpc_task *task, const struct rpc_task_setup *ta
 	/* Initialize retry counters */
 	task->tk_garb_retry = 2;
 	task->tk_cred_retry = 2;
+	task->tk_rebind_retry = 2;
 
 	task->tk_priority = task_setup_data->priority - RPC_PRIORITY_LOW;
 	task->tk_owner = current->tgid;
-- 
1.7.12.rc2

