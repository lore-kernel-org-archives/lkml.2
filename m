Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2F1BjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:39:01 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43665 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2F1Bi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:38:59 -0400
Message-ID: <1340869133.876.10.camel@mop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Kay Sievers <kay@vrfy.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Thu, 28 Jun 2012 09:38:53 +0200
In-Reply-To: <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
	 <20120625235531.GB3652@kroah.com>
	 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop>
	 <1340810038.16702.16.camel@gandalf.stny.rr.com>
	 <1340810283.16702.19.camel@gandalf.stny.rr.com>
	 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 11:26 -0400, Kay Sievers wrote:
> On Wed, Jun 27, 2012 at 11:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed, 2012-06-27 at 11:13 -0400, Steven Rostedt wrote:
> >
> >> I just tested this patch and it boots fine for me.
> >
> > Of course after sending this, I rebooted to the same kernel and it
> > locked up :-p
> 
> Thanks for testing it. Greg had some issues too, which I can't
> reproduce it on any of my boxes. I'll have a look ...

Here is an updated version, that should be look a bit cleaner.

It passes all my tests here, including the fake kernel module that has
threads racing against each other. With that, the console output gets a
bit disturbed now without the buffering, but the recorded log still
looks all fine.

Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: [PATCH] printk: flush continuation lines immediately to console

Continuation lines are buffered internally, intended to merge the
chunked printk()s into a single record, and to isolate potentially
racy continuation users from usual terminated line users.

This though, has the effect that partial lines are not printed to
the console in the moment they are emitted. In case the kernel
crashes in the meantime, the potentially interesting printed
information would never reach the consoles.

Here we share the continuation buffer with the console copy logic,
and partial lines are always immediately flushed to the available
consoles. They are still buffered internally to improve the
readability and integrity of the messages and minimize the amount
of needed record headers to store.

Signed-off-by: Kay Sievers <kay@vrfy.org>
---

 kernel/printk.c |  244 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 176 insertions(+), 68 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index cdfba44..fbf4d0b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -193,12 +193,19 @@ static int console_may_schedule;
  * separated by ',', and find the message after the ';' character.
  */
 
+enum log_flags {
+	LOG_DEFAULT = 0,
+	LOG_NOCONS = 1,		/* already flushed, do not print to console */
+};
+
 struct log {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
 	u16 len;		/* length of entire record */
 	u16 text_len;		/* length of text buffer */
 	u16 dict_len;		/* length of dictionary buffer */
-	u16 level;		/* syslog level + facility */
+	u8 facility;		/* syslog facility */
+	u8 flags:5;		/* internal record flags */
+	u8 level:3;		/* syslog level */
 };
 
 /*
@@ -286,6 +293,7 @@ static u32 log_next(u32 idx)
 
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
+		      enum log_flags flags, u64 ts_nsec,
 		      const char *dict, u16 dict_len,
 		      const char *text, u16 text_len)
 {
@@ -329,8 +337,13 @@ static void log_store(int facility, int level,
 	msg->text_len = text_len;
 	memcpy(log_dict(msg), dict, dict_len);
 	msg->dict_len = dict_len;
-	msg->level = (facility << 3) | (level & 7);
-	msg->ts_nsec = local_clock();
+	msg->facility = facility;
+	msg->level = level & 7;
+	msg->flags = flags & 0x1f;
+	if (ts_nsec > 0)
+		msg->ts_nsec = ts_nsec;
+	else
+		msg->ts_nsec = local_clock();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
 	msg->len = sizeof(struct log) + text_len + dict_len + pad_len;
 
@@ -446,7 +459,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	ts_usec = msg->ts_nsec;
 	do_div(ts_usec, 1000);
 	len = sprintf(user->buf, "%u,%llu,%llu;",
-		      msg->level, user->seq, ts_usec);
+		      (msg->facility << 3) | msg->level, user->seq, ts_usec);
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
@@ -787,6 +800,21 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+static size_t print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	if (!printk_time)
+		return 0;
+
+	if (!buf)
+		return 15;
+
+	rem_nsec = do_div(ts, 1000000000);
+	return sprintf(buf, "[%5lu.%06lu] ",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
@@ -803,18 +831,7 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 		}
 	}
 
-	if (printk_time) {
-		if (buf) {
-			unsigned long long ts = msg->ts_nsec;
-			unsigned long rem_nsec = do_div(ts, 1000000000);
-
-			len += sprintf(buf + len, "[%5lu.%06lu] ",
-					 (unsigned long) ts, rem_nsec / 1000);
-		} else {
-			len += 15;
-		}
-	}
-
+	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
 	return len;
 }
 
@@ -1294,15 +1311,92 @@ static inline void printk_delay(void)
 	}
 }
 
+/*
+ * Continuation lines are buffered, and not committed to the record buffer
+ * until the line is complete, or a race forces it. The line fragments
+ * though, are printed immediately to the consoles to ensure everything has
+ * reached the console in case of a kernel crash.
+ */
+static struct cont {
+	char buf[LOG_LINE_MAX];
+	size_t len;			/* length == 0 means unused buffer */
+	size_t cons;			/* bytes written to console */
+	struct task_struct *owner;	/* task of first print*/
+	u64 ts_nsec;			/* time of first print */
+	u8 level;			/* log level of first message */
+	u8 facility;			/* log level of first message */
+	bool flushed:1;			/* buffer sealed and committed */
+} cont;
+
+static void cont_flush(void)
+{
+	if (cont.flushed)
+		return;
+	if (cont.len == 0)
+		return;
+
+	log_store(cont.facility, cont.level, LOG_NOCONS, cont.ts_nsec,
+		  NULL, 0, cont.buf, cont.len);
+
+	cont.flushed = true;
+}
+
+static bool cont_add(int facility, int level, const char *text, size_t len)
+{
+	if (cont.len && cont.flushed)
+		return false;
+
+	if (cont.len + len > sizeof(cont.buf)) {
+		cont_flush();
+		return false;
+	}
+
+	if (!cont.len) {
+		cont.facility = facility;
+		cont.level = level;
+		cont.owner = current;
+		cont.ts_nsec = local_clock();
+		cont.cons = 0;
+		cont.flushed = false;
+	}
+
+	memcpy(cont.buf + cont.len, text, len);
+	cont.len += len;
+	return true;
+}
+
+static size_t cont_print_text(char *text, size_t size)
+{
+	size_t textlen = 0;
+	size_t len;
+
+	if (cont.cons == 0) {
+		textlen += print_time(cont.ts_nsec, text);
+		size -= textlen;
+	}
+
+	len = cont.len - cont.cons;
+	if (len > 0) {
+		if (len+1 > size)
+			len = size-1;
+		memcpy(text + textlen, cont.buf + cont.cons, len);
+		textlen += len;
+		cont.cons = cont.len;
+	}
+
+	if (cont.flushed) {
+		text[textlen++] = '\n';
+		/* got everything, release buffer */
+		cont.len = 0;
+	}
+	return textlen;
+}
+
 asmlinkage int vprintk_emit(int facility, int level,
 			    const char *dict, size_t dictlen,
 			    const char *fmt, va_list args)
 {
 	static int recursion_bug;
-	static char cont_buf[LOG_LINE_MAX];
-	static size_t cont_len;
-	static int cont_level;
-	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len;
@@ -1348,7 +1442,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, NULL, 0, recursion_msg, printed_len);
+		log_store(0, 2, LOG_DEFAULT, 0,
+			  NULL, 0, recursion_msg, printed_len);
 	}
 
 	/*
@@ -1386,55 +1481,38 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	if (!newline) {
-		if (cont_len && (prefix || cont_task != current)) {
-			/*
-			 * Flush earlier buffer, which is either from a
-			 * different thread, or when we got a new prefix.
-			 */
-			log_store(facility, cont_level, NULL, 0, cont_buf, cont_len);
-			cont_len = 0;
-		}
-
-		if (!cont_len) {
-			cont_level = level;
-			cont_task = current;
-		}
+		/*
+		 * Flush the conflicting buffer. An earlier newline was missing,
+		 * or another task also prints continuation lines.
+		 */
+		if (cont.len && (prefix || cont.owner != current))
+			cont_flush();
 
-		/* buffer or append to earlier buffer from the same thread */
-		if (cont_len + text_len > sizeof(cont_buf))
-			text_len = sizeof(cont_buf) - cont_len;
-		memcpy(cont_buf + cont_len, text, text_len);
-		cont_len += text_len;
+		/* buffer line if possible, otherwise store it right away */
+		if (!cont_add(facility, level, text, text_len))
+			log_store(facility, level, LOG_DEFAULT, 0,
+				  dict, dictlen, text, text_len);
 	} else {
-		if (cont_len && cont_task == current) {
-			if (prefix) {
-				/*
-				 * New prefix from the same thread; flush. We
-				 * either got no earlier newline, or we race
-				 * with an interrupt.
-				 */
-				log_store(facility, cont_level,
-					  NULL, 0, cont_buf, cont_len);
-				cont_len = 0;
-			}
+		bool stored = false;
 
-			/* append to the earlier buffer and flush */
-			if (cont_len + text_len > sizeof(cont_buf))
-				text_len = sizeof(cont_buf) - cont_len;
-			memcpy(cont_buf + cont_len, text, text_len);
-			cont_len += text_len;
-			log_store(facility, cont_level,
-				  NULL, 0, cont_buf, cont_len);
-			cont_len = 0;
-			cont_task = NULL;
-			printed_len = cont_len;
-		} else {
-			/* ordinary single and terminated line */
-			log_store(facility, level,
-				  dict, dictlen, text, text_len);
-			printed_len = text_len;
+		/*
+		 * Flush the conflicting buffer. An earlier newline was missing,
+		 * or we race with a continuation line from an interrupt.
+		 */
+		if (cont.len && prefix && cont.owner == current)
+			cont_flush();
+
+		/* Merge with our buffer if possible; flush it in any case */
+		if (cont.len && cont.owner == current) {
+			stored = cont_add(facility, level, text, text_len);
+			cont_flush();
 		}
+
+		if (!stored)
+			log_store(facility, level, LOG_DEFAULT, 0,
+				  dict, dictlen, text, text_len);
 	}
+	printed_len += text_len;
 
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
@@ -1521,11 +1599,18 @@ EXPORT_SYMBOL(printk);
 #else
 
 #define LOG_LINE_MAX 0
+static struct cont {
+	size_t len;
+	size_t cons;
+	u8 level;
+	bool flushed:1;
+} cont;
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 static size_t msg_print_text(const struct log *msg, bool syslog,
 			     char *buf, size_t size) { return 0; }
+static size_t cont_print_text(char *text, size_t size) { return 0; }
 
 #endif /* CONFIG_PRINTK */
 
@@ -1817,6 +1902,7 @@ static u32 console_idx;
  */
 void console_unlock(void)
 {
+	static char text[LOG_LINE_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
@@ -1829,10 +1915,23 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
+	/* flush buffered message fragment immediately to console */
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	if (cont.len && (cont.cons < cont.len || cont.flushed)) {
+		size_t len;
+
+		len = cont_print_text(text, sizeof(text));
+		raw_spin_unlock(&logbuf_lock);
+		stop_critical_timings();
+		call_console_drivers(cont.level, text, len);
+		start_critical_timings();
+		local_irq_restore(flags);
+	} else
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
 again:
 	for (;;) {
 		struct log *msg;
-		static char text[LOG_LINE_MAX];
 		size_t len;
 		int level;
 
@@ -1847,13 +1946,22 @@ again:
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
 		}
-
+skip:
 		if (console_seq == log_next_seq)
 			break;
 
 		msg = log_from_idx(console_idx);
-		level = msg->level & 7;
+		if (msg->flags & LOG_NOCONS) {
+			/*
+			 * Skip record we have buffered and already printed
+			 * directly to the console when we received it.
+			 */
+			console_idx = log_next(console_idx);
+			console_seq++;
+			goto skip;
+		}
 
+		level = msg->level;
 		len = msg_print_text(msg, false, text, sizeof(text));
 
 		console_idx = log_next(console_idx);


