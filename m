Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936442Ab0COOBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:01:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60026 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936360Ab0COOBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:01:23 -0400
From: Colin Ian King <colin.king@canonical.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: stop spurious softlockup messages due to overflow
Date: Mon, 15 Mar 2010 14:01:13 +0000
Message-Id: <1268661673-21638-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure additions on touch_ts do not overflow.  This can occur when
the top 32 bits of the TSC reach 0xffffffff causing additions to
touch_ts to overflow and this in turn generates spurious softlockup
warnings.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 kernel/softlockup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 0d4c789..90d9aa0 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -111,10 +111,10 @@ int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
 void softlockup_tick(void)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
+	unsigned long long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
 	unsigned long print_ts;
 	struct pt_regs *regs = get_irq_regs();
-	unsigned long now;
+	unsigned long long now;
 
 	/* Is detection switched off? */
 	if (!per_cpu(softlockup_watchdog, this_cpu) || softlockup_thresh <= 0) {
@@ -165,7 +165,7 @@ void softlockup_tick(void)
 	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
 
 	spin_lock(&print_lock);
-	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
+	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %llus! [%s:%d]\n",
 			this_cpu, now - touch_ts,
 			current->comm, task_pid_nr(current));
 	print_modules();
-- 
1.6.3.3

