Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2G0Xza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2G0XzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:22 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 03/15] workqueue: add missing smp_wmb() in process_one_work()
Date: Fri, 27 Jul 2012 16:54:56 -0700
Message-Id: <1343433308-26614-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
 kernel/workqueue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
-- 
1.7.7.3

