Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab1D2SMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:12:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38574 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760678Ab1D2SMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:12:00 -0400
Date: Fri, 29 Apr 2011 20:11:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20110429181150.GA8962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timer-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timer-fixes-for-linus

This fixes the scheduler bug discussed in the:

 "2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?"

lkml thread.

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      hrtimer: Initialize CLOCK_ID to HRTIMER_BASE table statically

Zhangfei Gao (1):
      rtc: max8925: Call dev_set_drvdata before rtc_device_register


 drivers/rtc/rtc-max8925.c |    3 ++-
 kernel/hrtimer.c          |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 174036d..20494b5 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -257,6 +257,8 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_irq;
 	}
 
+	dev_set_drvdata(&pdev->dev, info);
+
 	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
 					&max8925_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(info->rtc_dev);
@@ -265,7 +267,6 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	dev_set_drvdata(&pdev->dev, info);
 	platform_set_drvdata(pdev, info);
 
 	return 0;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9017478..87fdb3f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -81,7 +81,11 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
-static int hrtimer_clock_to_base_table[MAX_CLOCKS];
+static int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
+	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
+	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
+	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
+};
 
 static inline int hrtimer_clockid_to_base(clockid_t clock_id)
 {
@@ -1722,10 +1726,6 @@ static struct notifier_block __cpuinitdata hrtimers_nb = {
 
 void __init hrtimers_init(void)
 {
-	hrtimer_clock_to_base_table[CLOCK_REALTIME] = HRTIMER_BASE_REALTIME;
-	hrtimer_clock_to_base_table[CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC;
-	hrtimer_clock_to_base_table[CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME;
-
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
