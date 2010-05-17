Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0EQTDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:11713 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab0EQTC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="518662465"
Message-Id: <20100517184027.777058425@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:29 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 3/7] softirq: avoid softirq_work_list for SCHED_SOFTIRQ when sent remotely
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_local_trigger_remote_softirq_for_sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to add the SCHED_SOFTIRQ work to the softirq_work_list
when sent remotely. This is because any pending work associated with
SCHED_SOFTIRQ need not be migrated to a new cpu when the current cpu is
going down etc.

Also I am not sure how this softirq_work_list works for other softirqs.
I don't see anyone removing the list entries from the softirq_work_list
after it is handled on a remote cpu.

For now, just skip it for SCHED_SOFTIRQ.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 kernel/softirq.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: tip/kernel/softirq.c
===================================================================
--- tip.orig/kernel/softirq.c
+++ tip/kernel/softirq.c
@@ -557,6 +557,11 @@ static void __local_trigger(struct call_
 {
 	struct list_head *head = &__get_cpu_var(softirq_work_list[softirq]);
 
+	if (softirq == SCHED_SOFTIRQ) {
+		raise_softirq_irqoff(softirq);
+		return;
+	}
+
 	list_add_tail(&cp->list, head);
 
 	/* Trigger the softirq only if the list was previously empty.  */


