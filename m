Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab2GLW2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:28:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54866 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab2GLW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:28:17 -0400
Message-ID: <1342132092.8274.17.camel@mop>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Date: Fri, 13 Jul 2012 00:28:12 +0200
In-Reply-To: <CAPXgP12USC2LETFz2gy8yubMQbrNA6ou_hByH+UqHdo6-hfkGQ@mail.gmail.com>
References: <20120709180328.GA4105@redhat.com>
	 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
	 <1341859731.801.0.camel@mop> <20120712005405.GA1613@redhat.com>
	 <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com>
	 <20120712140552.GA13745@redhat.com>
	 <CA+55aFyue0ivxx541BSfL1kkL76KZjwPdGc7=6OXcnArKGyxMw@mail.gmail.com>
	 <CAPXgP12USC2LETFz2gy8yubMQbrNA6ou_hByH+UqHdo6-hfkGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 20:25 +0200, Kay Sievers wrote:
> On Thu, Jul 12, 2012 at 7:11 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Jul 12, 2012 at 7:05 AM, Dave Jones <davej@redhat.com> wrote:
> >>
> >> I've seen it a few times, always with the soft lockup trace.
> >
> > I bet it's because you have tons of modules, and the line ends up
> > being *really* long. And overflows LOG_LINE_MAX. I suspect something
> > odd happens.
> 
> Straight to the point. That's the issue, combined with the later
> safety range checks, we produce somehow "ugly" output.
> 
> We already flush the line out of the buffer when we can not add stuff
> anymore. The line length is then close to LOG_LINE_MAX, and we want to
> add a prefix with the timestamp during output and we reach the limit
> of LOG_LINE_MAX.
> 
> > There are tons of odd special cases for LOG_LINE_MAX, and I bet Kay
> > doesn't see it for the simple reason that he's not totally insane, and
> > hasn't loaded hundreds of modules.
> 
> Yeah, I just added a loop now that prints over-long continuation
> lines, and I can see parts of the effect Dave sees.
> 
> > Kay, I suspect the "continuation line" logic could easily have a rule like
> >
> >   "If the old line is already > 80 characters, do a line break here
> > and add TAB to the beginning of the new line"

This seems to fix the issue for me, which Dave has posted. I was able to
partly reproduce it by printing continuation lines larger than 1000
bytes. The overlong lines did not leave enough room for the later syslog
and timestamp prefixing.

I'll look into the automatic split of lines later, it is not as trivial
as this fix.

While we are at the over-long log line topic, Harald just pointed me to
this unrelated mail, sent an hour ago. :)

  "The "Modules linked in:" lines say only <omitted>,
  because the lines become too long and cause netconsole to eat most of
  the message."

  https://lkml.org/lkml/2012/7/12/484


Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: kmsg - properly print over-long continuation lines

Reserve PREFIX_MAX bytes in the LOG_LINE_MAX line when buffering a
continuation line, to be able to properly prefix the LOG_LINE_MAX
line with the syslog prefix and timestamp when printing it.

Reported-By: Dave Jones <davej@redhat.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---

 kernel/printk.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -235,7 +235,8 @@ static u32 log_next_idx;
 static u64 clear_seq;
 static u32 clear_idx;
 
-#define LOG_LINE_MAX 1024
+#define PREFIX_MAX		32
+#define LOG_LINE_MAX		1024 - PREFIX_MAX
 
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
@@ -876,7 +877,7 @@ static size_t msg_print_text(const struc
 
 		if (buf) {
 			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1>= size - len)
+			    text_len + 1 >= size - len)
 				break;
 
 			if (prefix)
@@ -907,7 +908,7 @@ static int syslog_print(char __user *buf
 	struct log *msg;
 	int len = 0;
 
-	text = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
+	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
@@ -930,7 +931,8 @@ static int syslog_print(char __user *buf
 
 		skip = syslog_partial;
 		msg = log_from_idx(syslog_idx);
-		n = msg_print_text(msg, syslog_prev, true, text, LOG_LINE_MAX);
+		n = msg_print_text(msg, syslog_prev, true, text,
+				   LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
@@ -969,7 +971,7 @@ static int syslog_print_all(char __user
 	char *text;
 	int len = 0;
 
-	text = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
+	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
@@ -1022,7 +1024,8 @@ static int syslog_print_all(char __user
 			struct log *msg = log_from_idx(idx);
 			int textlen;
 
-			textlen = msg_print_text(msg, prev, true, text, LOG_LINE_MAX);
+			textlen = msg_print_text(msg, prev, true, text,
+						 LOG_LINE_MAX + PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
@@ -1367,15 +1370,15 @@ static struct cont {
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
-static void cont_flush(void)
+static void cont_flush(enum log_flags flags)
 {
 	if (cont.flushed)
 		return;
 	if (cont.len == 0)
 		return;
 
-	log_store(cont.facility, cont.level, LOG_NOCONS, cont.ts_nsec,
-		  NULL, 0, cont.buf, cont.len);
+	log_store(cont.facility, cont.level, LOG_NOCONS | flags,
+		  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
 
 	cont.flushed = true;
 }
@@ -1386,7 +1389,8 @@ static bool cont_add(int facility, int l
 		return false;
 
 	if (cont.len + len > sizeof(cont.buf)) {
-		cont_flush();
+		/* the line gets too long, split it up in separate records */
+		cont_flush(LOG_CONT);
 		return false;
 	}
 
@@ -1522,7 +1526,7 @@ asmlinkage int vprintk_emit(int facility
 		 * or another task also prints continuation lines.
 		 */
 		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
-			cont_flush();
+			cont_flush(0);
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, text, text_len))
@@ -1540,7 +1544,7 @@ asmlinkage int vprintk_emit(int facility
 		if (cont.len && cont.owner == current) {
 			if (!(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, text, text_len);
-			cont_flush();
+			cont_flush(0);
 		}
 
 		if (!stored)
@@ -1633,7 +1637,8 @@ EXPORT_SYMBOL(printk);
 
 #else
 
-#define LOG_LINE_MAX 0
+#define LOG_LINE_MAX		0
+#define PREFIX_MAX		0
 static struct cont {
 	size_t len;
 	size_t cons;
@@ -1938,7 +1943,7 @@ static enum log_flags console_prev;
  */
 void console_unlock(void)
 {
-	static char text[LOG_LINE_MAX];
+	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;


