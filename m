Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab0EEKxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:53:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63625 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0EEKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:53:04 -0400
Date: Wed, 05 May 2010 12:53:12 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 2/8] fs/timerfd.c: make use of
 wait_event_interruptible_locked_irq()
In-reply-to: <11f2d7a2b97b514b33b0f92d9456d0c6e1d7501e.1273054945.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <4a74b9dde6495da76354f8caca267a57cf440a12.1273054945.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1273054944.git.mina86@mina86.com>
 <11f2d7a2b97b514b33b0f92d9456d0c6e1d7501e.1273054945.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the fs/timerfd.c to use the newly created
wait_event_interruptible_locked_irq() macro.  This replaces an open
code implementation with a single macro call.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 fs/timerfd.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 98158de..b86ab8e 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -110,31 +110,14 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	struct timerfd_ctx *ctx = file->private_data;
 	ssize_t res;
 	u64 ticks = 0;
-	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
-	res = -EAGAIN;
-	if (!ctx->ticks && !(file->f_flags & O_NONBLOCK)) {
-		__add_wait_queue(&ctx->wqh, &wait);
-		for (res = 0;;) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (ctx->ticks) {
-				res = 0;
-				break;
-			}
-			if (signal_pending(current)) {
-				res = -ERESTARTSYS;
-				break;
-			}
-			spin_unlock_irq(&ctx->wqh.lock);
-			schedule();
-			spin_lock_irq(&ctx->wqh.lock);
-		}
-		__remove_wait_queue(&ctx->wqh, &wait);
-		__set_current_state(TASK_RUNNING);
-	}
+	if (file->f_flags & O_NONBLOCK)
+		res = -EAGAIN;
+	else
+		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
 	if (ctx->ticks) {
 		ticks = ctx->ticks;
 		if (ctx->expired && ctx->tintv.tv64) {
-- 
1.7.1

