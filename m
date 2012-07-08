Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2GHR4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 13:56:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61061 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2GHR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 13:56:02 -0400
Message-ID: <1341770155.1011.27.camel@mop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Kay Sievers <kay@vrfy.org>
To: Michael Neuling <mikey@neuling.org>
Cc: linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Sun, 08 Jul 2012 19:55:55 +0200
In-Reply-To: <21892.1341608647@neuling.org>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
	 <20120625235531.GB3652@kroah.com>
	 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org>
	 <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com>
	 <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
	 <16043.1341483625@neuling.org>
	 <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
	 <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org>
	 <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
	 <29711.1341545979@neuling.org> <30343.1341546469@neuling.org>
	 <CAPXgP13_cQUQLE4RSjACTzj28Pn6r3ZaPhjch2U+uwgi7YKcWA@ma il.gmail.com>
	 <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
	 <21892.1341608647@neuling.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 07:04 +1000, Michael Neuling wrote:
> Whole kmsg below.

I guess I have an idea now what's going on.

> 4,47,0;WARNING: at /scratch/mikey/src/linux-ozlabs/arch/powerpc/sysdev/xics/xics-common.c:105
> 4,51,0;MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 24000042  XER: 22000000
> 4,54,0;TASK = c000000000b2dd80[0] 'swapper/0' THREAD: c000000000c24000 CPU: 0

This is the warning on CPU#1, all fine, all in one line.

> 6,74,0;console [tty0] enabled
> 6,75,0;console [hvc0] enabled

Now the boot consoles are registered, which replays the whole buffer
that was collected up to this point. During the entire time the console
semaphore needs to be held, and this can be quite a while.

> 4,87,24545;WARNING: at /scratch/mikey/src/linux-ozlabs/arch/powerpc/sysdev/xics/xics-common.c:105
> \4,91,24586;MSR: 9000000000021032 
> 4,92,24590;<
> 4,93,24594;SF
> 4,94,24599;,HV
> 4,95,24604;,ME
> 4,96,24609;,IR
> 4,97,24614;,DR
> 4,98,24619;,RI
> 4,99,24623;>
> 4,104,24661; CPU: 1

At the same time the CPU#2 prints the same warning with a continuation
line, but the buffer from CPU#1 can not be flushed to the console, nor
can the continuation line printk()s from CPU#2 be merged at this point.
The consoles are still locked and busy with replaying the old log
messages, so the new continuation data is just stored away in the record
buffer as it is coming in.
If the console would be registered a bit earlier, or the warning would
happen a bit later, we would probably not see any of this.

I can fake something like this just by holding the console semaphore
over a longer time and printing continuation lines with different CPUs
in a row.

The patch below seems to work for me. It is also here:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD

It only applies cleanly on top of this patch:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-syslog-1-byte-read.patch;hb=HEAD

Thanks,
Kay


Subject: kmsg: merge continuation records while printing

In (the unlikely) case our continuation merge buffer is busy, we unfortunately
can not merge further continuation printk()s into a single record and have to
store them separately, which leads to split-up output of these lines when they
are printed.

Add some flags about newlines and prefix existence to these records and try to
reconstruct the full line again, when the separated records are printed.
---
 kernel/printk.c |  119 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 77 insertions(+), 42 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -194,8 +194,10 @@ static int console_may_schedule;
  */
 
 enum log_flags {
-	LOG_DEFAULT = 0,
-	LOG_NOCONS = 1,		/* already flushed, do not print to console */
+	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
+	LOG_NEWLINE	= 2,	/* text ended with a newline */
+	LOG_PREFIX	= 4,	/* text started with a prefix */
+	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
 struct log {
@@ -217,6 +219,7 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
+static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -839,8 +842,8 @@ static size_t print_prefix(const struct
 	return len;
 }
 
-static size_t msg_print_text(const struct log *msg, bool syslog,
-			     char *buf, size_t size)
+static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+			     bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
@@ -849,6 +852,8 @@ static size_t msg_print_text(const struc
 	do {
 		const char *next = memchr(text, '\n', text_size);
 		size_t text_len;
+		bool prefix = true;
+		bool newline = true;
 
 		if (next) {
 			text_len = next - text;
@@ -858,19 +863,35 @@ static size_t msg_print_text(const struc
 			text_len = text_size;
 		}
 
+		if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+			prefix = false;
+
+		if (msg->flags & LOG_CONT) {
+			if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
+				prefix = false;
+
+			if (!(msg->flags & LOG_NEWLINE))
+				newline = false;
+		}
+
 		if (buf) {
 			if (print_prefix(msg, syslog, NULL) +
 			    text_len + 1>= size - len)
 				break;
 
-			len += print_prefix(msg, syslog, buf + len);
+			if (prefix)
+				len += print_prefix(msg, syslog, buf + len);
 			memcpy(buf + len, text, text_len);
 			len += text_len;
-			buf[len++] = '\n';
+			if (newline)
+				buf[len++] = '\n';
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
-			len += print_prefix(msg, syslog, NULL);
-			len += text_len + 1;
+			if (prefix)
+				len += print_prefix(msg, syslog, NULL);
+			len += text_len;
+			if (newline)
+				len++;
 		}
 
 		text = next;
@@ -898,6 +919,7 @@ static int syslog_print(char __user *buf
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
+			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -907,11 +929,12 @@ static int syslog_print(char __user *buf
 
 		skip = syslog_partial;
 		msg = log_from_idx(syslog_idx);
-		n = msg_print_text(msg, true, text, LOG_LINE_MAX);
+		n = msg_print_text(msg, syslog_prev, true, text, LOG_LINE_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
 			syslog_seq++;
+			syslog_prev = msg->flags;
 			n -= syslog_partial;
 			syslog_partial = 0;
 		} else if (!len){
@@ -954,6 +977,7 @@ static int syslog_print_all(char __user
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
+		enum log_flags prev;
 
 		if (clear_seq < log_first_seq) {
 			/* messages are gone, move to first available one */
@@ -967,10 +991,11 @@ static int syslog_print_all(char __user
 		 */
 		seq = clear_seq;
 		idx = clear_idx;
+		prev = 0;
 		while (seq < log_next_seq) {
 			struct log *msg = log_from_idx(idx);
 
-			len += msg_print_text(msg, true, NULL, 0);
+			len += msg_print_text(msg, prev, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -978,10 +1003,11 @@ static int syslog_print_all(char __user
 		/* move first record forward until length fits into the buffer */
 		seq = clear_seq;
 		idx = clear_idx;
+		prev = 0;
 		while (len > size && seq < log_next_seq) {
 			struct log *msg = log_from_idx(idx);
 
-			len -= msg_print_text(msg, true, NULL, 0);
+			len -= msg_print_text(msg, prev, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -990,17 +1016,19 @@ static int syslog_print_all(char __user
 		next_seq = log_next_seq;
 
 		len = 0;
+		prev = 0;
 		while (len >= 0 && seq < next_seq) {
 			struct log *msg = log_from_idx(idx);
 			int textlen;
 
-			textlen = msg_print_text(msg, true, text, LOG_LINE_MAX);
+			textlen = msg_print_text(msg, prev, true, text, LOG_LINE_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
 			}
 			idx = log_next(idx);
 			seq++;
+			prev = msg->flags;
 
 			raw_spin_unlock_irq(&logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
@@ -1013,6 +1041,7 @@ static int syslog_print_all(char __user
 				/* messages are gone, move to next one */
 				seq = log_first_seq;
 				idx = log_first_idx;
+				prev = 0;
 			}
 		}
 	}
@@ -1117,6 +1146,7 @@ int do_syslog(int type, char __user *buf
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
+			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -1127,18 +1157,18 @@ int do_syslog(int type, char __user *buf
 			 */
 			error = log_next_idx - syslog_idx;
 		} else {
-			u64 seq;
-			u32 idx;
+			u64 seq = syslog_seq;
+			u32 idx = syslog_idx;
+			enum log_flags prev = syslog_prev;
 
 			error = 0;
-			seq = syslog_seq;
-			idx = syslog_idx;
 			while (seq < log_next_seq) {
 				struct log *msg = log_from_idx(idx);
 
-				error += msg_print_text(msg, true, NULL, 0);
+				error += msg_print_text(msg, prev, true, NULL, 0);
 				idx = log_next(idx);
 				seq++;
+				prev = msg->flags;
 			}
 			error -= syslog_partial;
 		}
@@ -1408,10 +1438,9 @@ asmlinkage int vprintk_emit(int facility
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len;
+	enum log_flags lflags = 0;
 	unsigned long flags;
 	int this_cpu;
-	bool newline = false;
-	bool prefix = false;
 	int printed_len = 0;
 
 	boot_delay_msec();
@@ -1450,7 +1479,7 @@ asmlinkage int vprintk_emit(int facility
 		recursion_bug = 0;
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_DEFAULT, 0,
+		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
 			  NULL, 0, recursion_msg, printed_len);
 	}
 
@@ -1463,7 +1492,7 @@ asmlinkage int vprintk_emit(int facility
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
-		newline = true;
+		lflags |= LOG_NEWLINE;
 	}
 
 	/* strip syslog prefix and extract log level or control flags */
@@ -1473,7 +1502,7 @@ asmlinkage int vprintk_emit(int facility
 			if (level == -1)
 				level = text[1] - '0';
 		case 'd':	/* KERN_DEFAULT */
-			prefix = true;
+			lflags |= LOG_PREFIX;
 		case 'c':	/* KERN_CONT */
 			text += 3;
 			text_len -= 3;
@@ -1483,22 +1512,20 @@ asmlinkage int vprintk_emit(int facility
 	if (level == -1)
 		level = default_message_loglevel;
 
-	if (dict) {
-		prefix = true;
-		newline = true;
-	}
+	if (dict)
+		lflags |= LOG_PREFIX|LOG_NEWLINE;
 
-	if (!newline) {
+	if (!(lflags & LOG_NEWLINE)) {
 		/*
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && (prefix || cont.owner != current))
+		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
 			cont_flush();
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, LOG_DEFAULT, 0,
+			log_store(facility, level, lflags | LOG_CONT, 0,
 				  dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
@@ -1510,13 +1537,13 @@ asmlinkage int vprintk_emit(int facility
 		 * flush it out and store this line separately.
 		 */
 		if (cont.len && cont.owner == current) {
-			if (!prefix)
+			if (!(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, text, text_len);
 			cont_flush();
 		}
 
 		if (!stored)
-			log_store(facility, level, LOG_DEFAULT, 0,
+			log_store(facility, level, lflags, 0,
 				  dict, dictlen, text, text_len);
 	}
 	printed_len += text_len;
@@ -1615,8 +1642,8 @@ static struct cont {
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct log *msg, bool syslog,
-			     char *buf, size_t size) { return 0; }
+static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
 #endif /* CONFIG_PRINTK */
@@ -1892,6 +1919,7 @@ void wake_up_klogd(void)
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
+static enum log_flags console_prev;
 
 /**
  * console_unlock - unlock the console system
@@ -1952,6 +1980,7 @@ again:
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
+			console_prev = 0;
 		}
 skip:
 		if (console_seq == log_next_seq)
@@ -1975,10 +2004,11 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, false, text, sizeof(text));
-
+		len = msg_print_text(msg, console_prev, false,
+				     text, sizeof(text));
 		console_idx = log_next(console_idx);
 		console_seq++;
+		console_prev = msg->flags;
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
@@ -2241,6 +2271,7 @@ void register_console(struct console *ne
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
+		console_prev = syslog_prev;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
@@ -2534,8 +2565,7 @@ bool kmsg_dump_get_line(struct kmsg_dump
 	}
 
 	msg = log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, syslog,
-			      line, size);
+	l = msg_print_text(msg, 0, syslog, line, size);
 
 	dumper->cur_idx = log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -2575,6 +2605,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
+	enum log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
@@ -2597,23 +2628,27 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	/* calculate length of entire buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
+	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct log *msg = log_from_idx(idx);
 
-		l += msg_print_text(msg, true, NULL, 0);
+		l += msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
+		prev = msg->flags;
 	}
 
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
+	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
 		struct log *msg = log_from_idx(idx);
 
-		l -= msg_print_text(msg, true, NULL, 0);
+		l -= msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
+		prev = msg->flags;
 	}
 
 	/* last message in next interation */
@@ -2621,14 +2656,14 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	next_idx = idx;
 
 	l = 0;
+	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct log *msg = log_from_idx(idx);
 
-		l += msg_print_text(msg, syslog,
-				    buf + l, size - l);
-
+		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
 		idx = log_next(idx);
 		seq++;
+		prev = msg->flags;
 	}
 
 	dumper->next_seq = next_seq;


