Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2GUAaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:30:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2GUAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:30:10 -0400
Date: Fri, 20 Jul 2012 17:28:07 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3/4] printk: Implement some unlocked kmsg_dump functions
Message-ID: <20120721002807.GC2213@lizard>
References: <20120721002529.GA20567@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120721002529.GA20567@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If used from KDB, the locked variants are prone to deadlocks (suppose we
got to the debugger w/ the logbuf lock held).

So, we have to implement a few routines that grab no logbuf lock.

Yet we don't need these functions in modules, so we don't export them.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kmsg_dump.h |   16 +++++++++++
 kernel/printk.c           |   68 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index d6bd501..2e7a1e0 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -55,12 +55,17 @@ struct kmsg_dumper {
 #ifdef CONFIG_PRINTK
 void kmsg_dump(enum kmsg_dump_reason reason);
 
+bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
+			       char *line, size_t size, size_t *len);
+
 bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 			char *line, size_t size, size_t *len);
 
 bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 			  char *buf, size_t size, size_t *len);
 
+void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper);
+
 void kmsg_dump_rewind(struct kmsg_dumper *dumper);
 
 int kmsg_dump_register(struct kmsg_dumper *dumper);
@@ -71,6 +76,13 @@ static inline void kmsg_dump(enum kmsg_dump_reason reason)
 {
 }
 
+static inline bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper,
+					     bool syslog, const char *line,
+					     size_t size, size_t *len)
+{
+	return false;
+}
+
 static inline bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 				const char *line, size_t size, size_t *len)
 {
@@ -83,6 +95,10 @@ static inline bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	return false;
 }
 
+static inline void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
+{
+}
+
 static inline void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 {
 }
diff --git a/kernel/printk.c b/kernel/printk.c
index c812967..ac4bc9e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2510,7 +2510,7 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 }
 
 /**
- * kmsg_dump_get_line - retrieve one kmsg log line
+ * kmsg_dump_get_line_nolock - retrieve one kmsg log line (unlocked version)
  * @dumper: registered kmsg dumper
  * @syslog: include the "<4>" prefixes
  * @line: buffer to copy the line to
@@ -2525,11 +2525,12 @@ void kmsg_dump(enum kmsg_dump_reason reason)
  *
  * A return value of FALSE indicates that there are no more records to
  * read.
+ *
+ * The function is similar to kmsg_dump_get_line(), but grabs no locks.
  */
-bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
-			char *line, size_t size, size_t *len)
+bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
+			       char *line, size_t size, size_t *len)
 {
-	unsigned long flags;
 	struct log *msg;
 	size_t l = 0;
 	bool ret = false;
@@ -2537,7 +2538,6 @@ bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
 	if (dumper->cur_seq < log_first_seq) {
 		/* messages are gone, move to first available one */
 		dumper->cur_seq = log_first_seq;
@@ -2545,10 +2545,8 @@ bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 	}
 
 	/* last entry */
-	if (dumper->cur_seq >= log_next_seq) {
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (dumper->cur_seq >= log_next_seq)
 		goto out;
-	}
 
 	msg = log_from_idx(dumper->cur_idx);
 	l = msg_print_text(msg, 0, syslog, line, size);
@@ -2556,12 +2554,41 @@ bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 	dumper->cur_idx = log_next(dumper->cur_idx);
 	dumper->cur_seq++;
 	ret = true;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 out:
 	if (len)
 		*len = l;
 	return ret;
 }
+
+/**
+ * kmsg_dump_get_line - retrieve one kmsg log line
+ * @dumper: registered kmsg dumper
+ * @syslog: include the "<4>" prefixes
+ * @line: buffer to copy the line to
+ * @size: maximum size of the buffer
+ * @len: length of line placed into buffer
+ *
+ * Start at the beginning of the kmsg buffer, with the oldest kmsg
+ * record, and copy one record into the provided buffer.
+ *
+ * Consecutive calls will return the next available record moving
+ * towards the end of the buffer with the youngest messages.
+ *
+ * A return value of FALSE indicates that there are no more records to
+ * read.
+ */
+bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
+			char *line, size_t size, size_t *len)
+{
+	unsigned long flags;
+	bool ret;
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	ret = kmsg_dump_get_line_nolock(dumper, syslog, line, size, len);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
 
 /**
@@ -2664,6 +2691,24 @@ out:
 EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
 
 /**
+ * kmsg_dump_rewind_nolock - reset the interator (unlocked version)
+ * @dumper: registered kmsg dumper
+ *
+ * Reset the dumper's iterator so that kmsg_dump_get_line() and
+ * kmsg_dump_get_buffer() can be called again and used multiple
+ * times within the same dumper.dump() callback.
+ *
+ * The function is similar to kmsg_dump_rewind(), but grabs no locks.
+ */
+void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
+{
+	dumper->cur_seq = clear_seq;
+	dumper->cur_idx = clear_idx;
+	dumper->next_seq = log_next_seq;
+	dumper->next_idx = log_next_idx;
+}
+
+/**
  * kmsg_dump_rewind - reset the interator
  * @dumper: registered kmsg dumper
  *
@@ -2676,10 +2721,7 @@ void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	dumper->cur_seq = clear_seq;
-	dumper->cur_idx = clear_idx;
-	dumper->next_seq = log_next_seq;
-	dumper->next_idx = log_next_idx;
+	kmsg_dump_rewind_nolock(dumper);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
-- 
1.7.10.4

