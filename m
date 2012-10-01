Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176Ab2JAXdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:33:38 -0400
Received: from 1wt.eu ([62.212.114.60]:35148 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2JAXAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:24 -0400
Message-Id: <20121001225200.236039321@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 062/180] SUNRPC: We must not use list_for_each_entry_safe() in rpc_wake_up()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 540a0f7584169651f485e8ab67461fcb06934e38 upstream.

The problem is that for the case of priority queues, we
have to assume that __rpc_remove_wait_queue_priority will move new
elements from the tk_wait.links lists into the queue->tasks[] list.
We therefore cannot use list_for_each_entry_safe() on queue->tasks[],
since that will skip these new tasks that __rpc_remove_wait_queue_priority
is adding.

Without this fix, rpc_wake_up and rpc_wake_up_status will both fail
to wake up all functions on priority wait queues, which can result
in some nasty hangs.

Reported-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sunrpc/sched.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index ac94477..9b3941d 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -485,14 +485,18 @@ EXPORT_SYMBOL_GPL(rpc_wake_up_next);
  */
 void rpc_wake_up(struct rpc_wait_queue *queue)
 {
-	struct rpc_task *task, *next;
 	struct list_head *head;
 
 	spin_lock_bh(&queue->lock);
 	head = &queue->tasks[queue->maxpriority];
 	for (;;) {
-		list_for_each_entry_safe(task, next, head, u.tk_wait.list)
+		while (!list_empty(head)) {
+			struct rpc_task *task;
+			task = list_first_entry(head,
+					struct rpc_task,
+					u.tk_wait.list);
 			rpc_wake_up_task_queue_locked(queue, task);
+		}
 		if (head == &queue->tasks[0])
 			break;
 		head--;
@@ -510,13 +514,16 @@ EXPORT_SYMBOL_GPL(rpc_wake_up);
  */
 void rpc_wake_up_status(struct rpc_wait_queue *queue, int status)
 {
-	struct rpc_task *task, *next;
 	struct list_head *head;
 
 	spin_lock_bh(&queue->lock);
 	head = &queue->tasks[queue->maxpriority];
 	for (;;) {
-		list_for_each_entry_safe(task, next, head, u.tk_wait.list) {
+		while (!list_empty(head)) {
+			struct rpc_task *task;
+			task = list_first_entry(head,
+					struct rpc_task,
+					u.tk_wait.list);
 			task->tk_status = status;
 			rpc_wake_up_task_queue_locked(queue, task);
 		}
-- 
1.7.2.1.45.g54fbc



