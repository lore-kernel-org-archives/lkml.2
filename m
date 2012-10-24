Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476Ab2JXJlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:41:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab2JXJlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:41:00 -0400
Date: Wed, 24 Oct 2012 02:39:47 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-6760bca9fd16256210f4922a3e9f067d2c7017d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
References: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, cpu hotplug:
  Run CPU_STARTING notifiers with irqs disabled
Git-Commit-ID: 6760bca9fd16256210f4922a3e9f067d2c7017d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:39:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6760bca9fd16256210f4922a3e9f067d2c7017d7
Gitweb:     http://git.kernel.org/tip/6760bca9fd16256210f4922a3e9f067d2c7017d7
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Tue, 16 Oct 2012 13:28:10 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:01:58 +0200

perf, cpu hotplug: Run CPU_STARTING notifiers with irqs disabled

The CPU_STARTING notifiers are supposed to be run with irqs
disabled. But the perf_cpu_notifier() macro invokes them without
doing that. Fix it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: peterz@infradead.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

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
