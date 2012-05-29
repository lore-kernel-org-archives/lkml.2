Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2E2SRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:17:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59227 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754963Ab2E2SRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:17:12 -0400
Message-ID: <1338315431.18974.10.camel@joe2Laptop>
Subject: [PATCH] printk: Shrink printk_sched buffer size, eliminate it when
 !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2012 11:17:11 -0700
In-Reply-To: <20120523155003.GA8202@gmail.com>
References: <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
	 <1337468148.573.139.camel@twins>
	 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
	 <20120523150359.GB26974@gmail.com> <1337787838.1734.15.camel@joe2Laptop>
	 <20120523155003.GA8202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the per-cpu printk_sched buf is much larger
than necessary.  The maximum sched message emitted is
~80 bytes. Shrink the allocation for this printk_sched
buffer from 512 bytes to 128.

printk_sched creates an unnecessary per-cpu buffer when
CONFIG_PRINTK is not enabled.  Remove it when appropriate
so embedded uses save a bit of space too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..61cff0b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1726,24 +1726,30 @@ int is_console_locked(void)
 }
 
 /*
- * Delayed printk version, for scheduler-internal messages:
+ * Delayed printk version, for scheduler-internal messages.
+ * Not the normal 512 as it's a bit wasteful, sched messages are short,
+ * and 128 is more than sufficient for all current messages.
  */
-#define PRINTK_BUF_SIZE		512
+#define PRINTK_SCHED_BUF_SIZE	128
 
 #define PRINTK_PENDING_WAKEUP	0x01
 #define PRINTK_PENDING_SCHED	0x02
 
 static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
+#ifdef CONFIG_PRINTK
+static DEFINE_PER_CPU(char [PRINTK_SCHED_BUF_SIZE], printk_sched_buf);
+#endif
 
 void printk_tick(void)
 {
 	if (__this_cpu_read(printk_pending)) {
 		int pending = __this_cpu_xchg(printk_pending, 0);
+#ifdef CONFIG_PRINTK
 		if (pending & PRINTK_PENDING_SCHED) {
 			char *buf = __get_cpu_var(printk_sched_buf);
 			printk(KERN_WARNING "[sched_delayed] %s", buf);
 		}
+#endif
 		if (pending & PRINTK_PENDING_WAKEUP)
 			wake_up_interruptible(&log_wait);
 	}
@@ -2189,7 +2195,7 @@ int printk_sched(const char *fmt, ...)
 	buf = __get_cpu_var(printk_sched_buf);
 
 	va_start(args, fmt);
-	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	r = vsnprintf(buf, PRINTK_SCHED_BUF_SIZE, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);


