Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab2EMVbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 17:31:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45890 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2EMVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 17:31:23 -0400
Message-ID: <1336944646.1007.5.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Sun, 13 May 2012 23:30:46 +0200
In-Reply-To: <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
	 <1336571457.30189.29.camel@joe2Laptop>
	 <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
	 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
	 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
	 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 12:35 +0200, Sasha Levin wrote:
> On Thu, May 10, 2012 at 4:30 AM, Kay Sievers <kay@vrfy.org> wrote:
> > On Wed, 2012-05-09 at 16:06 -0700, Greg Kroah-Hartmann wrote:
> >> On Wed, May 09, 2012 at 04:02:40PM -0700, Yinghai Lu wrote:
> >> > On Wed, May 9, 2012 at 7:37 AM, Kay Sievers <kay@vrfy.org> wrote:
> >> > >
> >> > >> Changing printk semantics and trying to stabilize
> >> > >> printk message content are bad ideas though.
> >> > >
> >> > > Again, nobody talks about content of here.
> >> >
> >> > printk_time=1 does not work anymore with this patch on serial console.
> >>
> >> Known issue, I think Kay is working on the solution for this right
> >> now...
> >
> > Sure, and this seems to work for me.
> >
> > Thanks,
> > Kay
> >
> >
> > From: Kay Sievers <kay@vrfy.org>
> > Subject: printk() - restore timestamp printing at console output
> >
> > The output of the timestamps got lost with the conversion of the
> > kmsg buffer to records; restore the old behavior.
> >
> > Document, that CONFIG_PRINTK_TIME now only controls the output of
> > the timestamps in the syslog() system call and on the console, and
> > not the recording of the timestamps.
> >
> > Signed-off-by: Kay Sievers <kay@vrfy.org>
> > ---
> 
> This has a small issue with the way timing is printed compared to how
> it worked previously.
> 
> Consider the following case:
> 
>     printk("\n foo \n bar \n zoot")
> 
> Previously, you would see timing on each line of the print, but now
> you see it only on the first.

Does this fix it for you? It should fully restore the current behavior
for multi-line printing.

Thanks,
Kay



From: Kay Sievers <kay@vrfy.org>
Subject: printk() - restore prefix/timestamp printing for multi-newline strings

Calls like:
  printk("\n *** DEADLOCK ***\n\n");
will print 3 properly indented, separated, syslog + timestamp prefixed lines in
the log output.


Reported-By: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---

 printk.c |  127 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 76 insertions(+), 51 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index c42faf9..ee312c7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -448,7 +448,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
-		char c = log_text(msg)[i];
+		unsigned char c = log_text(msg)[i];
 
 		if (c < ' ' || c >= 128)
 			len += sprintf(user->buf + len, "\\x%02x", c);
@@ -461,7 +461,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		bool line = true;
 
 		for (i = 0; i < msg->dict_len; i++) {
-			char c = log_dict(msg)[i];
+			unsigned char c = log_dict(msg)[i];
 
 			if (line) {
 				user->buf[len++] = ' ';
@@ -785,56 +791,81 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static size_t prepend_timestamp(unsigned long long t, char *buf)
+static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 {
-	unsigned long rem_ns;
+	size_t len = 0;
 
-	if (!printk_time)
-		return 0;
+	if (syslog) {
+		if (buf) {
+			len += sprintf(buf, "<%u>", msg->level);
+		} else {
+			len += 3;
+			if (msg->level > 9)
+				len++;
+			if (msg->level > 99)
+				len++;
+		}
+	}
 
-	if (!buf)
-		return 15;
+	if (printk_time) {
+		if (buf) {
+			unsigned long long ts = msg->ts_nsec;
+			unsigned long rem_nsec = do_div(ts, 1000000000);
 
-	rem_ns = do_div(t, 1000000000);
+			len += sprintf(buf + len, "[%5lu.%06lu] ",
+					 (unsigned long) ts, rem_nsec / 1000);
+		} else {
+			len += 15;
+		}
+	}
 
-	return sprintf(buf, "[%5lu.%06lu] ",
-		       (unsigned long) t, rem_ns / 1000);
+	return len;
 }
 
-static int syslog_print_line(u32 idx, char *text, size_t size)
+static size_t msg_print_text(const struct log *msg, bool syslog,
+			     char *buf, size_t size)
 {
-	struct log *msg;
-	size_t len;
+	const char *text = log_text(msg);
+	size_t text_size = msg->text_len;
+	size_t len = 0;
 
-	msg = log_from_idx(idx);
-	if (!text) {
-		/* calculate length only */
-		len = 3;
+	do {
+		const char *next = memchr(text, '\n', text_size);
+		size_t text_len;
 
-		if (msg->level > 9)
-			len++;
-		if (msg->level > 99)
-			len++;
-		len += prepend_timestamp(0, NULL);
+		if (next) {
+			text_len = next - text;
+			next++;
+			text_size -= next - text;
+		} else {
+			text_len = text_size;
+		}
 
-		len += msg->text_len;
-		len++;
-		return len;
-	}
+		if (buf) {
+			if (print_prefix(msg, syslog, NULL) +
+			    text_len + 1>= size - len)
+				break;
+
+			len += print_prefix(msg, syslog, buf + len);
+			memcpy(buf + len, text, text_len);
+			len += text_len;
+			buf[len++] = '\n';
+		} else {
+			/* SYSLOG_ACTION_* buffer size only calculation */
+			len += print_prefix(msg, syslog, NULL);
+			len += text_len + 1;
+		}
+
+		text = next;
+	} while (text);
 
-	len = sprintf(text, "<%u>", msg->level);
-	len += prepend_timestamp(msg->ts_nsec, text + len);
-	if (len + msg->text_len > size)
-		return -EINVAL;
-	memcpy(text + len, log_text(msg), msg->text_len);
-	len += msg->text_len;
-	text[len++] = '\n';
 	return len;
 }
 
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
+	struct log *msg;
 	int len;
 
 	text = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
@@ -847,7 +878,8 @@ static int syslog_print(char __user *buf, int size)
 		syslog_seq = log_first_seq;
 		syslog_idx = log_first_idx;
 	}
-	len = syslog_print_line(syslog_idx, text, LOG_LINE_MAX);
+	msg = log_from_idx(syslog_idx);
+	len = msg_print_text(msg, true, text, LOG_LINE_MAX);
 	syslog_idx = log_next(syslog_idx);
 	syslog_seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
@@ -887,14 +919,18 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		seq = clear_seq;
 		idx = clear_idx;
 		while (seq < log_next_seq) {
-			len += syslog_print_line(idx, NULL, 0);
+			struct log *msg = log_from_idx(idx);
+
+			len += msg_print_text(msg, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
 		seq = clear_seq;
 		idx = clear_idx;
 		while (len > size && seq < log_next_seq) {
-			len -= syslog_print_line(idx, NULL, 0);
+			struct log *msg = log_from_idx(idx);
+
+			len -= msg_print_text(msg, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -904,9 +940,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 
 		len = 0;
 		while (len >= 0 && seq < next_seq) {
+			struct log *msg = log_from_idx(idx);
 			int textlen;
 
-			textlen = syslog_print_line(idx, text, LOG_LINE_MAX);
+			textlen = msg_print_text(msg, true, text, LOG_LINE_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
@@ -1044,7 +1081,9 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			seq = syslog_seq;
 			idx = syslog_idx;
 			while (seq < log_next_seq) {
-				error += syslog_print_line(idx, NULL, 0);
+				struct log *msg = log_from_idx(idx);
+
+				error += msg_print_text(msg, true, NULL, 0);
 				idx = log_next(idx);
 				seq++;
 			}
@@ -1439,10 +1478,8 @@ static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static char *log_text(const struct log *msg) { return NULL; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t prepend_timestamp(unsigned long long t, char *buf)
-{
-	return 0;
-}
+static size_t msg_print_text(const struct log *msg, bool syslog,
+			     char *buf, size_t size) { return 0; }
 
 #endif /* CONFIG_PRINTK */
 
@@ -1750,7 +1787,7 @@ again:
 	for (;;) {
 		struct log *msg;
 		static char text[LOG_LINE_MAX];
-		size_t len, l;
+		size_t len;
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
@@ -1771,13 +1808,7 @@ again:
 		msg = log_from_idx(console_idx);
 		level = msg->level & 7;
 
-		len = prepend_timestamp(msg->ts_nsec, text);
-		l = msg->text_len;
-		if (len + l + 1 >= sizeof(text))
-			l = sizeof(text) - len - 1;
-		memcpy(text + len, log_text(msg), l);
-		len += l;
-		text[len++] = '\n';
+		len = msg_print_text(msg, false, text, sizeof(text));
 
 		console_idx = log_next(console_idx);
 		console_seq++;


