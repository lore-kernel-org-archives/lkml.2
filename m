Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab2FGERX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:17:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650Ab2FGERS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:18 -0400
Message-Id: <20120607040340.070901128@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:01 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 25/82] sunrpc: fix loss of task->tk_status after rpc_delay call in xprt_alloc_slot
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1afeaf5c29aa07db25760d2fbed5c08a3aec3498 upstream.

xprt_alloc_slot will call rpc_delay() to make the task wait a bit before
retrying when it gets back an -ENOMEM error from xprt_dynamic_alloc_slot.
The problem is that rpc_delay will clear the task->tk_status, causing
call_reserveresult to abort the task.

The solution is simply to let call_reserveresult handle the ENOMEM error
directly.

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    2 ++
 net/sunrpc/xprt.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1288,6 +1288,8 @@ call_reserveresult(struct rpc_task *task
 	}
 
 	switch (status) {
+	case -ENOMEM:
+		rpc_delay(task, HZ >> 2);
 	case -EAGAIN:	/* woken up; retry */
 		task->tk_action = call_reserve;
 		return;
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -984,15 +984,16 @@ static void xprt_alloc_slot(struct rpc_t
 		goto out_init_req;
 	switch (PTR_ERR(req)) {
 	case -ENOMEM:
-		rpc_delay(task, HZ >> 2);
 		dprintk("RPC:       dynamic allocation of request slot "
 				"failed! Retrying\n");
+		task->tk_status = -ENOMEM;
 		break;
 	case -EAGAIN:
 		rpc_sleep_on(&xprt->backlog, task, NULL);
 		dprintk("RPC:       waiting for request slot\n");
+	default:
+		task->tk_status = -EAGAIN;
 	}
-	task->tk_status = -EAGAIN;
 	return;
 out_init_req:
 	task->tk_status = 0;


