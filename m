Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1FNJt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:49:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab1FNJtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:49:25 -0400
Date: Tue, 14 Jun 2011 09:49:10 GMT
From: tip-bot for Max Asbock <masbock@linux.vnet.ibm.com>
Message-ID: <tip-1123d93963cbd2546449d4d9f0c568e323cb0ac6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, masbock@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, johnstul@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, masbock@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, johnstul@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <1307985512.4710.41.camel@w-amax.beaverton.ibm.com>
References: <1307985512.4710.41.camel@w-amax.beaverton.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timerfd: Fix wakeup of processes when timer is cancelled on clock change
Git-Commit-ID: 1123d93963cbd2546449d4d9f0c568e323cb0ac6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Jun 2011 09:49:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1123d93963cbd2546449d4d9f0c568e323cb0ac6
Gitweb:     http://git.kernel.org/tip/1123d93963cbd2546449d4d9f0c568e323cb0ac6
Author:     Max Asbock <masbock@linux.vnet.ibm.com>
AuthorDate: Mon, 13 Jun 2011 10:18:32 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 14 Jun 2011 11:46:14 +0200

timerfd: Fix wakeup of processes when timer is cancelled on clock change

Currently processes waiting with poll on cancelable timerfd timers are
not woken up when the timers are canceled. When the system time is set
the clock_was_set() function calls timerfd_clock_was_set() to cancel
and wake up processes waiting on potential cancelable timerfd
timers. However the wake up currently has no effect because in the
case of timerfd_read it is dependent on ctx->ticks not being
0. timerfd_poll also requires ctx->ticks being non zero. As a
consequence processes waiting on cancelable timers only get woken up
when the timers expire. This patch fixes this by incrementing
ctx->ticks before calling wake_up.

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: kay.sievers@vrfy.org
Cc: virtuoso@slind.org
Cc: johnstul <johnstul@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1307985512.4710.41.camel@w-amax.beaverton.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/timerfd.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index f67acbd..dffeb37 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -61,7 +61,9 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 
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
