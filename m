Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2J1Xlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:41:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749Ab2J1X1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:45 -0400
Message-Id: <20121028231557.652856699@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 067/105] cpufreq / powernow-k8: Remove usage of smp_processor_id() in
 preemptible code
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit e4df1cbcc1f329e53a1fff7450b2229e0addff20 upstream.

Commit 6889125b8b4e09c5e53e6ecab3433bed1ce198c9
(cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to another CPU)
causes powernow-k8 to trigger a preempt warning, e.g.:

  BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq/3776
  caller is powernowk8_target+0x20/0x49
  Pid: 3776, comm: cpufreq Not tainted 3.6.0 #9
  Call Trace:
   [<ffffffff8125b447>] debug_smp_processor_id+0xc7/0xe0
   [<ffffffff814877e7>] powernowk8_target+0x20/0x49
   [<ffffffff81482b02>] __cpufreq_driver_target+0x82/0x8a
   [<ffffffff81484fc6>] cpufreq_governor_performance+0x4e/0x54
   [<ffffffff81482c50>] __cpufreq_governor+0x8c/0xc9
   [<ffffffff81482e6f>] __cpufreq_set_policy+0x1a9/0x21e
   [<ffffffff814839af>] store_scaling_governor+0x16f/0x19b
   [<ffffffff81484f16>] ? cpufreq_update_policy+0x124/0x124
   [<ffffffff8162b4a5>] ? _raw_spin_unlock_irqrestore+0x2c/0x49
   [<ffffffff81483640>] store+0x60/0x88
   [<ffffffff811708c0>] sysfs_write_file+0xf4/0x130
   [<ffffffff8111243b>] vfs_write+0xb5/0x151
   [<ffffffff811126e0>] sys_write+0x4a/0x71
   [<ffffffff816319a9>] system_call_fastpath+0x16/0x1b

Fix this by by always using work_on_cpu().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cpufreq/powernow-k8.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 129e80b..c16a3a5 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1052,14 +1052,7 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	struct powernowk8_target_arg pta = { .pol = pol, .targfreq = targfreq,
 					     .relation = relation };
 
-	/*
-	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
-	 * that we're bound to the current CPU and pol->cpu stays online.
-	 */
-	if (smp_processor_id() == pol->cpu)
-		return powernowk8_target_fn(&pta);
-	else
-		return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
+	return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
 }
 
 /* Driver entry point to verify the policy and range of frequencies */


