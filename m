Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2GRR4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:56:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2GRR4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:56:40 -0400
Date: Wed, 18 Jul 2012 13:56:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] printk: Export struct log size and member offsets
 through vmcoreinfo
Message-ID: <20120718175625.GD21746@redhat.com>
References: <20120718171812.GC21746@redhat.com>
 <CAPXgP12PioibfQhtAB0fCzL1MXmZvfvQqOGu_ZM0D8Sx4Vq7+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP12PioibfQhtAB0fCzL1MXmZvfvQqOGu_ZM0D8Sx4Vq7+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 07:27:08PM +0200, Kay Sievers wrote:
> On Wed, Jul 18, 2012 at 7:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Currently I am not exporting log "level" info as that is a bitfield and
> > offsetof() bitfields can't be calculated.
> 
> We could make the level the lower 3 bits of the byte, export the byte,
> and define that only 3 bits of the byte are valid? Would that help?

Yes, that should work. Here is the prototype patch which stores 5 bits
of flag and 3 bits of level in a byte. I have not tested it yet, but
if you like the approach, I will test it.

Thanks
Vivek


---
 kernel/printk.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c	2012-07-20 14:02:42.000000000 -0400
+++ linux-2.6/kernel/printk.c	2012-07-20 16:34:24.088964153 -0400
@@ -200,14 +200,19 @@ enum log_flags {
 	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
+#define LOG_FLAG_SHIFT		3
+#define LOG_LEVEL_MASK		((1 << LOG_FLAG_SHIFT) - 1)
+#define LOG_FLAGS(log)		((log)->flags_level >> LOG_FLAG_SHIFT)
+#define LOG_LEVEL(log)		(((log)->flags_level) & LOG_LEVEL_MASK)
+
 struct log {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
 	u16 len;		/* length of entire record */
 	u16 text_len;		/* length of text buffer */
 	u16 dict_len;		/* length of dictionary buffer */
 	u8 facility;		/* syslog facility */
-	u8 flags:5;		/* internal record flags */
-	u8 level:3;		/* syslog level */
+	u8 flags_level;		/* 5 bit internal record flags, 3 bits syslog
+				 * level */
 };
 
 /*
@@ -342,8 +347,8 @@ static void log_store(int facility, int 
 	memcpy(log_dict(msg), dict, dict_len);
 	msg->dict_len = dict_len;
 	msg->facility = facility;
-	msg->level = level & 7;
-	msg->flags = flags & 0x1f;
+	msg->flags_level = level & 7;
+	msg->flags_level |= (flags & 0x1f) << LOG_FLAG_SHIFT;
 	if (ts_nsec > 0)
 		msg->ts_nsec = ts_nsec;
 	else
@@ -463,7 +468,8 @@ static ssize_t devkmsg_read(struct file 
 	ts_usec = msg->ts_nsec;
 	do_div(ts_usec, 1000);
 	len = sprintf(user->buf, "%u,%llu,%llu;",
-		      (msg->facility << 3) | msg->level, user->seq, ts_usec);
+		      (msg->facility << 3) | LOG_LEVEL(msg), user->seq,
+	 	      ts_usec);
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
@@ -655,6 +661,8 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_OFFSET(log, len);
 	VMCOREINFO_OFFSET(log, text_len);
 	VMCOREINFO_OFFSET(log, dict_len);
+	VMCOREINFO_OFFSET(log, flags_level);
+	VMCOREINFO_LENGTH(log_level_bits, 3);
 }
 #endif
 
@@ -831,7 +839,7 @@ static size_t print_time(u64 ts, char *b
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
-	unsigned int prefix = (msg->facility << 3) | msg->level;
+	unsigned int prefix = (msg->facility << 3) | LOG_LEVEL(msg);
 
 	if (syslog) {
 		if (buf) {
@@ -860,14 +868,14 @@ static size_t msg_print_text(const struc
 	bool newline = true;
 	size_t len = 0;
 
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+	if ((prev & LOG_CONT) && !(LOG_FLAGS(msg) & LOG_PREFIX))
 		prefix = false;
 
-	if (msg->flags & LOG_CONT) {
+	if (LOG_FLAGS(msg) & LOG_CONT) {
 		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
 			prefix = false;
 
-		if (!(msg->flags & LOG_NEWLINE))
+		if (!(LOG_FLAGS(msg) & LOG_NEWLINE))
 			newline = false;
 	}
 
@@ -944,7 +952,7 @@ static int syslog_print(char __user *buf
 			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
 			syslog_seq++;
-			syslog_prev = msg->flags;
+			syslog_prev = LOG_FLAGS(msg);
 			n -= syslog_partial;
 			syslog_partial = 0;
 		} else if (!len){
@@ -1038,7 +1046,7 @@ static int syslog_print_all(char __user 
 			}
 			idx = log_next(idx);
 			seq++;
-			prev = msg->flags;
+			prev = LOG_FLAGS(msg);
 
 			raw_spin_unlock_irq(&logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
@@ -1178,7 +1186,7 @@ int do_syslog(int type, char __user *buf
 				error += msg_print_text(msg, prev, true, NULL, 0);
 				idx = log_next(idx);
 				seq++;
-				prev = msg->flags;
+				prev = LOG_FLAGS(msg);
 			}
 			error -= syslog_partial;
 		}
@@ -1979,6 +1987,7 @@ again:
 		struct log *msg;
 		size_t len;
 		int level;
+		u16 log_flags;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		if (seen_seq != log_next_seq) {
@@ -1997,7 +2006,7 @@ skip:
 			break;
 
 		msg = log_from_idx(console_idx);
-		if (msg->flags & LOG_NOCONS) {
+		if (LOG_FLAGS(msg) & LOG_NOCONS) {
 			/*
 			 * Skip record we have buffered and already printed
 			 * directly to the console when we received it.
@@ -2009,16 +2018,17 @@ skip:
 			 * CON_PRINTBUFFER console. Clear the flag so we
 			 * will properly dump everything later.
 			 */
-			msg->flags &= ~LOG_NOCONS;
+			log_flags = LOG_FLAGS(msg) & ~ LOG_NOCONS;
+			msg->flags_level = log_flags << LOG_FLAG_SHIFT | LOG_LEVEL(msg);
 			goto skip;
 		}
 
-		level = msg->level;
+		level = LOG_LEVEL(msg);
 		len = msg_print_text(msg, console_prev, false,
 				     text, sizeof(text));
 		console_idx = log_next(console_idx);
 		console_seq++;
-		console_prev = msg->flags;
+		console_prev = LOG_FLAGS(msg);
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
@@ -2645,7 +2655,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 		l += msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
+		prev = LOG_FLAGS(msg);
 	}
 
 	/* move first record forward until length fits into the buffer */
@@ -2658,7 +2668,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 		l -= msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
+		prev = LOG_FLAGS(msg);
 	}
 
 	/* last message in next interation */
@@ -2673,7 +2683,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
+		prev = LOG_FLAGS(msg);
 	}
 
 	dumper->next_seq = next_seq;
