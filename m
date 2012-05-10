Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2EJQkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:40:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46842 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2EJQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:40:18 -0400
Message-ID: <1336667984.947.24.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 18:39:44 +0200
In-Reply-To: <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 18:18 -0700, Linus Torvalds wrote:
> On Wed, May 9, 2012 at 5:54 PM, Kay Sievers <kay@vrfy.org> wrote:
> >
> > How about this? It relaxes the need for KERN_CONT, but it limits
> > continuation lines to repeated calls of the same thread.
> 
> Fair enough, looks reasonable.

Here is something which might make sense, and could become be the most
reliable and fail-tolerant version so far. It is also the least
restrictive one regarding the input format, and takes the same amount of
resources as the current implementation.

We fully isolate continuation users from non-continuation users. If a
continuation user gets interrupted by a an ordinary non-continuation
user, we will no longer touch the buffer of the continuation user, we
just emit the ordinary message.

When the same thread comes back and continues printing, we still append
to the earlier buffer we stored.

The only case where printk() still gets messed up now, is when multiple
threads use continuation at the same time, which is way less likely than
mixing with ordinary users.

We will also never merge two racing continuation users into one line;
the worst thing that can happen now, is that they end split up into more
than the intended single line.

Note: In this version, the KERN_* prefixes have all no further meaning
anymore, besides that they carry the priority, or prevent they the
content of the line to be parsed for a priority.

All the special rules are gone. KERN_CONT is the same as KERN_DEFAULT
now.

Even continuation users could use prefixes now, if they wanted to. We
should be context-aware enough now, with remembering the owner (task) of
the buffered data, that we might be able to relax all the special rules
regarding the prefixes.

Any ideas about that?

Thanks,
Kay



From: Kay Sievers <kay@vrfy.org>
Subject: printk() - fully separate continuation line users from ordinary ones
---

 printk.c |   86 ++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1232,17 +1232,16 @@ asmlinkage int vprintk_emit(int facility, int level,
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
-	bool prefix = false;
 	int printed_len = 0;
 
 	boot_delay_msec();
@@ -1288,11 +1287,11 @@ asmlinkage int vprintk_emit(int facility, int level,
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
 
@@ -1303,52 +1302,49 @@ asmlinkage int vprintk_emit(int facility, int level,
 			if (level == -1)
 				level = text[1] - '0';
 		case 'd':	/* KERN_DEFAULT */
-			prefix = true;
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
+		if (cont_len && cont_task != current) {
+			/* flush earlier buffer from different thread */
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
 
-	if (newline) {
-		/* end of line; flush buffer */
-		if (buflen) {
-			log_store(facility, buflevel,
-				  dict, dictlen, buf, buflen);
-			printed_len += buflen;
-			buflen = 0;
+		/* buffer, or append to earlier buffer from same thread */
+		if (cont_len + text_len > sizeof(cont_buf))
+			text_len = sizeof(cont_buf) - cont_len;
+		memcpy(cont_buf + cont_len, text, text_len);
+		cont_len += text_len;
+	} else {
+		if (cont_len && cont_task == current) {
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


