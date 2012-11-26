Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2KZRcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:32:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2KZRMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 207/270] cpufreq / powernow-k8: Remove usage of smp_processor_id() in preemptible code
Date: Mon, 26 Nov 2012 14:58:17 -0200
Message-Id: <1353949160-26803-208-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/cpufreq/powernow-k8.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 1a40935..c671369 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1223,14 +1223,7 @@ static int powernowk8_target(struct cpufreq_policy *pol,
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
-- 
1.7.9.5

