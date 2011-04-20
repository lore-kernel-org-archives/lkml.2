Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1DTGz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:55:59 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45104 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1DTGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:55:55 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 2/4] cpuidle: Remove CPUIDLE_FLAG_IGNORE and
	dev->prepare()
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-omap@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Wed, 20 Apr 2011 12:25:48 +0530
Message-ID: <20110420065542.332.76633.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
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

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle.c        |   10 ----------
 drivers/cpuidle/governors/menu.c |    2 --
 include/linux/cpuidle.h          |    3 ---
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 355b078..92a6216 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -75,16 +75,6 @@ static void cpuidle_idle_call(void)
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
index 70d9982..40b5630 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -286,8 +286,6 @@ static int menu_select(struct cpuidle_device *dev)
 	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
 		struct cpuidle_state *s = &dev->states[i];
 
-		if (s->flags & CPUIDLE_FLAG_IGNORE)
-			continue;
 		if (s->target_residency > data->predicted_us)
 			continue;
 		if (s->exit_latency > latency_req)
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 45eef60..a3306be 100644
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

