Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0HOFWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:22:14 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:40426 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0HOFWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:22:12 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 1/5] intel_idle: delete power_policy modparam,
 and choose substate functions
Date: Sun, 15 Aug 2010 01:22:01 -0400
Message-id: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.2.1.95.g3d045
In-reply-to: <1281849725-7379-1-git-send-email-lenb@kernel.org>
References: <1281849725-7379-1-git-send-email-lenb@kernel.org>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The idea behind power policy was that it would start off as a modparam,
and then hook into the new "global" in-kernel power vs energy tunable.
But that tunable isn't happening, so delete the hook here.

With the policy hook gone, the sub-state choice functions
do not do anything useful, so delete them from the critical path.

To handle sub-states in the future, we will advertise them
with dedicated cpuidle_state entries.  That is necessary
because some of the sub-states will have substantially different
properties than their peer sub-states.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |   43 -------------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 82c9a58..6d43bc3 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -77,10 +77,8 @@ static struct cpuidle_driver intel_idle_driver = {
 };
 /* intel_idle.max_cstate=0 disables driver */
 static int max_cstate = MWAIT_MAX_NUM_CSTATES - 1;
-static int power_policy = 7; /* 0 = max perf; 15 = max powersave */
 
 static unsigned int mwait_substates;
-static int (*choose_substate)(int);
 
 /* Reliable LAPIC Timer States, bit 1 for C1 etc.  */
 static unsigned int lapic_timer_reliable_states;
@@ -168,42 +166,6 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = NULL },	/* disabled */
 };
 
-/*
- * choose_tunable_substate()
- *
- * Run-time decision on which C-state substate to invoke
- * If power_policy = 0, choose shallowest substate (0)
- * If power_policy = 15, choose deepest substate
- * If power_policy = middle, choose middle substate etc.
- */
-static int choose_tunable_substate(int cstate)
-{
-	unsigned int num_substates;
-	unsigned int substate_choice;
-
-	power_policy &= 0xF;	/* valid range: 0-15 */
-	cstate &= 7;	/* valid range: 0-7 */
-
-	num_substates = (mwait_substates >> ((cstate) * 4))
-				& MWAIT_SUBSTATE_MASK;
-
-	if (num_substates <= 1)
-		return 0;
-
-	substate_choice = ((power_policy + (power_policy + 1) *
-				(num_substates - 1)) / 16);
-
-	return substate_choice;
-}
-
-/*
- * choose_zero_substate()
- */
-static int choose_zero_substate(int cstate)
-{
-	return 0;
-}
-
 /**
  * intel_idle
  * @dev: cpuidle_device
@@ -221,8 +183,6 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state)
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
 
-	eax = eax + (choose_substate)(cstate);
-
 	local_irq_disable();
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
@@ -301,13 +261,11 @@ static int intel_idle_probe(void)
 	case 0x25:	/* Westmere */
 	case 0x2C:	/* Westmere */
 		cpuidle_state_table = nehalem_cstates;
-		choose_substate = choose_tunable_substate;
 		break;
 
 	case 0x1C:	/* 28 - Atom Processor */
 		lapic_timer_reliable_states = (1 << 2) | (1 << 1); /* C2, C1 */
 		cpuidle_state_table = atom_cstates;
-		choose_substate = choose_zero_substate;
 		break;
 #ifdef FUTURE_USE
 	case 0x17:	/* 23 - Core 2 Duo */
@@ -447,7 +405,6 @@ static void __exit intel_idle_exit(void)
 module_init(intel_idle_init);
 module_exit(intel_idle_exit);
 
-module_param(power_policy, int, 0644);
 module_param(max_cstate, int, 0444);
 
 MODULE_AUTHOR("Len Brown <len.brown@intel.com>");
-- 
1.7.2.1.95.g3d045

