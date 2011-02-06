Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1BFMGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:06:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1BFMGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:06:42 -0500
Date: Sun, 6 Feb 2011 13:06:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110206120632.GA28866@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Marcelo Roberto Jimenez (1):
      RTC: Prevents a division by zero in kernel code.

Peter Zijlstra (1):
      lockdep, timer: Fix del_timer_sync() annotation


 drivers/rtc/class.c     |    1 +
 drivers/rtc/interface.c |    3 +++
 kernel/timer.c          |    6 +++++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 9583cbc..c404b61 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -143,6 +143,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc->id = id;
 	rtc->ops = ops;
 	rtc->owner = owner;
+	rtc->irq_freq = 1;
 	rtc->max_user_freq = 64;
 	rtc->dev.parent = dev;
 	rtc->dev.class = rtc_class;
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 925006d..a0c0196 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -464,6 +464,9 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
+	if (freq <= 0)
+		return -EINVAL;
+
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..d53ce66 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -969,10 +969,14 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
 	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	local_bh_enable();
+	_local_bh_enable();
+	raw_local_irq_restore(flags);
 #endif
 	/*
 	 * don't use it in hardirq context, because it
