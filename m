Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1JCHqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:46:07 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37193 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1JCHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:45:58 -0400
Subject: [PATCH V8 2/4] cpuidle: Remove CPUIDLE_FLAG_IGNORE and dev->prepare()
To: khilman@ti.com, venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, arjan@linux.intel.com,
        lenb@kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 03 Oct 2011 13:15:06 +0530
Message-ID: <20111003074457.21968.78858.stgit@localhost6.localdomain6>
In-Reply-To: <20111003074147.21968.86106.stgit@localhost6.localdomain6>
References: <20111003074147.21968.86106.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle_device->prepare() mechanism causes updates to the
cpuidle_state[].flags, setting and clearing CPUIDLE_FLAG_IGNORE
to tell the governor not to chose a state on a per-cpu basis at
run-time. State demotion is now handled by the driver and it returns
the actual state entered. Hence, this mechanism is not required.
Also this removes per-cpu flags from cpuidle_state enabling
it to be made global.

Reference:
https://lkml.org/lkml/2011/3/25/52

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm>
Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
Tested-by: Jean Pihet <j-pihet@ti.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
---
 drivers/cpuidle/cpuidle.c        |   10 ----------
 drivers/cpuidle/governors/menu.c |    2 --
 include/linux/cpuidle.h          |    3 ---
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 88bd121..f66bcf9 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -83,16 +83,6 @@ int cpuidle_idle_call(void)
 	hrtimer_peek_ahead_timers();
 #endif
 
-	/*
-	 * Call the device's prepare function before calling the
-	 * governor's select function.  ->prepare gives the device's
-	 * cpuidle driver a chance to update any dynamic information
-	 * of its cpuidle states for the current idle period, e.g.
-	 * state availability, latencies, residencies, etc.
-	 */
-	if (dev->prepare)
-		dev->prepare(dev);
-
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
 	if (need_resched()) {
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index e4b200c..af724e8 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -288,8 +288,6 @@ static int menu_select(struct cpuidle_device *dev)
 	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
 		struct cpuidle_state *s = &dev->states[i];
 
-		if (s->flags & CPUIDLE_FLAG_IGNORE)
-			continue;
 		if (s->target_residency > data->predicted_us)
 			continue;
 		if (s->exit_latency > latency_req)
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 8da811b..c6d85cf 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -47,7 +47,6 @@ struct cpuidle_state {
 
 /* Idle State Flags */
 #define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
-#define CPUIDLE_FLAG_IGNORE	(0x100) /* ignore during this idle period */
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 
@@ -93,8 +92,6 @@ struct cpuidle_device {
 	struct completion	kobj_unregister;
 	void			*governor_data;
 	int			safe_state_index;
-
-	int (*prepare)		(struct cpuidle_device *dev);
 };
 
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);

