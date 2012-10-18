Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2JRJK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:10:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:17644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab2JRJJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:09:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="207567134"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org, rjw@sisk.pl
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH V2 2/4]  x86,idle: Quickly notice prediction failure in general case
Date: Thu, 18 Oct 2012 17:12:22 -0400
Message-Id: <1350594744-22353-3-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1350594744-22353-2-git-send-email-youquan.song@intel.com>
References: <1350594744-22353-1-git-send-email-youquan.song@intel.com>
 <1350594744-22353-2-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prediction for future is difficult and when the cpuidle governor prediction 
fails and govenor possibly choose the shallower C-state than it should. How to 
quickly notice and find the failure becomes important for power saving.    

The patch extends to general case that prediction logic get a small predicted
residency, so it choose a shallow C-state though the expected residency is large
. Once the prediction will be fail, the CPU will keep staying at shallow C-state
for a long time. Acutally, the CPU has change enter into deep C-state.
So when the expected residency is long enough but governor choose a shallow
C-state, an timer will be added in order to monitor if the prediction failure. 

When C-state is waken up prior to the adding timer, the timer will be cancelled 
initiatively. When the timer is triggered and menu governor will quickly notice
prediction failure and re-evaluates deeper C-states possibility. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/governors/menu.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 37c0ff6..c824b4f 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -34,7 +34,7 @@
 static DEFINE_PER_CPU(struct hrtimer, menu_hrtimer);
 static DEFINE_PER_CPU(int, hrtimer_status);
 /* menu hrtimer mode */
-enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT};
+enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT, MENU_HRTIMER_GENERAL};
 
 /*
  * Concepts and ideas behind the menu governor
@@ -116,6 +116,13 @@ enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT};
  *
  */
 
+/*
+ * The C-state residency is so long that is is worthwhile to exit
+ * from the shallow C-state and re-enter into a deeper C-state.
+ */
+static unsigned int perfect_cstate_ms __read_mostly = 30;
+module_param(perfect_cstate_ms, uint, 0000);
+
 struct menu_device {
 	int		last_state_idx;
 	int             needs_update;
@@ -216,7 +223,17 @@ EXPORT_SYMBOL_GPL(menu_hrtimer_cancel);
 static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
 {
 	int cpu = smp_processor_id();
+	struct menu_device *data = &per_cpu(menu_devices, cpu);
 
+	/* In general case, the expected residency is much larger than
+	 *  deepest C-state target residency, but prediction logic still
+	 *  predicts a small predicted residency, so the prediction
+	 *  history is totally broken if the timer is triggered.
+	 *  So reset the correction factor.
+	 */
+	if (per_cpu(hrtimer_status, cpu) == MENU_HRTIMER_GENERAL)
+		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
+
 	per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_STOP;
 
 	return HRTIMER_NORESTART;
@@ -353,6 +370,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	/* not deepest C-state chosen for low predicted residency */
 	if (low_predicted) {
 		unsigned int timer_us = 0;
+		unsigned int perfect_us = 0;
 
 		/*
 		 * Set a timer to detect whether this sleep is much
@@ -363,12 +381,26 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		 */
 		timer_us = 2 * (data->predicted_us + MAX_DEVIATION);
 
+		perfect_us = perfect_cstate_ms * 1000;
+
 		if (repeat && (4 * timer_us < data->expected_us)) {
 			hrtimer_start(hrtmr, ns_to_ktime(1000 * timer_us),
 				HRTIMER_MODE_REL_PINNED);
 			/* In repeat case, menu hrtimer is started */
 			per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_REPEAT;
+		} else if (perfect_us < data->expected_us) {
+			/*
+			 * The next timer is long. This could be because
+			 * we did not make a useful prediction.
+			 * In that case, it makes sense to re-enter
+			 * into a deeper C-state after some time.
+			 */
+			hrtimer_start(hrtmr, ns_to_ktime(1000 * timer_us),
+				HRTIMER_MODE_REL_PINNED);
+			/* In general case, menu hrtimer is started */
+			per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_GENERAL;
 		}
+
 	}
 
 	return data->last_state_idx;
-- 
1.7.7.4

