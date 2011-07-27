Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1G0VyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:54:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:39002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab1G0VtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30901046"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [81/99] SUNRPC: Ensure the RPC client only quits on fatal signals
Message-Id: <20110727214920.BD3162403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5afa9133cfe67f1bfead6049a9640c9262a7101c upstream.

Fix a couple of instances where we were exiting the RPC client on
arbitrary signals. We should only do so on fatal signals.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sunrpc/auth_gss/auth_gss.c |    4 ++--
 net/sunrpc/clnt.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/net/sunrpc/auth_gss/auth_gss.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/auth_gss/auth_gss.c
+++ linux-2.6.35.y/net/sunrpc/auth_gss/auth_gss.c
@@ -575,13 +575,13 @@ retry:
 	}
 	inode = &gss_msg->inode->vfs_inode;
 	for (;;) {
-		prepare_to_wait(&gss_msg->waitqueue, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&gss_msg->waitqueue, &wait, TASK_KILLABLE);
 		spin_lock(&inode->i_lock);
 		if (gss_msg->ctx != NULL || gss_msg->msg.errno < 0) {
 			break;
 		}
 		spin_unlock(&inode->i_lock);
-		if (signalled()) {
+		if (fatal_signal_pending(current)) {
 			err = -ERESTARTSYS;
 			goto out_intr;
 		}
Index: linux-2.6.35.y/net/sunrpc/clnt.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/clnt.c
+++ linux-2.6.35.y/net/sunrpc/clnt.c
@@ -928,7 +928,7 @@ call_allocate(struct rpc_task *task)
 
 	dprintk("RPC: %5u rpc_buffer allocation failed\n", task->tk_pid);
 
-	if (RPC_IS_ASYNC(task) || !signalled()) {
+	if (RPC_IS_ASYNC(task) || !fatal_signal_pending(current)) {
 		task->tk_action = call_allocate;
 		rpc_delay(task, HZ>>4);
 		return;
