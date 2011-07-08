Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1GHFFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab1GHFFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.153491172@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [097/107] NLM: Dont hang forever on NLM unlock requests
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
 include/linux/sunrpc/sched.h |    3 ++-
 net/sunrpc/clnt.c            |    3 +++
 net/sunrpc/sched.c           |    1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -708,7 +708,13 @@ static void nlmclnt_unlock_callback(stru
 
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
@@ -84,7 +84,8 @@ struct rpc_task {
 #endif
 	unsigned char		tk_priority : 2,/* Task priority */
 				tk_garb_retry : 2,
-				tk_cred_retry : 2;
+				tk_cred_retry : 2,
+				tk_rebind_retry : 2;
 };
 #define tk_xprt			tk_client->cl_xprt
 
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1172,6 +1172,9 @@ call_bind_status(struct rpc_task *task)
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
@@ -792,6 +792,7 @@ static void rpc_init_task(struct rpc_tas
 	/* Initialize retry counters */
 	task->tk_garb_retry = 2;
 	task->tk_cred_retry = 2;
+	task->tk_rebind_retry = 2;
 
 	task->tk_priority = task_setup_data->priority - RPC_PRIORITY_LOW;
 	task->tk_owner = current->tgid;


