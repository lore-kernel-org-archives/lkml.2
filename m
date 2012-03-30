Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935268Ab2C3Wot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:44:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46402 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935152Ab2C3VHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:07 -0400
Message-Id: <20120330195732.373710092@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 071/108] SUNRPC: We must not use list_for_each_entry_safe() in rpc_wake_up()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 net/sunrpc/sched.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -480,14 +480,18 @@ EXPORT_SYMBOL_GPL(rpc_wake_up_next);
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
@@ -505,13 +509,16 @@ EXPORT_SYMBOL_GPL(rpc_wake_up);
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


