Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2KRBGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:06:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51386 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2KRBFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:05:11 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/9] irq_work: Warn if there's still work on cpu_down
Date: Sun, 18 Nov 2012 02:04:50 +0100
Message-Id: <1353200692-6039-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
References: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
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
index 4ed1749..480f747 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -109,6 +109,9 @@ bool irq_work_needs_cpu(void)
 	if (llist_empty(this_list))
 		return false;
 
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+
 	return true;
 }
 
-- 
1.7.5.4

