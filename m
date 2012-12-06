Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946277Ab2LFRKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:10:12 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65308 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2LFRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:10:06 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 08/14] printk: refactor locking in console_unlock()
Date: Thu,  6 Dec 2012 18:06:05 +0100
Message-Id: <1354813571-11253-9-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
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

(And, at the end, the retry check must include the continuation buffer.)

This resolves an issue where console message are output in the wrong order,
because after the retry jump at the bottom the continuation buffer is not
checked again, but left until another call to console_unlock().

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
This is not yet the final state I envision for this function, but it is
a working middle step. That is, the loop in console_cont_flush() is
rather ugly, and call_console_drivers() is still called from two places
with the same code around. This calls for even more refactoring.

v2:
- add cont buffer to retry check
---
 kernel/printk.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index b6c4eae..075fbd4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1726,6 +1726,7 @@ static struct cont {
 	size_t cons;
 	u8 level;
 	bool flushed:1;
+	enum log_flags flags;
 } cont;
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
@@ -2005,13 +2006,11 @@ void wake_up_klogd(void)
 
 static void console_cont_flush(char *text, size_t size)
 {
-	unsigned long flags;
 	size_t len;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-
+again:
 	if (!cont.len)
-		goto out;
+		return;
 
 	/*
 	 * We still queue earlier records, likely because the console was
@@ -2019,17 +2018,18 @@ static void console_cont_flush(char *text, size_t size)
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
 	call_console_drivers(cont.level, text, len);
 	start_critical_timings();
-	local_irq_restore(flags);
-	return;
-out:
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_lock(&logbuf_lock);
+	goto again;
 }
 
 /**
@@ -2061,15 +2061,15 @@ void console_unlock(void)
 
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
@@ -2105,12 +2105,12 @@ skip:
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
 
@@ -2129,7 +2129,9 @@ skip:
 	 * flush, no worries.
 	 */
 	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
+	retry = console_seq != log_next_seq ||
+		(cont.len && (cont.cons != cont.len ||
+			      cont.flags & LOG_NEWLINE));
 	if (seen_seq != log_next_seq) {
 		wake_klogd = true;
 		seen_seq = log_next_seq;
-- 
1.8.0.1.20.g7c65b2e.dirty

