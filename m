Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1KCCEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:04:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787Ab1KCBhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.374536054@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [101/107] NLM: Dont hang forever on NLM unlock requests
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0b760113a3a155269a3fba93a409c640031dd68f upstream.

If the NLM daemon is killed on the NFS server, we can currently end up
hanging forever on an 'unlock' request, instead of aborting. Basically,
if the rpcbind request fails, or the server keeps returning garbage, we
really want to quit instead of retrying.

Tested-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/lockd/clntproc.c          |    8 +++++++-
 include/linux/sunrpc/sched.h |    4 ++--
 net/sunrpc/clnt.c            |    3 +++
 net/sunrpc/sched.c           |    1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -709,7 +709,13 @@ static void nlmclnt_unlock_callback(stru
 
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
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -84,8 +84,8 @@ struct rpc_task {
 	long			tk_rtt;		/* round-trip time (jiffies) */
 
 	pid_t			tk_owner;	/* Process id for batching tasks */
-	unsigned char		tk_priority : 2;/* Task priority */
-
+	unsigned char		tk_priority : 2,/* Task priority */
+				tk_rebind_retry : 2;
 #ifdef RPC_DEBUG
 	unsigned short		tk_pid;		/* debugging aid */
 #endif
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1052,6 +1052,9 @@ call_bind_status(struct rpc_task *task)
 			status = -EOPNOTSUPP;
 			break;
 		}
+		if (task->tk_rebind_retry == 0)
+			break;
+		task->tk_rebind_retry--;
 		rpc_delay(task, 3*HZ);
 		goto retry_timeout;
 	case -ETIMEDOUT:
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -784,6 +784,7 @@ static void rpc_init_task(struct rpc_tas
 	/* Initialize retry counters */
 	task->tk_garb_retry = 2;
 	task->tk_cred_retry = 2;
+	task->tk_rebind_retry = 2;
 
 	task->tk_priority = task_setup_data->priority - RPC_PRIORITY_LOW;
 	task->tk_owner = current->tgid;


