Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2JPNBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:01:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:24835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab2JPNBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235733946"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 4/5] x86,idle: Set residency to 0 if target Cstate not enter
Date: Tue, 16 Oct 2012 21:04:39 -0400
Message-Id: <1350435880-19143-5-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1350435880-19143-4-git-send-email-youquan.song@intel.com>
References: <1350435880-19143-1-git-send-email-youquan.song@intel.com>
 <1350435880-19143-2-git-send-email-youquan.song@intel.com>
 <1350435880-19143-3-git-send-email-youquan.song@intel.com>
 <1350435880-19143-4-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpuidle governor choose a C-state to enter for idle CPU, but it notice that
there is tasks request to be executed. So the idle CPU will not really enter
the target C-state and go to run task.

In this situation, it will use the residency of previous really entered target 
C-states. Obviously, it is not reasonable. 

So, this patch fix it by set the target C-state residency to 0. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/cpuidle.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index e28f6ea..01dca54 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -144,6 +144,10 @@ int cpuidle_idle_call(void)
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(drv, dev);
 	if (need_resched()) {
+		dev->last_residency = 0;
+		/* give the governor an opportunity to reflect on the outcome */
+		if (cpuidle_curr_governor->reflect)
+			cpuidle_curr_governor->reflect(dev, next_state);
 		local_irq_enable();
 		return 0;
 	}
-- 
1.7.7.4

