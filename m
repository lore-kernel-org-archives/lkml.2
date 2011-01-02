Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1ABHXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:35383 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1ABHXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 103/260] SUNRPC: Fix race corrupting rpc upcall
Date: Sun,  2 Jan 2011 02:16:39 -0500
Message-Id: <1293952756-15010-104-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:02.0868 (UTC) FILETIME=[C07AFB40:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5a67657a2e90c9e4a48518f95d4ba7777aa20fbb upstream.

If rpc_queue_upcall() adds a new upcall to the rpci->pipe list just
after rpc_pipe_release calls rpc_purge_list(), but before it calls
gss_pipe_release (as rpci->ops->release_pipe(inode)), then the latter
will free a message without deleting it from the rpci->pipe list.

We will be left with a freed object on the rpc->pipe list.  Most
frequent symptoms are kernel crashes in rpc.gssd system calls on the
pipe in question.

Reported-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/auth_gss/auth_gss.c |    9 +++++----
 net/sunrpc/rpc_pipe.c          |    6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index c389ccf..c369ea6 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -724,17 +724,18 @@ gss_pipe_release(struct inode *inode)
 	struct rpc_inode *rpci = RPC_I(inode);
 	struct gss_upcall_msg *gss_msg;
 
+restart:
 	spin_lock(&inode->i_lock);
-	while (!list_empty(&rpci->in_downcall)) {
+	list_for_each_entry(gss_msg, &rpci->in_downcall, list) {
 
-		gss_msg = list_entry(rpci->in_downcall.next,
-				struct gss_upcall_msg, list);
+		if (!list_empty(&gss_msg->msg.list))
+			continue;
 		gss_msg->msg.errno = -EPIPE;
 		atomic_inc(&gss_msg->count);
 		__gss_unhash_msg(gss_msg);
 		spin_unlock(&inode->i_lock);
 		gss_release_msg(gss_msg);
-		spin_lock(&inode->i_lock);
+		goto restart;
 	}
 	spin_unlock(&inode->i_lock);
 
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 20e30c6..dbf50f9 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -47,7 +47,7 @@ static void rpc_purge_list(struct rpc_inode *rpci, struct list_head *head,
 		return;
 	do {
 		msg = list_entry(head->next, struct rpc_pipe_msg, list);
-		list_del(&msg->list);
+		list_del_init(&msg->list);
 		msg->errno = err;
 		destroy_msg(msg);
 	} while (!list_empty(head));
@@ -207,7 +207,7 @@ rpc_pipe_release(struct inode *inode, struct file *filp)
 	if (msg != NULL) {
 		spin_lock(&inode->i_lock);
 		msg->errno = -EAGAIN;
-		list_del(&msg->list);
+		list_del_init(&msg->list);
 		spin_unlock(&inode->i_lock);
 		rpci->ops->destroy_msg(msg);
 	}
@@ -267,7 +267,7 @@ rpc_pipe_read(struct file *filp, char __user *buf, size_t len, loff_t *offset)
 	if (res < 0 || msg->len == msg->copied) {
 		filp->private_data = NULL;
 		spin_lock(&inode->i_lock);
-		list_del(&msg->list);
+		list_del_init(&msg->list);
 		spin_unlock(&inode->i_lock);
 		rpci->ops->destroy_msg(msg);
 	}
-- 
1.7.3.3

