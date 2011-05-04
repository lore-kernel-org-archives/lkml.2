Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1EDBr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 21:47:59 -0400
Received: from ozlabs.org ([203.10.76.45]:58611 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1EDBr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 21:47:59 -0400
Date: Wed, 4 May 2011 11:47:49 +1000
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] workqueue: Don't spin forever in worker_maybe_bind_and_lock
Message-ID: <20110504014749.GA28337@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 48-thread POWER7 box, I often see the system hang when offlining
processors.  What happens is that we get a rescuer thread trying to
move to some processor at the same time that a cpu offline operation
is happening for that processor, and we end up with one cpu spinning in
worker_maybe_bind_and_lock() and all of the rest of the online cpus
spinning inside the stop_machine code.  The rescuer thread is
continually calling set_cpus_allowed_ptr() which is continually
failing because the cpu it is trying to move to is no longer in the
cpu_active_mask.  The result is a deadlock.

This fixes worker_maybe_bind_and_lock so that it stops trying to move
to a cpu if that cpu is no longer in the cpu_active_mask, and instead
returns to its caller.  With this I no longer see the deadlocks when
offlining cpus.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/workqueue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8859a41..12faf78 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1289,6 +1289,8 @@ __acquires(&gcwq->lock)
 		    cpumask_equal(&current->cpus_allowed,
 				  get_cpu_mask(gcwq->cpu)))
 			return true;
+		if (!cpumask_test_cpu(gcwq->cpu, cpu_active_mask))
+			return false;
 		spin_unlock_irq(&gcwq->lock);
 
 		/* CPU has come up in between, retry migration */
-- 
1.7.4.1

