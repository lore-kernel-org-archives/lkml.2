Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156Ab1JEQ42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:56:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:52172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935068Ab1JEQzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558373"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 4/8] kernel/workqueue.c: unbound work queue rescuer runs on first cpu in cpumask_online_cpu
Date: Wed,  5 Oct 2011 09:39:15 -0700
Message-Id: <1317832759-10223-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If work queue is unbound to a specific cpu, run rescuer on first cpu in
cpumask_online_cpu instead BSP which could be offlined.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1783aab..d26e411 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1496,9 +1496,9 @@ static bool send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	cpu = cwq->gcwq->cpu;
-	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
+	/* WORK_CPU_UNBOUND can't be set in cpumask, use first cpu instead */
 	if (cpu == WORK_CPU_UNBOUND)
-		cpu = 0;
+		cpu = cpumask_first(cpu_online_mask);
 	if (!mayday_test_and_set_cpu(cpu, wq->mayday_mask))
 		wake_up_process(wq->rescuer->task);
 	return true;
-- 
1.6.0.3

