Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2ENSrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:47:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61886 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2ENSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:47:03 -0400
Message-ID: <1337021187.483.7.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 20:46:27 +0200
In-Reply-To: <1336699411.835.5.camel@mop>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	 <1336667984.947.24.camel@mop>
	 <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
	 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
	 <1336682226.29763.2.camel@joe2Laptop>
	 <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
	 <1336682772.29763.6.camel@joe2Laptop>
	 <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
	 <1336696707.947.56.camel@mop> <1336699411.835.5.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 03:23 +0200, Kay Sievers wrote:
> On Fri, 2012-05-11 at 02:38 +0200, Kay Sievers wrote:
> > On Thu, May 10, 2012 at 10:52 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > The change to verify that 'current' matches the previous printout is
> > > so far the *only* sane semantic change I've seen in this thread.
> > > Everything else has been pure garbage.
> > 
> > Ok, let's continue with sane things then. :)
> > 
> > Here is a stupid kernel module which creates 3 racy printk() loops, 2 of
> > them do continuation, one does an atomic print. The continuation one
> > prints one char per printk.
> >   http://people.freedesktop.org/~kay/printk-race/printk-race.c
> > 
> > The lines all try to look like:
> >   (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
> >   (CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)
> >   (XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
> > 
> > Every loop has it's own uppercase character. The line enclosed in '()'.
> > 'A' is the atomic one, the cont ones are 'C' and 'X'.
> 
> Having only one continuation user racing against an atomic printk user
> looks like this:

This seems to work significantly better for me than all earlier
versions. The single line users like dev_printk() should be reliable
now.

Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: printk() - isolate KERN_CONT users from ordinary complete lines

Arrange the continuation printk() buffering to be fully separated from the
ordinary full line users.

Limit the exposure to races and wrong printk() line merges to users of
continuation only. Ordinary full line users racing against continuation
users will no longer affect each other.

Multiple continuation users from different threads, racing against each
other will not wrongly be merged into a single line, but printed as
separate lines.

Test output of a kernel module which starts two separate threads which
race against each other, one of them printing a single full terminated
line:
  printk("(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)\n");

The other one printing the line, every character separate in a
continuation loop:
  printk("(C");
  for (i = 0; i < 58; i++)
          printk(KERN_CONT "C");
  printk(KERN_CONT "C)\n");

Behavior of single and non-thread-aware printk() buffer:
  # modprobe printk-race
  printk test init
  (CC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  C(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  CC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  C(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  CC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  C(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  C(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  CC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  C(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  C(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)
  (CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)

New behavior with separate and thread-aware continuation buffer:
  # modprobe printk-race
  printk test init
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)
  (CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)

Signed-off-by: Kay Sievers <kay@vrfy.org>
---

 kernel/printk.c |  113 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 48 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1264,13 +1264,13 @@ asmlinkage int vprintk_emit(int facility
 			    const char *fmt, va_list args)
 {
 	static int recursion_bug;
-	static char buf[LOG_LINE_MAX];
-	static size_t buflen;
-	static int buflevel;
+	static char cont_buf[LOG_LINE_MAX];
+	static size_t cont_len;
+	static int cont_level;
+	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
-	static struct task_struct *cont;
 	char *text = textbuf;
-	size_t textlen;
+	size_t text_len;
 	unsigned long flags;
 	int this_cpu;
 	bool newline = false;
@@ -1320,15 +1320,15 @@ asmlinkage int vprintk_emit(int facility
 	 * The printf needs to come first; we need the syslog
 	 * prefix which might be passed-in as a parameter.
 	 */
-	textlen = vscnprintf(text, sizeof(textbuf), fmt, args);
+	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
 
 	/* mark and strip a trailing newline */
-	if (textlen && text[textlen-1] == '\n') {
-		textlen--;
+	if (text_len && text[text_len-1] == '\n') {
+		text_len--;
 		newline = true;
 	}
 
-	/* strip syslog prefix and extract log level or flags */
+	/* strip syslog prefix and extract log level or control flags */
 	if (text[0] == '<' && text[1] && text[2] == '>') {
 		switch (text[1]) {
 		case '0' ... '7':
@@ -1338,49 +1338,67 @@ asmlinkage int vprintk_emit(int facility
 			prefix = true;
 		case 'c':	/* KERN_CONT */
 			text += 3;
-			textlen -= 3;
+			text_len -= 3;
 		}
 	}
 
-	if (buflen && (prefix || dict || cont != current)) {
-		/* flush existing buffer */
-		log_store(facility, buflevel, NULL, 0, buf, buflen);
-		printed_len += buflen;
-		buflen = 0;
-	}
-
-	if (buflen == 0) {
-		/* remember level for first message in the buffer */
-		if (level == -1)
-			buflevel = default_message_loglevel;
-		else
-			buflevel = level;
-	}
-
-	if (buflen || !newline) {
-		/* append to existing buffer, or buffer until next message */
-		if (buflen + textlen > sizeof(buf))
-			textlen = sizeof(buf) - buflen;
-		memcpy(buf + buflen, text, textlen);
-		buflen += textlen;
-	}
-
-	if (newline) {
-		/* end of line; flush buffer */
-		if (buflen) {
-			log_store(facility, buflevel,
-				  dict, dictlen, buf, buflen);
-			printed_len += buflen;
-			buflen = 0;
-		} else {
-			log_store(facility, buflevel,
-				  dict, dictlen, text, textlen);
-			printed_len += textlen;
+	if (level == -1)
+		level = default_message_loglevel;
+
+	if (dict) {
+		prefix = true;
+		newline = true;
+	}
+
+	if (!newline) {
+		if (cont_len && (prefix || cont_task != current)) {
+			/*
+			 * Flush earlier buffer, which is either from a
+			 * different thread, or when we got a new prefix.
+			 */
+			log_store(facility, cont_level, NULL, 0, cont_buf, cont_len);
+			cont_len = 0;
 		}
-		cont = NULL;
+
+		if (!cont_len) {
+			cont_level = level;
+			cont_task = current;
+		}
+
+		/* buffer or append to earlier buffer from the same thread */
+		if (cont_len + text_len > sizeof(cont_buf))
+			text_len = sizeof(cont_buf) - cont_len;
+		memcpy(cont_buf + cont_len, text, text_len);
+		cont_len += text_len;
 	} else {
-		/* remember thread which filled the buffer */
-		cont = current;
+		if (cont_len && cont_task == current) {
+			if (prefix) {
+				/*
+				 * New prefix from the same thread; flush. We
+				 * either got no earlier newline, or we race
+				 * with an interrupt.
+				 */
+				log_store(facility, cont_level,
+					  NULL, 0, cont_buf, cont_len);
+				cont_len = 0;
+			}
+
+			/* append to the earlier buffer and flush */
+			if (cont_len + text_len > sizeof(cont_buf))
+				text_len = sizeof(cont_buf) - cont_len;
+			memcpy(cont_buf + cont_len, text, text_len);
+			cont_len += text_len;
+			log_store(facility, cont_level,
+				  NULL, 0, cont_buf, cont_len);
+			cont_len = 0;
+			cont_task = NULL;
+			printed_len = cont_len;
+		} else {
+			/* ordinary single and terminated line */
+			log_store(facility, level,
+				  dict, dictlen, text, text_len);
+			printed_len = text_len;
+		}
 	}
 
 	/*
@@ -1470,7 +1488,6 @@ EXPORT_SYMBOL(printk);
 #define LOG_LINE_MAX 0
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
-static char *log_text(const struct log *msg) { return NULL; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 static size_t msg_print_text(const struct log *msg, bool syslog,
 			     char *buf, size_t size) { return 0; }


