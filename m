Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab2JKBSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:18:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41535 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933485Ab2JKBSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:18:17 -0400
X-Sasl-enc: NKsnqB6OnpJzQJlfcq0PxftPm5dR5UnQcjkKqBdzqLs8 1349918295
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [ 019/120] workqueue: add missing smp_wmb() in process_one_work()
Date: Thu, 11 Oct 2012 09:59:31 +0900
Message-Id: <20121011005828.843920153@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1864,7 +1864,9 @@ __acquires(&gcwq->lock)
 
 	spin_unlock_irq(&gcwq->lock);
 
+	smp_wmb();	/* paired with test_and_set_bit(PENDING) */
 	work_clear_pending(work);
+
 	lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);


