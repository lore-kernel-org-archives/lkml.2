Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2GHCKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 22:10:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41932 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2GHCKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 22:10:04 -0400
Message-ID: <1341713399.22696.9.camel@mop>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte reads
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Jukka Ollila <jiiksteri@gmail.com>,
        linux-kernel@vger.kernel.org, jbeulich@novell.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sun, 08 Jul 2012 04:09:59 +0200
In-Reply-To: <CAPXgP12vGkh1q4-L3+wYY5XWZURBXOWQCmovARr0cbf+dHinVQ@mail.gmail.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
	 <20120706203825.20ce3e47@pyramind.ukuu.org.uk>
	 <CA+55aFy7RncR_z9M+DRzSXJY7cWxY9zG0ioLdiefhxkH__Z7Yw@mail.gmail.com>
	 <CAPXgP12vGkh1q4-L3+wYY5XWZURBXOWQCmovARr0cbf+dHinVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 23:19 +0200, Kay Sievers wrote:
> On Fri, Jul 6, 2012 at 10:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Kay, this needs to be fixed.
> >
> > Suggested fix: just use the 'seq_printf()' interfaces, which do the
> > proper buffering, and allow any size reads of various packetized data.
> 
> I'll have a look.

Hmm, we need to block in the read() when we have no data, and we need to
support concurrent readers where only one of them sees the data, and we
need O_NONBLOCK support. Maybe I miss something but the seq_file stuff
seems to get complicated, as it takes a mutex internally which gets in
the way of the O_NONBLOCK stuff.

Here is what seems to work for me. If the buffer is to small to fit the
first record, we deliver a partial record, and start from that offset
again with the next read().

I'll need to do more testing tomorrow.

Thanks,
Kay

---
 kernel/printk.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -217,6 +217,7 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
+static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
 static u64 log_first_seq;
@@ -890,22 +891,33 @@ static int syslog_print(char __user *buf
 
 	while (size > 0) {
 		size_t n;
+		size_t skip;
 
 		raw_spin_lock_irq(&logbuf_lock);
 		if (syslog_seq < log_first_seq) {
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
+			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
 			raw_spin_unlock_irq(&logbuf_lock);
 			break;
 		}
+
+		skip = syslog_partial;
 		msg = log_from_idx(syslog_idx);
 		n = msg_print_text(msg, true, text, LOG_LINE_MAX);
-		if (n <= size) {
+		if (n - syslog_partial <= size) {
+			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
 			syslog_seq++;
+			n -= syslog_partial;
+			syslog_partial = 0;
+		} else if (!len){
+			/* partial read(), remember position */
+			n = size;
+			syslog_partial += n;
 		} else
 			n = 0;
 		raw_spin_unlock_irq(&logbuf_lock);
@@ -913,17 +925,15 @@ static int syslog_print(char __user *buf
 		if (!n)
 			break;
 
-		len += n;
-		size -= n;
-		buf += n;
-		n = copy_to_user(buf - n, text, n);
-
-		if (n) {
-			len -= n;
+		if (copy_to_user(buf, text + skip, n)) {
 			if (!len)
 				len = -EFAULT;
 			break;
 		}
+
+		len += n;
+		size -= n;
+		buf += n;
 	}
 
 	kfree(text);
@@ -1107,6 +1117,7 @@ int do_syslog(int type, char __user *buf
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
+			syslog_partial = 0;
 		}
 		if (from_file) {
 			/*
@@ -1129,6 +1140,7 @@ int do_syslog(int type, char __user *buf
 				idx = log_next(idx);
 				seq++;
 			}
+			error -= syslog_partial;
 		}
 		raw_spin_unlock_irq(&logbuf_lock);
 		break;


