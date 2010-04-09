Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0DITVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:21:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60889 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0DITVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:21:43 -0400
Date: Fri, 09 Apr 2010 21:21:19 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 2/8] fs/timerfd.c: make use of
 wait_event_interruptible_locked_irq()
In-reply-to: <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1270835924.git.mina86@mina86.com>
 <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
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
 fs/timerfd.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 1bfc95a..4d2c371 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -109,31 +109,13 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	struct timerfd_ctx *ctx = file->private_data;
 	ssize_t res;
 	u64 ticks = 0;
-	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
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
+	if (!(file->f_flags & O_NONBLOCK))
+		wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
 	if (ctx->ticks) {
 		ticks = ctx->ticks;
 		if (ctx->expired && ctx->tintv.tv64) {
-- 
1.7.0

