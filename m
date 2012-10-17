Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2JPNBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:01:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:24835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2JPNBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:01:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235733917"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 3/5] x86,idle: Reset correction factor
Date: Tue, 16 Oct 2012 21:04:38 -0400
Message-Id: <1350435880-19143-4-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1350435880-19143-3-git-send-email-youquan.song@intel.com>
References: <1350435880-19143-1-git-send-email-youquan.song@intel.com>
 <1350435880-19143-2-git-send-email-youquan.song@intel.com>
 <1350435880-19143-3-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general case, the expected residency is much larger than deepest C-state
target residency, but prediction logic still predicts the small predicted
residency, so the prediction history is totally broken. In this situation,
reset the correction factor is the only choice.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/governors/menu.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index b34bf11..7dbac97 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -221,6 +221,10 @@ EXPORT_SYMBOL_GPL(menu_hrtimer_cancel);
 static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
 {
 	int cpu = smp_processor_id();
+	struct menu_device *data = &per_cpu(menu_devices, cpu);
+
+	if (per_cpu(hrtimer_started, cpu) == 2)
+		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
 
 	per_cpu(hrtimer_started, cpu) = 0;
 
@@ -386,7 +390,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 			hrtimer_start(hrtmr, ns_to_ktime(1000 * timer_us),
 				HRTIMER_MODE_REL_PINNED);
 			/* menu hrtimer is started */
-			per_cpu(hrtimer_started, cpu) = 1;
+			per_cpu(hrtimer_started, cpu) = 2;
 		}
 
 	}
-- 
1.7.7.4

