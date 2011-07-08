Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1GIF4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:56:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49420 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab1GIFyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:45 -0400
X-Sasl-enc: HQOO3d/2YG9Cu1p/BCOYASir0zcKN2zsJnd6HpUjeJPK 1310190884
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:20 2011
Message-Id: <20110708225120.574167530@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:50:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [18/35] SUNRPC: Ensure the RPC client only quits on fatal signals
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5afa9133cfe67f1bfead6049a9640c9262a7101c upstream.

Fix a couple of instances where we were exiting the RPC client on
arbitrary signals. We should only do so on fatal signals.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_gss/auth_gss.c |    4 ++--
 net/sunrpc/clnt.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -548,13 +548,13 @@ retry:
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
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -938,7 +938,7 @@ call_allocate(struct rpc_task *task)
 
 	dprintk("RPC: %5u rpc_buffer allocation failed\n", task->tk_pid);
 
-	if (RPC_IS_ASYNC(task) || !signalled()) {
+	if (RPC_IS_ASYNC(task) || !fatal_signal_pending(current)) {
 		task->tk_action = call_allocate;
 		rpc_delay(task, HZ>>4);
 		return;


