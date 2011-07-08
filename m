Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1GHFJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:09:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1GHFFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.209814034@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [087/107] SUNRPC: Ensure the RPC client only quits on fatal signals
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -577,13 +577,13 @@ retry:
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
@@ -1058,7 +1058,7 @@ call_allocate(struct rpc_task *task)
 
 	dprintk("RPC: %5u rpc_buffer allocation failed\n", task->tk_pid);
 
-	if (RPC_IS_ASYNC(task) || !signalled()) {
+	if (RPC_IS_ASYNC(task) || !fatal_signal_pending(current)) {
 		task->tk_action = call_allocate;
 		rpc_delay(task, HZ>>4);
 		return;


