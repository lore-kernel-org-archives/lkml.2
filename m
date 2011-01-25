Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1AYAZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:25:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:59985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1AYAZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:25:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=c4HjSkdhRMr3mpsyPirgSA6XTci+ZOYZ8hEnwk4S6XyeDYTxPSPMhdyoud0UAhvPy
	9KL5+npZH9Gd2HKuNJbqw==
Subject: [PATCH v1 5/6] Allow prepending to the dmesg
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
From: Mike Waychison <mikew@google.com>
Cc: San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Date: Mon, 24 Jan 2011 16:25:00 -0800
Message-ID: <20110125002459.12637.56291.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch in this series (Memory Console driver) would like to
prepend firmware messages to the kernel logs.

Instead of exposing all the nitty gritty lock details of the kernel's
printk system to the entire kernel, expose a "prepend_to_dmesg()" that
attempts to rewrite the in-memory dmesg to inject pre-kernel messages.

This function only prepends if the start of the kernel's messages are
still in the ring and there is still room for messages (without losing
the current tail of the message log).  We determine this by checking out
whether the bufer has yet been cleared (indicated by a new flag:
buffer_has_cleared), and by checking whether the buffer is less than
full (which would indicate that it had wrapped).

If there is enough room to prepend data, we simply shift the existing
log contents down and copy into the buffer the tail of the prepended
data that fits.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 include/linux/printk.h |    5 ++++
 kernel/printk.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..df89965 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -113,6 +113,7 @@ extern int dmesg_restrict;
 extern int kptr_restrict;
 
 void log_buf_kexec_setup(void);
+void prepend_to_dmesg(const char *buffer, size_t length);
 #else
 static inline __attribute__ ((format (printf, 1, 0)))
 int vprintk(const char *s, va_list args)
@@ -137,6 +138,10 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 static inline void log_buf_kexec_setup(void)
 {
 }
+
+void prepend_to_dmesg(const char *buffer, size_t length)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff --git a/kernel/printk.c b/kernel/printk.c
index 53d9a9e..aa917e3 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -144,6 +144,9 @@ static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 static int saved_console_loglevel = -1;
 
+/* Used to determine if the buffer starts at the kernel's first messages. */
+static bool buffer_has_cleared;
+
 #ifdef CONFIG_KEXEC
 /*
  * This appends the listed symbols to /proc/vmcoreinfo
@@ -344,8 +347,10 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		spin_lock_irq(&logbuf_lock);
 		if (count > logged_chars)
 			count = logged_chars;
-		if (do_clear)
+		if (do_clear) {
 			logged_chars = 0;
+			buffer_has_cleared = true;
+		}
 		limit = log_end;
 		/*
 		 * __put_user() could sleep, and while we sleep
@@ -383,6 +388,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	/* Clear ring buffer */
 	case SYSLOG_ACTION_CLEAR:
 		logged_chars = 0;
+		buffer_has_cleared = 0;
 		break;
 	/* Disable logging to console */
 	case SYSLOG_ACTION_CONSOLE_OFF:
@@ -844,6 +850,53 @@ out_restore_irqs:
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
+void __init prepend_to_dmesg(const char *buffer, size_t length)
+{
+	size_t amount_to_copy;
+	size_t copy_start;
+	unsigned long flags;
+
+	spin_lock_irqsave(&logbuf_lock, flags);
+
+	/*
+	 * Verify that the dmesg hasn't been cleared yet.  If it has,
+	 * the prepend operation is a no-op as we no longer have the
+	 * "beginning" of the kernel boot.
+	 */
+	if (buffer_has_cleared)
+		goto out;
+
+	/* Nothing to do if there is no amount in the buffer. */
+	amount_to_copy = log_buf_len - logged_chars;
+	if (!amount_to_copy)
+		goto out;
+
+	/*
+	 * At this point, we know we are on the first fill of the ring
+	 * buffer, and as such we haven't wrapped yet.
+	 */
+
+	/*
+	 * If available space in the buffer exceeds the length of the
+	 * data being prepended, trim the amount to copy.
+	 */
+	if (amount_to_copy > length)
+		amount_to_copy = length;
+
+	copy_start = length - amount_to_copy;
+
+	/* Make room by shifting the existing contents of the buffer. */
+	memmove(&log_buf[amount_to_copy], log_buf, logged_chars);
+	log_end += amount_to_copy;
+	logged_chars += amount_to_copy;
+
+	/* Inject prepended logs */
+	memmove(log_buf, buffer + copy_start, amount_to_copy);
+
+out:
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+}
+
 #else
 
 static void call_console_drivers(unsigned start, unsigned end)

