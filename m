Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2GQTSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:18:50 -0400
Received: from toro.web-alm.net ([62.245.132.31]:51541 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab2GQTSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:18:47 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 15:18:44 EDT
Message-Id: <20120717190330.700421963@osadl.org>
User-Agent: quilt/0.51-1
Date: Tue, 17 Jul 2012 20:59:15 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Len Brown <len.brown@intel.com>
Cc: Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 1/1] Honor state disabling in the cpuidle ladder governor
References: <20120717185914.063547728@osadl.org>
Content-Disposition: inline; filename=drivers-cpuidle-ladder-honor-disabling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two cpuidle governors ladder and menu. While the ladder
governor is always available, if CONFIG_CPU_IDLE is selected, the
menu governor additionally requires CONFIG_NO_HZ.

A particular C state can be disabled by writing to the sysfs file
/sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
is only implemented in the menu governor. Thus, in a system where
CONFIG_NO_HZ is not selected, the ladder governor becomes default and
always will walk through all sleep states - irrespective of whether the
C state was disabled via sysfs or not. The only way to select a specific
C state was to write the related latency to /dev/cpu_dma_latency and
keep the file open as long as this setting was required - not very
practical and not suitable for setting a single core in an SMP system.

With this patch, the ladder governor only will promote to the next
C state, if it has not been disabled, and it will demote, if the
current C state was disabled.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 drivers/cpuidle/governors/ladder.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-3.4.4-rt14-rc2-64/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux-3.4.4-rt14-rc2-64.orig/drivers/cpuidle/governors/ladder.c
+++ linux-3.4.4-rt14-rc2-64/drivers/cpuidle/governors/ladder.c
@@ -88,6 +88,7 @@ static int ladder_select_state(struct cp
 
 	/* consider promotion */
 	if (last_idx < drv->state_count - 1 &&
+	    !drv->states[last_idx + 1].disable &&
 	    last_residency > last_state->threshold.promotion_time &&
 	    drv->states[last_idx + 1].exit_latency <= latency_req) {
 		last_state->stats.promotion_count++;
@@ -100,7 +101,8 @@ static int ladder_select_state(struct cp
 
 	/* consider demotion */
 	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    drv->states[last_idx].exit_latency > latency_req) {
+	    (drv->states[last_idx].disable ||
+	    drv->states[last_idx].exit_latency > latency_req)) {
 		int i;
 
 		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {

