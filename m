Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1FMRPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:15:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33621 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1FMRPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:15:50 -0400
Subject: [PATCH] timerfd: fix wakeup of processes when timer is cancelled
	on clock change
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>, kay.sievers@vrfy.org, virtuoso@slind.org,
        johnstul <johnstul@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Jun 2011 10:18:32 -0700
Message-Id: <1307985512.4710.41.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have sent this before, perhaps it got lost in the noise.

Currently processes waiting on cancelable timerfd timers are 
not woken up when the timers are canceled.
When the system time is set the clock_was_set() function calls
timerfd_clock_was_set() to cancel and wake up processes waiting on
potential cancelable timerfd timers. However the wake up currently has
no effect because in the case of timerfd_read it is dependent on
ctx->ticks not being 0. timerfd_poll also requires ctx->ticks being non
zero. As a consequence processes waiting on cancelable timers only get
woken up when the timers expire. This patch fixes this by incrementing
ctx->ticks before calling wake_up.

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
---

--- linux-3.0-rc1/fs/timerfd.c
+++ linux-3.0-rc1.timerfd/fs/timerfd.c
@@ -61,7 +61,9 @@ static enum hrtimer_restart timerfd_tmrp
 
 /*
  * Called when the clock was set to cancel the timers in the cancel
- * list.
+ * list. This will wake up processes waiting on these timers. The
+ * wake-up requires ctx->ticks to be non zero, therefore we increment
+ * it before calling wake_up_locked().
  */
 void timerfd_clock_was_set(void)
 {
@@ -76,6 +78,7 @@ void timerfd_clock_was_set(void)
 		spin_lock_irqsave(&ctx->wqh.lock, flags);
 		if (ctx->moffs.tv64 != moffs.tv64) {
 			ctx->moffs.tv64 = KTIME_MAX;
+			ctx->ticks++;
 			wake_up_locked(&ctx->wqh);
 		}
 		spin_unlock_irqrestore(&ctx->wqh.lock, flags);


-- 
Max


