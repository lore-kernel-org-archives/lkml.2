Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2BEW0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:38 -0500
Received: from 1wt.eu ([62.212.114.60]:61951 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab2BEW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:31 -0500
Message-Id: <20120205220951.588883629@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 50/91] NLM: Dont hang forever on NLM unlock requests
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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

Index: longterm-2.6.27/fs/lockd/clntproc.c
===================================================================
--- longterm-2.6.27.orig/fs/lockd/clntproc.c	2012-02-05 22:34:33.509914670 +0100
+++ longterm-2.6.27/fs/lockd/clntproc.c	2012-02-05 22:34:41.942915002 +0100
@@ -709,7 +709,13 @@
 
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
Index: longterm-2.6.27/include/linux/sunrpc/sched.h
===================================================================
--- longterm-2.6.27.orig/include/linux/sunrpc/sched.h	2012-02-05 22:34:33.497915064 +0100
+++ longterm-2.6.27/include/linux/sunrpc/sched.h	2012-02-05 22:34:41.949914805 +0100
@@ -84,8 +84,8 @@
 	long			tk_rtt;		/* round-trip time (jiffies) */
 
 	pid_t			tk_owner;	/* Process id for batching tasks */
-	unsigned char		tk_priority : 2;/* Task priority */
-
+	unsigned char		tk_priority : 2,/* Task priority */
+				tk_rebind_retry : 2;
 #ifdef RPC_DEBUG
 	unsigned short		tk_pid;		/* debugging aid */
 #endif
Index: longterm-2.6.27/net/sunrpc/clnt.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/clnt.c	2012-02-05 22:34:33.501914879 +0100
+++ longterm-2.6.27/net/sunrpc/clnt.c	2012-02-05 22:34:41.957914825 +0100
@@ -955,6 +955,9 @@
 			status = -EOPNOTSUPP;
 			break;
 		}
+		if (task->tk_rebind_retry == 0)
+			break;
+		task->tk_rebind_retry--;
 		rpc_delay(task, 3*HZ);
 		goto retry_timeout;
 	case -ETIMEDOUT:
Index: longterm-2.6.27/net/sunrpc/sched.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/sched.c	2012-02-05 22:34:33.505915115 +0100
+++ longterm-2.6.27/net/sunrpc/sched.c	2012-02-05 22:34:41.963916236 +0100
@@ -786,6 +786,7 @@
 	/* Initialize retry counters */
 	task->tk_garb_retry = 2;
 	task->tk_cred_retry = 2;
+	task->tk_rebind_retry = 2;
 
 	task->tk_priority = task_setup_data->priority - RPC_PRIORITY_LOW;
 	task->tk_owner = current->tgid;


