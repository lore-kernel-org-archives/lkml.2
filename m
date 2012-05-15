Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965846Ab2EOCxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:53:17 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53365 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965083Ab2EOCRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 092/179] SUNRPC: Ensure the RPC client only quits on fatal signals
Date: Mon, 14 May 2012 22:13:08 -0400
Message-ID: <1337048075-6132-93-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
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

commit 5afa9133cfe67f1bfead6049a9640c9262a7101c upstream.

Fix a couple of instances where we were exiting the RPC client on
arbitrary signals. We should only do so on fatal signals.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/auth_gss/auth_gss.c |    4 ++--
 net/sunrpc/clnt.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index c369ea6..891b59e 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -554,13 +554,13 @@ retry:
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
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 19c9983..0ad7828 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -939,7 +939,7 @@ call_allocate(struct rpc_task *task)
 
 	dprintk("RPC: %5u rpc_buffer allocation failed\n", task->tk_pid);
 
-	if (RPC_IS_ASYNC(task) || !signalled()) {
+	if (RPC_IS_ASYNC(task) || !fatal_signal_pending(current)) {
 		task->tk_action = call_allocate;
 		rpc_delay(task, HZ>>4);
 		return;
-- 
1.7.9.6

