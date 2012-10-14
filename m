Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab2JNPQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:16:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46055 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab2JNOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:37 -0400
Message-Id: <20121014143534.349379563@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [ 004/147] workqueue: add missing smp_wmb() in process_one_work()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 959d1af8cffc8fd38ed53e8be1cf4ab8782f9c00 upstream.

WORK_STRUCT_PENDING is used to claim ownership of a work item and
process_one_work() releases it before starting execution.  When
someone else grabs PENDING, all pre-release updates to the work item
should be visible and all updates made by the new owner should happen
afterwards.

Grabbing PENDING uses test_and_set_bit() and thus has a full barrier;
however, clearing doesn't have a matching wmb.  Given the preceding
spin_unlock and use of clear_bit, I don't believe this can be a
problem on an actual machine and there hasn't been any related report
but it still is theretically possible for clear_pending to permeate
upwards and happen before work->entry update.

Add an explicit smp_wmb() before work_clear_pending().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 70f95ab..5c26d36 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1997,7 +1997,9 @@ __acquires(&gcwq->lock)
 
 	spin_unlock_irq(&gcwq->lock);
 
+	smp_wmb();	/* paired with test_and_set_bit(PENDING) */
 	work_clear_pending(work);
+
 	lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);


