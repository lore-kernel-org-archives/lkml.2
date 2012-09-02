Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2IBFsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 01:48:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2IBFsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 01:48:41 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 2/4] timerfd: Move repeated logic into timefd_rearm()
Date: Sat,  1 Sep 2012 22:45:20 -0700
Message-Id: <1346564722-14408-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120902054335.GA12741@lizard>
References: <20120902054335.GA12741@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces timerfd_rearm(), this small helper is used to
forward and restart the hrtimer.

This small refactoring would be also useful if/when we'll add other
backend for timerfd (like deferrable timers), so we won't need to
duplicate the code more.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/timerfd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index dffeb37..ecfb3f3 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -178,6 +178,14 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
+static u64 timerfd_rearm(struct timerfd_ctx *ctx)
+{
+	u64 orun = hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
+
+	hrtimer_restart(&ctx->tmr);
+	return orun;
+}
+
 static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
@@ -214,9 +222,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks += hrtimer_forward_now(&ctx->tmr,
-						     ctx->tintv) - 1;
-			hrtimer_restart(&ctx->tmr);
+			ticks += timerfd_rearm(ctx);
 		}
 		ctx->expired = 0;
 		ctx->ticks = 0;
@@ -355,9 +361,7 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
 	spin_lock_irq(&ctx->wqh.lock);
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
-		ctx->ticks +=
-			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
-		hrtimer_restart(&ctx->tmr);
+		ctx->ticks += timerfd_rearm(ctx);
 	}
 	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
-- 
1.7.11.5

