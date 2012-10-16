Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2JPH7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:59:35 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44493 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2JPH7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:59:33 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RESEND PATCH 2/2] perf,
 cpu hotplug: Use cached value of smp_processor_id()
To: peterz@infradead.org, acme@ghostprotocols.net
Cc: mingo@kernel.org, tglx@linutronix.de, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2012 13:28:17 +0530
Message-ID: <20121016075817.3572.76733.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
References: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101607-1396-0000-0000-000002009ABB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_cpu_notifier() macro invokes smp_processor_id() multiple
times. Optimize it by using a local variable.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/perf_event.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0647805..6bfb2faa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -803,15 +803,16 @@ static inline void perf_event_task_tick(void)				{ }
 do {									\
 	static struct notifier_block fn##_nb __cpuinitdata =		\
 		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+	unsigned long cpu = smp_processor_id();				\
 	unsigned long flags;						\
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	local_irq_save(flags);						\
 	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	local_irq_restore(flags);					\
 	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 

