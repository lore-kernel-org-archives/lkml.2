Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2KMXSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:18:09 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63805 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2KMXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:18:07 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 08/12] printk: refactor locking in console_unlock()
Date: Wed, 14 Nov 2012 00:13:05 +0100
Message-Id: <1352848389-23114-9-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, console_unlock() acquires and releases the logbuf_lock quite
often, including saving and restoring the interrupt state. While we can
do only so much about the former, because we should not block logging
while writing to the console, the latter is unnecessary and can be
avoided.

Still, whenever we released the logbuf_lock for a moment, other threads
might have added new data that we must process. This might include the
continuation buffer. That means, after we reacquire the lock, we must
check the continuation buffer again. And, equally important, if the
continuation buffer turns out to be empty, we must proceed to the
check for remaining logged messages without dropping the lock.

This resolves an issue where console message are output in the wrong order,
because after the retry jump at the bottom the continuation buffer is not
checked again, but left until another call to console_unlock().

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
This is not yet the final state I envision for this function, but it is
a working middle step. That is, the loop in console_cont_flush() is
rather ugly, and call_console_drivers() is still called from two places
with the same code around. This calls for even more refactoring.

Also, one issue still remains: we should check the continuation buffer
also after printing all log messages, as we postpone printing the
continuation buffer in certain situations. So there could possibly
be something left.

And one more: the retry check at the bottom should also include the
continuation buffer.
---
 kernel/printk.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 7a961d4..e78bbd9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1995,13 +1995,11 @@ void wake_up_klogd(void)
 
 static void console_cont_flush(char *text, size_t size)
 {
-	unsigned long flags;
 	size_t len;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-
+again:
 	if (!cont.msg.text_len)
-		goto out;
+		return;
 
 	/*
 	 * We still queue earlier records, likely because the console was
@@ -2009,17 +2007,18 @@ static void console_cont_flush(char *text, size_t size)
 	 * did not flush any fragment so far, so just let it queue up.
 	 */
 	if (console_seq < log_next_seq && !cont.cons)
-		goto out;
+		return;
 
 	len = cont_print_text(text, size);
+	if (!len)
+		return;
+
 	raw_spin_unlock(&logbuf_lock);
 	stop_critical_timings();
 	call_console_drivers(cont.msg.level, text, len);
 	start_critical_timings();
-	local_irq_restore(flags);
-	return;
-out:
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_lock(&logbuf_lock);
+	goto again;
 }
 
 /**
@@ -2051,15 +2050,15 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
-	/* flush buffered message fragment immediately to console */
-	console_cont_flush(text, sizeof(text));
 again:
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
 	for (;;) {
 		struct log *msg;
 		size_t len;
 		int level;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		/* flush buffered message fragment immediately to console */
+		console_cont_flush(text, sizeof(text));
 
 		if (console_seq < log_first_seq) {
 			/* messages are gone, move to first one */
@@ -2095,12 +2094,12 @@ skip:
 		console_idx = log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
-		raw_spin_unlock(&logbuf_lock);
 
+		raw_spin_unlock(&logbuf_lock);
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
-		local_irq_restore(flags);
+		raw_spin_lock(&logbuf_lock);
 	}
 	console_locked = 0;
 
-- 
1.8.0.316.g291341c.dirty

