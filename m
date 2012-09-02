Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2IBFsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 01:48:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2IBFss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 01:48:48 -0400
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
Subject: [PATCH 3/4] timerfd: Factor out timer-type unspecific timerfd_expire()
Date: Sat,  1 Sep 2012 22:45:21 -0700
Message-Id: <1346564722-14408-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120902054335.GA12741@lizard>
References: <20120902054335.GA12741@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing hrtimer-specific inside the timerfd_tmrproc(), except
the function prototype. We're about to add other timer types, so factor
out generic timerfd_expire() helper from timerfd_tmrproc().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/timerfd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index ecfb3f3..222db32 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -45,9 +45,8 @@ static DEFINE_SPINLOCK(cancel_lock);
  * flag, but we do not re-arm the timer (in case it's necessary,
  * tintv.tv64 != 0) until the timer is accessed.
  */
-static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
+static void timerfd_expire(struct timerfd_ctx *ctx)
 {
-	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
@@ -56,6 +55,11 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 	wake_up_locked(&ctx->wqh);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
+}
+
+static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
+{
+	timerfd_expire(container_of(htmr, struct timerfd_ctx, tmr));
 	return HRTIMER_NORESTART;
 }
 
-- 
1.7.11.5

