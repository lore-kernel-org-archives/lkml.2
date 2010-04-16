Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab0DPJuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 05:50:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39179 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab0DPJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 05:50:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 16 Apr 2010 11:49:27 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/8] fs/timerfd.c: make use of
 wait_event_interruptible_locked_irq()
In-reply-to: <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.0
References: <cover.1271406290.git.mina86@mina86.com>
 <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com>
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
1.7.0

