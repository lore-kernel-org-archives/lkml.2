Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033045Ab2I1VRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:17:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45498 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759320Ab2I1Uii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:38 -0400
X-Sasl-enc: Mq+lT17NBCowCOZ3wINR3h75Z9YEzJ8HxZLb1Zv7IG/u 1348864717
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Andy Walls <awalls@md.metrocast.net>,
        Colin Cross <ccross@google.com>
Subject: [ 208/218] kthread_worker: reorganize to prepare for flush_kthread_work() reimplementation
Date: Fri, 28 Sep 2012 13:17:05 -0700
Message-Id: <20120928201525.471387964@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 9a2e03d8ed518a61154f18d83d6466628e519f94 upstream.

Make the following two non-functional changes.

* Separate out insert_kthread_work() from queue_kthread_work().

* Relocate struct kthread_flush_work and kthread_flush_work_fn()
  definitions above flush_kthread_work().

v2: Added lockdep_assert_held() in insert_kthread_work() as suggested
    by Andy Walls.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Andy Walls <awalls@md.metrocast.net>
Cc: Colin Cross <ccross@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kthread.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -378,6 +378,19 @@ repeat:
 }
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
 
+/* insert @work before @pos in @worker */
+static void insert_kthread_work(struct kthread_worker *worker,
+			       struct kthread_work *work,
+			       struct list_head *pos)
+{
+	lockdep_assert_held(&worker->lock);
+
+	list_add_tail(&work->node, pos);
+	work->queue_seq++;
+	if (likely(worker->task))
+		wake_up_process(worker->task);
+}
+
 /**
  * queue_kthread_work - queue a kthread_work
  * @worker: target kthread_worker
@@ -395,10 +408,7 @@ bool queue_kthread_work(struct kthread_w
 
 	spin_lock_irqsave(&worker->lock, flags);
 	if (list_empty(&work->node)) {
-		list_add_tail(&work->node, &worker->work_list);
-		work->queue_seq++;
-		if (likely(worker->task))
-			wake_up_process(worker->task);
+		insert_kthread_work(worker, work, &worker->work_list);
 		ret = true;
 	}
 	spin_unlock_irqrestore(&worker->lock, flags);
@@ -406,6 +416,18 @@ bool queue_kthread_work(struct kthread_w
 }
 EXPORT_SYMBOL_GPL(queue_kthread_work);
 
+struct kthread_flush_work {
+	struct kthread_work	work;
+	struct completion	done;
+};
+
+static void kthread_flush_work_fn(struct kthread_work *work)
+{
+	struct kthread_flush_work *fwork =
+		container_of(work, struct kthread_flush_work, work);
+	complete(&fwork->done);
+}
+
 /**
  * flush_kthread_work - flush a kthread_work
  * @work: work to flush
@@ -436,18 +458,6 @@ void flush_kthread_work(struct kthread_w
 }
 EXPORT_SYMBOL_GPL(flush_kthread_work);
 
-struct kthread_flush_work {
-	struct kthread_work	work;
-	struct completion	done;
-};
-
-static void kthread_flush_work_fn(struct kthread_work *work)
-{
-	struct kthread_flush_work *fwork =
-		container_of(work, struct kthread_flush_work, work);
-	complete(&fwork->done);
-}
-
 /**
  * flush_kthread_worker - flush all current works on a kthread_worker
  * @worker: worker to flush


