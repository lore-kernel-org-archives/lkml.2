Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab2KFKjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:39:19 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44423 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2KFKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:39:15 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu instead of current one
Date: Tue,  6 Nov 2012 16:08:45 +0530
Message-Id: <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 06 Nov 2012 10:38:57.0842 (UTC) FILETIME=[ED2C7120:01CDBC0A]
X-MC-Unique: 112110610390404301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA6AdaYd014383

Workqueues queues work on current cpu, if the caller haven't passed a preferred
cpu. This may wake up an idle CPU, which is actually not required.

This work can be processed by any CPU and so we must select a non-idle CPU here.
This patch adds in support in workqueue framework to get preferred CPU details
from the scheduler, instead of using current CPU.

Most of the time when a work is queued, the current cpu isn't idle and so we
will choose it only. There are cases when a cpu is idle when it queues some
work. For example, consider following scenario:
- A cpu has programmed a timer and is IDLE now.
- CPU gets into interrupt handler due to timer and queues a work. As the CPU is
  currently IDLE, we can queue this work to some other CPU.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/workqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..d32efa2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1238,7 +1238,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		struct global_cwq *last_gcwq;
 
 		if (cpu == WORK_CPU_UNBOUND)
-			cpu = raw_smp_processor_id();
+			cpu = sched_select_cpu(0);
 
 		/*
 		 * It's multi cpu.  If @work was previously on a different
@@ -1383,7 +1383,7 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 		if (gcwq)
 			lcpu = gcwq->cpu;
 		if (lcpu == WORK_CPU_UNBOUND)
-			lcpu = raw_smp_processor_id();
+			lcpu = sched_select_cpu(0);
 	} else {
 		lcpu = WORK_CPU_UNBOUND;
 	}
-- 
1.7.12.rc2.18.g61b472e


