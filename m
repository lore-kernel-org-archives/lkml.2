Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1ACNvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:51:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1ACNuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NpDq/J0eEYjOlovKcMN5WXGowesR/ZfQkq7YDPEgJsZNioGkxuwBG9oWi9uFmTEXLK
         vu4UfGXVPfBUzmbAmH8veczjNRQuKHejOapzrVy4NhlMq/lEol7AuQZ0vidoQ8nKRewm
         1SBdFl3bm/wT1iURs9muCz5OwvBYZGi6LoizU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH 29/32] net/9p: use system_wq instead of p9_mux_wq
Date: Mon,  3 Jan 2011 14:49:52 +0100
Message-Id: <1294062595-30097-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use a dedicated workqueue in trans_fd.
Drop p9_mux_wq and use system_wq instead.  The used work items are
already sync canceled in p9_conn_destroy() and doesn't require further
synchronization.

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

 net/9p/trans_fd.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 078eb16..e9f797d 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -155,7 +155,6 @@ struct p9_conn {
 
 static DEFINE_SPINLOCK(p9_poll_lock);
 static LIST_HEAD(p9_poll_pending_list);
-static struct workqueue_struct *p9_mux_wq;
 static struct task_struct *p9_poll_task;
 
 static void p9_mux_poll_stop(struct p9_conn *m)
@@ -384,7 +383,7 @@ static void p9_read_work(struct work_struct *work)
 
 		if (n & POLLIN) {
 			P9_DPRINTK(P9_DEBUG_TRANS, "sched read work %p\n", m);
-			queue_work(p9_mux_wq, &m->rq);
+			schedule_work(&m->rq);
 		} else
 			clear_bit(Rworksched, &m->wsched);
 	} else
@@ -497,7 +496,7 @@ static void p9_write_work(struct work_struct *work)
 
 		if (n & POLLOUT) {
 			P9_DPRINTK(P9_DEBUG_TRANS, "sched write work %p\n", m);
-			queue_work(p9_mux_wq, &m->wq);
+			schedule_work(&m->wq);
 		} else
 			clear_bit(Wworksched, &m->wsched);
 	} else
@@ -629,7 +628,7 @@ static void p9_poll_mux(struct p9_conn *m)
 		P9_DPRINTK(P9_DEBUG_TRANS, "mux %p can read\n", m);
 		if (!test_and_set_bit(Rworksched, &m->wsched)) {
 			P9_DPRINTK(P9_DEBUG_TRANS, "sched read work %p\n", m);
-			queue_work(p9_mux_wq, &m->rq);
+			schedule_work(&m->rq);
 		}
 	}
 
@@ -639,7 +638,7 @@ static void p9_poll_mux(struct p9_conn *m)
 		if ((m->wsize || !list_empty(&m->unsent_req_list)) &&
 		    !test_and_set_bit(Wworksched, &m->wsched)) {
 			P9_DPRINTK(P9_DEBUG_TRANS, "sched write work %p\n", m);
-			queue_work(p9_mux_wq, &m->wq);
+			schedule_work(&m->wq);
 		}
 	}
 }
@@ -677,7 +676,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 		n = p9_fd_poll(m->client, NULL);
 
 	if (n & POLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		queue_work(p9_mux_wq, &m->wq);
+		schedule_work(&m->wq);
 
 	return 0;
 }
@@ -1083,15 +1082,8 @@ static int p9_poll_proc(void *a)
 
 int p9_trans_fd_init(void)
 {
-	p9_mux_wq = create_workqueue("v9fs");
-	if (!p9_mux_wq) {
-		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
-		return -ENOMEM;
-	}
-
 	p9_poll_task = kthread_run(p9_poll_proc, NULL, "v9fs-poll");
 	if (IS_ERR(p9_poll_task)) {
-		destroy_workqueue(p9_mux_wq);
 		printk(KERN_WARNING "v9fs: mux: creating poll task failed\n");
 		return PTR_ERR(p9_poll_task);
 	}
@@ -1109,6 +1101,4 @@ void p9_trans_fd_exit(void)
 	v9fs_unregister_trans(&p9_tcp_trans);
 	v9fs_unregister_trans(&p9_unix_trans);
 	v9fs_unregister_trans(&p9_fd_trans);
-
-	destroy_workqueue(p9_mux_wq);
 }
-- 
1.7.1

