Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2EJCbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:31:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64395 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2EJCbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:31:16 -0400
Message-ID: <1336617045.25027.2.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Greg Kroah-Hartmann <greg@kroah.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 04:30:45 +0200
In-Reply-To: <20120509230649.GA10695@kroah.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
	 <1336571457.30189.29.camel@joe2Laptop>
	 <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
	 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
	 <20120509230649.GA10695@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 16:06 -0700, Greg Kroah-Hartmann wrote:
> On Wed, May 09, 2012 at 04:02:40PM -0700, Yinghai Lu wrote:
> > On Wed, May 9, 2012 at 7:37 AM, Kay Sievers <kay@vrfy.org> wrote:
> > >
> > >> Changing printk semantics and trying to stabilize
> > >> printk message content are bad ideas though.
> > >
> > > Again, nobody talks about content of here.
> > 
> > printk_time=1 does not work anymore with this patch on serial console.
> 
> Known issue, I think Kay is working on the solution for this right
> now...

Sure, and this seems to work for me.

Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: printk() - restore timestamp printing at console output

The output of the timestamps got lost with the conversion of the
kmsg buffer to records; restore the old behavior.

Document, that CONFIG_PRINTK_TIME now only controls the output of
the timestamps in the syslog() system call and on the console, and
not the recording of the timestamps.

Signed-off-by: Kay Sievers <kay@vrfy.org>
---

 kernel/printk.c   |   43 ++++++++++++++++++++++++++-----------------
 lib/Kconfig.debug |   16 ++++++++++------
 2 files changed, 36 insertions(+), 23 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -786,6 +786,22 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+static size_t prepend_timestamp(unsigned long long t, char *buf)
+{
+	unsigned long rem_ns;
+
+	if (!printk_time)
+		return 0;
+
+	if (!buf)
+		return 15;
+
+	rem_ns = do_div(t, 1000000000);
+
+	return sprintf(buf, "[%5lu.%06lu] ",
+		       (unsigned long) t, rem_ns / 1000);
+}
+
 static int syslog_print_line(u32 idx, char *text, size_t size)
 {
 	struct log *msg;
@@ -800,9 +816,7 @@ static int syslog_print_line(u32 idx, ch
 			len++;
 		if (msg->level > 99)
 			len++;
-
-		if (printk_time)
-			len += 15;
+		len += prepend_timestamp(0, NULL);
 
 		len += msg->text_len;
 		len++;
@@ -810,15 +824,7 @@ static int syslog_print_line(u32 idx, ch
 	}
 
 	len = sprintf(text, "<%u>", msg->level);
-
-	if (printk_time) {
-		unsigned long long t = msg->ts_nsec;
-		unsigned long rem_ns = do_div(t, 1000000000);
-
-		len += sprintf(text + len, "[%5lu.%06lu] ",
-				   (unsigned long) t, rem_ns / 1000);
-	}
-
+	len += prepend_timestamp(msg->ts_nsec, text + len);
 	if (len + msg->text_len > size)
 		return -EINVAL;
 	memcpy(text + len, log_text(msg), msg->text_len);
@@ -1741,7 +1747,7 @@ again:
 	for (;;) {
 		struct log *msg;
 		static char text[LOG_LINE_MAX];
-		size_t len;
+		size_t len, l;
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
@@ -1761,10 +1767,13 @@ again:
 
 		msg = log_from_idx(console_idx);
 		level = msg->level & 7;
-		len = msg->text_len;
-		if (len+1 >= sizeof(text))
-			len = sizeof(text)-1;
-		memcpy(text, log_text(msg), len);
+
+		len = prepend_timestamp(msg->ts_nsec, text);
+		l = msg->text_len;
+		if (len + l + 1 >= sizeof(text))
+			l = sizeof(text) - len - 1;
+		memcpy(text + len, log_text(msg), l);
+		len += l;
 		text[len++] = '\n';
 
 		console_idx = log_next(console_idx);
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3,12 +3,16 @@ config PRINTK_TIME
 	bool "Show timing information on printks"
 	depends on PRINTK
 	help
-	  Selecting this option causes timing information to be
-	  included in printk output.  This allows you to measure
-	  the interval between kernel operations, including bootup
-	  operations.  This is useful for identifying long delays
-	  in kernel startup.  Or add printk.time=1 at boot-time.
-	  See Documentation/kernel-parameters.txt
+	  Selecting this option causes time stamps of the printk()
+	  messages to be added to the output of the syslog() system
+	  call and at the console.
+
+	  The timestamp is always recorded internally, and exported
+	  to /dev/kmsg. This flag just specifies if the timestamp should
+	  be included, not that the timestamp is recorded.
+
+	  The behavior is also controlled by the kernel command line
+	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
 config DEFAULT_MESSAGE_LOGLEVEL
 	int "Default message log level (1-7)"


