Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2GVQnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 12:43:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63465 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2GVQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 12:43:33 -0400
Date: Sun, 22 Jul 2012 09:43:27 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] workqueue: fix spurious CPU locality WARN from
 process_one_work()
Message-ID: <20120722164327.GA5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342545149-3515-2-git-send-email-tj@kernel.org>
 <20120720215207.GA18841@linux.vnet.ibm.com>
 <20120720215835.GB6823@google.com>
 <20120721213656.GA7783@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120721213656.GA7783@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25511a4776 "workqueue: reimplement CPU online rebinding to handle idle
workers" added CPU locality sanity check in process_one_work().  It
triggers if a worker is executing on a different CPU without UNBOUND
or REBIND set.

This works for all normal workers but rescuers can trigger this
spuriously when they're serving the unbound or a disassociated
global_cwq - rescuers don't have either flag set and thus its
gcwq->cpu can be a different value including %WORK_CPU_UNBOUND.

Fix it by additionally testing %GCWQ_DISASSOCIATED.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
LKML-Refence: <20120721213656.GA7783@linux.vnet.ibm.com>
---
This should fix it.  Will queue it on wq/for-3.6.

Thanks!

 kernel/workqueue.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1949,7 +1949,13 @@ __acquires(&gcwq->lock)
 
 	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
+	/*
+	 * Ensure we're on the correct CPU.  DISASSOCIATED test is
+	 * necessary to avoid spurious warnings from rescuers servicing the
+	 * unbound or a disassociated gcwq.
+	 */
 	WARN_ON_ONCE(!(worker->flags & (WORKER_UNBOUND | WORKER_REBIND)) &&
+		     !(gcwq->flags & GCWQ_DISASSOCIATED) &&
 		     raw_smp_processor_id() != gcwq->cpu);
 
 	/*
