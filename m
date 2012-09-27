Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2I0JEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:04:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50413 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2I0JEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:04:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 3/3] workqueue: Schedule work on non-idle cpu instead of current one
Date: Thu, 27 Sep 2012 14:34:05 +0530
Message-Id: <7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1348736069.git.viresh.kumar@linaro.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1348736069.git.viresh.kumar@linaro.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 27 Sep 2012 09:04:18.0833 (UTC) FILETIME=[13B27010:01CD9C8F]
X-MC-Unique: 112092710043928601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8R94wOl004060

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
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 143fd8c..5fa4ba4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1238,7 +1238,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		struct global_cwq *last_gcwq;
 
 		if (cpu == WORK_CPU_UNBOUND)
-			cpu = raw_smp_processor_id();
+			cpu = sched_select_cpu(0);
 
 		/*
 		 * It's multi cpu.  If @work was previously on a different
-- 
1.7.12.rc2.18.g61b472e


