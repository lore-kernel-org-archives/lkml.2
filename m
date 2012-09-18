Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2IQNvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:51:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:23963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab2IQNv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,435,1344236400"; 
   d="scan'208";a="145899804"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH V2 3/3] x86,idle: Set residency to 0 if target Cstate not really enter
Date: Mon, 17 Sep 2012 21:53:29 -0400
Message-Id: <1347933209-25939-4-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1347933209-25939-3-git-send-email-youquan.song@intel.com>
References: <1347933209-25939-1-git-send-email-youquan.song@intel.com>
 <1347933209-25939-2-git-send-email-youquan.song@intel.com>
 <1347933209-25939-3-git-send-email-youquan.song@intel.com>
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
---
 drivers/cpuidle/cpuidle.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 2f0083a..7992417 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -136,6 +136,10 @@ int cpuidle_idle_call(void)
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
