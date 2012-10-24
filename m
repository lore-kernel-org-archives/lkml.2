Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab2JXJmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:42:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab2JXJl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:41:59 -0400
Date: Wed, 24 Oct 2012 02:40:47 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-c13d38e4a1fd5dd07135403c613c8091af444169@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <20121016075817.3572.76733.stgit@srivatsabhat.in.ibm.com>
References: <20121016075817.3572.76733.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, cpu hotplug:
  Use cached value of smp_processor_id()
Git-Commit-ID: c13d38e4a1fd5dd07135403c613c8091af444169
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:40:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c13d38e4a1fd5dd07135403c613c8091af444169
Gitweb:     http://git.kernel.org/tip/c13d38e4a1fd5dd07135403c613c8091af444169
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Tue, 16 Oct 2012 13:28:17 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:01:59 +0200

perf, cpu hotplug: Use cached value of smp_processor_id()

The perf_cpu_notifier() macro invokes smp_processor_id()
multiple times. Optimize it by using a local variable.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: peterz@infradead.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/20121016075817.3572.76733.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

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
 
