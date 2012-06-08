Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab2FHF2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:28:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43142 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759793Ab2FHFHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:13 -0400
Message-Id: <20120608041841.444215172@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: [ 04/82] sunrpc: fix loss of task->tk_status after rpc_delay call in
 xprt_alloc_slot
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/clnt.c |    2 ++
 net/sunrpc/xprt.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index adf2990..25302c8 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1288,6 +1288,8 @@ call_reserveresult(struct rpc_task *task)
 	}
 
 	switch (status) {
+	case -ENOMEM:
+		rpc_delay(task, HZ >> 2);
 	case -EAGAIN:	/* woken up; retry */
 		task->tk_action = call_reserve;
 		return;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index b239e75..d7ccd79 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -984,15 +984,16 @@ static void xprt_alloc_slot(struct rpc_task *task)
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


