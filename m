Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2GVRWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 13:22:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2GVRWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 13:22:38 -0400
Date: Sun, 22 Jul 2012 10:22:32 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH UPDATED 1/2] kthread_worker: reorganize to prepare for
 flush_kthread_work() reimplementation
Message-ID: <20120722172232.GD5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120719211510.GA32763@google.com>
 <20120719211541.GB32763@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719211541.GB32763@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9a2e03d8ed518a61154f18d83d6466628e519f94 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 19 Jul 2012 13:52:53 -0700

Make the following two non-functional changes.

* Separate out insert_kthread_work() from queue_kthread_work().

* Relocate struct kthread_flush_work and kthread_flush_work_fn()
  definitions above flush_kthread_work().

v2: Added lockdep_assert_held() in insert_kthread_work() as suggested
    by Andy Walls.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Andy Walls <awalls@md.metrocast.net>
---
 kernel/kthread.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3d3de63..4bfbff3 100644
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
@@ -395,10 +408,7 @@ bool queue_kthread_work(struct kthread_worker *worker,
 
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
@@ -406,6 +416,18 @@ bool queue_kthread_work(struct kthread_worker *worker,
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
@@ -436,18 +458,6 @@ void flush_kthread_work(struct kthread_work *work)
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
-- 
1.7.7.3

