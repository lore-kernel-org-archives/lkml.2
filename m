Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1ASGql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:46:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7964 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1ASGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:46:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6230"; a="71051047"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched: Notify hrtimer users of switches to NOHZ mode
Date: Tue, 18 Jan 2011 22:46:34 -0800
Message-Id: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc2.3.g60a2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When NOHZ=y and high res timers are disabled (via cmdline or
Kconfig) tick_nohz_switch_to_nohz() will notify the user about
switching into NOHZ mode. Nothing is printed for the case where
HIGH_RES_TIMERS=y. Fix this for the HIGH_RES_TIMERS=y case by
duplicating the printk from the low res NOHZ path in the high res
NOHZ path.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This confused me since I was thinking 'dmesg | grep -i NOHZ' would
tell me if NOHZ was enabled, but if I have hrtimers there is
nothing. If we don't do this we should probably remove the original
printk.

 kernel/time/tick-sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..6c012c5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -795,8 +795,11 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
-	if (tick_nohz_enabled)
+	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+		pr_info("Switched to NOHz mode on CPU #%d\n",
+				smp_processor_id());
+	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

