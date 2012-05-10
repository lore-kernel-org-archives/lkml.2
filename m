Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519Ab2EJTKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:10:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34018 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab2EJTKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:10:20 -0400
Message-ID: <1336676986.947.47.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 21:09:46 +0200
In-Reply-To: <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	 <1336667984.947.24.camel@mop>
	 <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 09:47 -0700, Linus Torvalds wrote:
> On Thu, May 10, 2012 at 9:39 AM, Kay Sievers <kay@vrfy.org> wrote:

>  An interrupt that prints out with KERN_DEFAULT had better not act
>  the same way as KERN_CONT.

Good point, understood, and adapted to the new logic.


Here is a new RFC version. I think it's slightly better than the
currently implemented logic in Greg's tree:

We fully isolate continuation users from non-continuation users. If a
continuation user gets interrupted by an ordinary non-continuation
user, we will not touch the continuation buffer, we just emit the
ordinary message. When the same thread comes back and continues its
printing, we still append to the earlier buffer we stored.

The only case where printk() still gets messed up now, is when multiple
threads (or interrupts) race against each other.

We will also never wrongly merge two racing continuation users into one
line.


Current intended behavior, and general rules:
printk() starting with KERN_* (not KERN_CONT) and ending with '\n' will
*always* logged as single line, *never* be merged with anything else. 

printk() not starting with any KERN_* might get merged with an earlier
line buffered by the *same* thread.

printk() not ending with '\n' will be buffered.

Buffered lines will be flushed when a different thread emits a printk()
that needs to be buffered --> race.

Buffered line will be flushed, when the same thread emits a printk()
with a KERN_* (not KERN_CONT) --> newline missing.

Buffered line will be joined, when the same thread emits a printk()
without any KERN_* or with KERN_CONT.

Does that sounds correct? Anything to add or adjust?

Thanks,
Kay

---

  printk.c |   97 +++++++++++++++++++++++++++++++++++----------------------------
  1 file changed, 54 insertions(+), 43 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1232,13 +1232,13 @@ asmlinkage int vprintk_emit(int facility, int level,
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
@@ -1288,11 +1288,11 @@ asmlinkage int vprintk_emit(int facility, int level,
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
 
@@ -1306,49 +1306,60 @@ asmlinkage int vprintk_emit(int facility, int level,
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
+	if (level == -1)
+		level = default_message_loglevel;
 
-	if (buflen == 0) {
-		/* remember level for first message in the buffer */
-		if (level == -1)
-			buflevel = default_message_loglevel;
-		else
-			buflevel = level;
-	}
+	if (!newline) {
+		if (cont_len && (prefix || cont_task != current)) {
+			/*
+			 * Flush earlier buffer, either from a different
+			 * thread, or when we've seen a new prefix.
+			 */
+			log_store(facility, cont_level, NULL, 0, cont_buf, cont_len);
+			cont_len = 0;
+		}
 
-	if (buflen || !newline) {
-		/* append to existing buffer, or buffer until next message */
-		if (buflen + textlen > sizeof(buf))
-			textlen = sizeof(buf) - buflen;
-		memcpy(buf + buflen, text, textlen);
-		buflen += textlen;
-	}
+		if (!cont_len) {
+			cont_level = level;
+			cont_task = current;
+		}
+
+		/* buffer/append to earlier buffer from same thread */
+		if (cont_len + text_len > sizeof(cont_buf))
+			text_len = sizeof(cont_buf) - cont_len;
+		memcpy(cont_buf + cont_len, text, text_len);
+		cont_len += text_len;
+	} else {
+		if (cont_len && cont_task == current) {
+			if (prefix) {
+				/*
+				 * New prefix in same thread; flush. Either
+				 * no earlier newline, or in an interrupt.
+				 */
+				log_store(facility, cont_level,
+					  NULL, 0, cont_buf, cont_len);
+				cont_len = 0;
+			}
 
-	if (newline) {
-		/* end of line; flush buffer */
-		if (buflen) {
-			log_store(facility, buflevel,
-				  dict, dictlen, buf, buflen);
-			printed_len += buflen;
-			buflen = 0;
+			/* append to earlier buffer and flush */
+			if (cont_len + text_len > sizeof(cont_buf))
+				text_len = sizeof(cont_buf) - cont_len;
+			memcpy(cont_buf + cont_len, text, text_len);
+			cont_len += text_len;
+			log_store(facility, cont_level,
+				  NULL, 0, cont_buf, cont_len);
+			cont_len = 0;
+			cont_task = NULL;
+			printed_len = cont_len;
 		} else {
-			log_store(facility, buflevel,
-				  dict, dictlen, text, textlen);
-			printed_len += textlen;
+			log_store(facility, level,
+				  dict, dictlen, text, text_len);
+			printed_len = text_len;
 		}
-		cont = NULL;
-	} else {
-		/* remember thread which filled the buffer */
-		cont = current;
 	}
 
 	/*


