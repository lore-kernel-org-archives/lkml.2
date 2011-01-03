Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1ACNuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab1ACNuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=X4hPEIf26NYch90nnJKyWMBXXHudbSE1iPUQtsPCmB6mZRmG3wBWDt15T20o9qQ5nM
         PLK/sho4S1s/sGbKrqYXWkR+MFyJ71UZvYlEaWrUCYL5DIhgVSbq7ndT/C6CYjSE20lH
         fuCRcEV2xQC52vaRzrN/59D3LpeQuKHmElewg=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH 30/32] net/9p: replace p9_poll_task with a work
Date: Mon,  3 Jan 2011 14:49:53 +0100
Message-Id: <1294062595-30097-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cmwq can handle high concurrency, it's more efficient to use
work than a dedicated kthread.  Convert p9_poll_proc() to a work
function for p9_poll_work and make p9_pollwake() schedule it on each
poll event.  The work is sync flushed on module exit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net
---
Lightly tested with userland server.  Seems to work fine.  Please feel
free to take it into the subsystem tree or simply ack - I'll route it
through the wq tree.

Thanks.

 net/9p/trans_fd.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e9f797d..a30471e 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -153,9 +153,11 @@ struct p9_conn {
 	unsigned long wsched;
 };
 
+static void p9_poll_workfn(struct work_struct *work);
+
 static DEFINE_SPINLOCK(p9_poll_lock);
 static LIST_HEAD(p9_poll_pending_list);
-static struct task_struct *p9_poll_task;
+static DECLARE_WORK(p9_poll_work, p9_poll_workfn);
 
 static void p9_mux_poll_stop(struct p9_conn *m)
 {
@@ -515,15 +517,14 @@ static int p9_pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
 		container_of(wait, struct p9_poll_wait, wait);
 	struct p9_conn *m = pwait->conn;
 	unsigned long flags;
-	DECLARE_WAITQUEUE(dummy_wait, p9_poll_task);
 
 	spin_lock_irqsave(&p9_poll_lock, flags);
 	if (list_empty(&m->poll_pending_link))
 		list_add_tail(&m->poll_pending_link, &p9_poll_pending_list);
 	spin_unlock_irqrestore(&p9_poll_lock, flags);
 
-	/* perform the default wake up operation */
-	return default_wake_function(&dummy_wait, mode, sync, key);
+	schedule_work(&p9_poll_work);
+	return 1;
 }
 
 /**
@@ -1046,12 +1047,12 @@ static struct p9_trans_module p9_fd_trans = {
  *
  */
 
-static int p9_poll_proc(void *a)
+static void p9_poll_workfn(struct work_struct *work)
 {
 	unsigned long flags;
 
 	P9_DPRINTK(P9_DEBUG_TRANS, "start %p\n", current);
- repeat:
+
 	spin_lock_irqsave(&p9_poll_lock, flags);
 	while (!list_empty(&p9_poll_pending_list)) {
 		struct p9_conn *conn = list_first_entry(&p9_poll_pending_list,
@@ -1066,28 +1067,11 @@ static int p9_poll_proc(void *a)
 	}
 	spin_unlock_irqrestore(&p9_poll_lock, flags);
 
-	set_current_state(TASK_INTERRUPTIBLE);
-	if (list_empty(&p9_poll_pending_list)) {
-		P9_DPRINTK(P9_DEBUG_TRANS, "sleeping...\n");
-		schedule();
-	}
-	__set_current_state(TASK_RUNNING);
-
-	if (!kthread_should_stop())
-		goto repeat;
-
 	P9_DPRINTK(P9_DEBUG_TRANS, "finish\n");
-	return 0;
 }
 
 int p9_trans_fd_init(void)
 {
-	p9_poll_task = kthread_run(p9_poll_proc, NULL, "v9fs-poll");
-	if (IS_ERR(p9_poll_task)) {
-		printk(KERN_WARNING "v9fs: mux: creating poll task failed\n");
-		return PTR_ERR(p9_poll_task);
-	}
-
 	v9fs_register_trans(&p9_tcp_trans);
 	v9fs_register_trans(&p9_unix_trans);
 	v9fs_register_trans(&p9_fd_trans);
@@ -1097,7 +1081,7 @@ int p9_trans_fd_init(void)
 
 void p9_trans_fd_exit(void)
 {
-	kthread_stop(p9_poll_task);
+	flush_work_sync(&p9_poll_work);
 	v9fs_unregister_trans(&p9_tcp_trans);
 	v9fs_unregister_trans(&p9_unix_trans);
 	v9fs_unregister_trans(&p9_fd_trans);
-- 
1.7.1

