Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1FOTET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:04:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28441 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1FOTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:04:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, davej@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        cpufreq@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] [CPUFREQ]: Don't set stat->last_index to -1 if the pol->cur has incorrect value.
Date: Wed, 15 Jun 2011 15:02:00 -0400
Message-Id: <1308164520-14145-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
References: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4DF901BC.00BF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the driver submitted an non-existing pol>cur value (say it
used the default initialized value of zero), when the cpufreq
stats tries to setup its initial values it incorrectly sets
stat->last_index to -1 (or 0xfffff...). And cpufreq_stats_update
tries to update at that index location and fails.

This can be caused by:

stat->last_index = freq_table_get_index(stat, policy->cur);

not finding the appropiate frequency in the table (b/c the policy->cur
is wrong) and we end up crashing. The fix however is
concentrated in the 'cpufreq_stats_update' as the last_index
(and old_index) are updated there. Which means it can reset
the last_index to -1 again and on the next iteration cause a crash.

Without this patch, the following crash is observed:

powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
powernow-k8: fid 0x2 (1000 MHz), vid 0x12
powernow-k8: fid 0xa (1800 MHz), vid 0xa
powernow-k8: fid 0xc (2000 MHz), vid 0x8
powernow-k8: fid 0xe (2200 MHz), vid 0x8
Marking TSC unstable due to cpufreq changes
powernow-k8: fid trans failed, fid 0x2, curr 0x0
BUG: unable to handle kernel paging request at ffff880807e07b78
IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
.. snip..
Pid: 1, comm: swapper Not tainted 3.0.0-rc2 #45 MICRO-STAR INTERNATIONAL CO., LTD MS-7094/MS-7094
..snip..
Call Trace:
 [<ffffffff81479248>] cpufreq_stat_notifier_trans+0x48/0x7c
 [<ffffffff81095d68>] notifier_call_chain+0x32/0x5e
 [<ffffffff81095e6b>] __srcu_notifier_call_chain+0x47/0x63
 [<ffffffff81095e96>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff81477e7a>] cpufreq_notify_transition+0x111/0x134
 [<ffffffff8147b0d4>] powernowk8_target+0x53b/0x617
 [<ffffffff8147723a>] __cpufreq_driver_target+0x2e/0x30
 [<ffffffff8147a127>] cpufreq_governor_dbs+0x339/0x356
 [<ffffffff81477394>] __cpufreq_governor+0xa8/0xe9
 [<ffffffff81477525>] __cpufreq_set_policy+0x132/0x13e
 [<ffffffff8147848d>] cpufreq_add_dev_interface+0x272/0x28c

Reported-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
Tested-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/cpufreq/cpufreq_stats.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 00d73fc..cacabcb 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -288,11 +288,13 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	old_index = stat->last_index;
 	new_index = freq_table_get_index(stat, freq->new);
 
-	cpufreq_stats_update(freq->cpu);
-	if (old_index == new_index)
+	/* We can't do stat->time_in_state[-1]= .. */
+	if (old_index == -1 || new_index == -1)
 		return 0;
 
-	if (old_index == -1 || new_index == -1)
+	cpufreq_stats_update(freq->cpu);
+
+	if (old_index == new_index)
 		return 0;
 
 	spin_lock(&cpufreq_stats_lock);
-- 
1.7.4.1

