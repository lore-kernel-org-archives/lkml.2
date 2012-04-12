Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485Ab2DLKBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:01:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56975 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab2DLKBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:01:42 -0400
From: handai.szj@gmail.com
To: linux-kernel@vger.kernel.org
Cc: davidel@xmailserver.org, akpm@linux-foundation.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH] eventfd: change int to __u64 in eventfd_signal()
Date: Thu, 12 Apr 2012 18:01:20 +0800
Message-Id: <4f86a805.473f440a.2915.0cf3@mx.google.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

eventfd_ctx->count is an __u64 counter which is allowed to reach ULLONG_MAX.
Now eventfd_write() add an __u64 value to "count", but kernel side 
eventfd_signal() only add an int value to it. So make them consistent here.  

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

---
 fs/eventfd.c            |    4 ++--
 include/linux/eventfd.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index dba15fe..9e63e42 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -51,7 +51,7 @@ struct eventfd_ctx {
  *
  * -EINVAL    : The value of @n is negative.
  */
-int eventfd_signal(struct eventfd_ctx *ctx, int n)
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	unsigned long flags;
 
@@ -59,7 +59,7 @@ int eventfd_signal(struct eventfd_ctx *ctx, int n)
 		return -EINVAL;
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ULLONG_MAX - ctx->count < n)
-		n = (int) (ULLONG_MAX - ctx->count);
+		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, POLLIN);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 91bb4f2..3c3ef19 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -34,7 +34,7 @@ void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
-int eventfd_signal(struct eventfd_ctx *ctx, int n);
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
 ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt);
-- 
1.7.4.1

