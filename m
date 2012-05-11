Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2EKDCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:02:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:27369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab2EKDCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164756982"
From: Youquan Song <youquan.song@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, len.brown@intel.com,
        akpm@linux-foundation.org
Cc: arjan@linux.intel.com, len.brown@linux.intel.com,
        suresh.b.siddha@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 2/3] x86,idle: Quickly notice prediction failure in general case
Date: Fri, 11 May 2012 11:15:56 -0400
Message-Id: <1336749357-9133-3-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1336749357-9133-2-git-send-email-youquan.song@intel.com>
References: <1336749357-9133-1-git-send-email-youquan.song@intel.com>
 <1336749357-9133-2-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch extends the patch to enhance the prediction for repeat mode by add a 
timer when menu governor choose a shallow C-state. 
The timer is set to time out in 50 milli-seconds by default. It is special twist
 that there are no power saving gains even sleep longer than it.
  
When C-state is waken up prior to the adding timer, the timer will be cancelled 
initiatively. When the timer is triggered and menu governor will quickly notice
prediction failure and re-evaluates deeper C-states possibility. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpuidle/governors/menu.c |   48 ++++++++++++++++++++++++++------------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 8c23fbd..9f92dd4 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -113,6 +113,13 @@ static DEFINE_PER_CPU(int, hrtimer_started);
  * represented in the system load average.
  *
  */
+
+/*
+ * Default set to 50 milliseconds based on special twist mentioned above that
+ * there are no power gains sleep longer than it.
+ */
+static unsigned int perfect_cstate_ms __read_mostly = 50;
+module_param(perfect_cstate_ms, uint, 0000);
 
 struct menu_device {
 	int		last_state_idx;
@@ -343,26 +350,37 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 			data->exit_us = s->exit_latency;
 		}
 	}
-
+
+	/* not deepest C-state chosen */
 	if (data->last_state_idx < drv->state_count - 1) { 
+		unsigned int repeat_us = 0;
+		unsigned int perfect_us = 0;
+
+		/*
+		 * Set enough timer to recognize the repeat mode broken.
+		 * If the timer is time out, the repeat mode prediction
+		 * fails,then re-evaluate deeper C-states possibility.
+		 * If the timer is not triggered, the timer will be
+		 * cancelled when CPU waken up.
+		 */
+		repeat_us =
+			(repeat ? (2 * data->predicted_us + MAX_DEVIATION) : 0);
+		perfect_us = perfect_cstate_ms * 1000;
 
 		/* Repeat mode detected */
-		if (repeat) {
-			unsigned int repeat_us = 0;
-			/* 
-			 * Set enough timer to recognize the repeat mode broken.
-			 * If the timer is time out, the repeat mode prediction
-			 * fails,then re-evaluate deeper C-states possibility. 
-			 * If the timer is not triggered, the timer will be
-			 * cancelled when CPU waken up.
-			 */
-			repeat_us = 2 * data->predicted_us + MAX_DEVIATION;
-			hrtimer_start(hrtmr, ns_to_ktime(1000 * repeat_us),
-	      			HRTIMER_MODE_REL_PINNED);
+		if (repeat && (repeat_us  < perfect_us)) {
+			hrtimer_start(hrtmr, ns_to_ktime(1000 * repeat_us),
+				HRTIMER_MODE_REL_PINNED);
+			/* menu hrtimer is started */
+			per_cpu(hrtimer_started, cpu) = 1;
+		} else if (perfect_us < data->expected_us) {
+			/* expected time is larger than adding timer time */
+			hrtimer_start(hrtmr, ns_to_ktime(1000 * perfect_us),
+					HRTIMER_MODE_REL_PINNED);
 			/* menu hrtimer is started */
 			per_cpu(hrtimer_started, cpu) = 1;
-		}
-	}
+		}
+	}
 
 	return data->last_state_idx;
 }
-- 
1.6.4.2

