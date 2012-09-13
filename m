Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2IMOmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:42:53 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58735 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2IMOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:42:52 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/2] perf,
 cpu hotplug: Run CPU_STARTING notifiers with irqs disabled
To: a.p.zijlstra@chello.nl, acme@infradead.org
Cc: mingo@kernel.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 20:12:20 +0530
Message-ID: <20120913144220.3426.22392.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12091314-5564-0000-0000-000004734236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_STARTING notifiers are supposed to be run with irqs disabled. But the
perf_cpu_notifier() macro invokes them without doing that. Fix it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/perf_event.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7602ccb..cc4574d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1346,10 +1346,13 @@ static inline void perf_event_task_tick(void)				{ }
 do {									\
 	static struct notifier_block fn##_nb __cpuinitdata =		\
 		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+	unsigned long flags;						\
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
 		(void *)(unsigned long)smp_processor_id());		\
+	local_irq_save(flags);						\
 	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
 		(void *)(unsigned long)smp_processor_id());		\
+	local_irq_restore(flags);					\
 	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
 		(void *)(unsigned long)smp_processor_id());		\
 	register_cpu_notifier(&fn##_nb);				\

