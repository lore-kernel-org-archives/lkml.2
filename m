Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2JPH72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:59:28 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47269 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2JPH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:59:26 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RESEND PATCH 1/2] perf,
 cpu hotplug: Run CPU_STARTING notifiers with irqs disabled
To: peterz@infradead.org, acme@ghostprotocols.net
Cc: mingo@kernel.org, tglx@linutronix.de, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2012 13:28:10 +0530
Message-ID: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101607-3568-0000-0000-0000029AC087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_STARTING notifiers are supposed to be run with irqs disabled. But the
perf_cpu_notifier() macro invokes them without doing that. Fix it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/perf_event.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e90235..0647805 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -803,10 +803,13 @@ static inline void perf_event_task_tick(void)				{ }
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

