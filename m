Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab2KPCV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:21:59 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61094 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KPCVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:21:55 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/9] irq_work: Warn if there's still work on cpu_down
Date: Fri, 16 Nov 2012 03:21:29 +0100
Message-Id: <1353032491-16462-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
References: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

If we are in nohz and there's still irq_work to be done when the idle
task is about to go offline, give a nasty warning. Everything should
have been flushed from the CPU_DYING notifier already. Further attempts
to enqueue an irq_work are buggy because irqs are disabled by
__cpu_disable(). The best we can do is to report the issue to the user.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/irq_work.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index cf8b657..fcaadae 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -108,6 +108,9 @@ bool irq_work_needs_cpu(void)
 	if (llist_empty(this_list))
 		return false;
 
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+
 	return true;
 }
 
-- 
1.7.5.4

