Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153Ab2FUUBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:01:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44484 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756484Ab2FUUBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:01:39 -0400
Message-ID: <1340308898.22218.24.camel@joe2Laptop>
Subject: [RFC PATCH] printk: Enable/disable buffering and add printk_flush()
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2012 13:01:38 -0700
In-Reply-To: <1340307523.27036.207.camel@gandalf.stny.rr.com>
References: <20120614154153.GD17140@kroah.com>
	 <1339693625.13377.242.camel@gandalf.stny.rr.com>
	 <20120615042233.GA10973@localhost> <20120615043017.GA9587@kroah.com>
	 <20120615120430.GB23681@gmail.com> <20120615231318.GD8205@kroah.com>
	 <1339804415.25903.63.camel@gandalf.stny.rr.com>
	 <20120618230337.GB23627@kroah.com>
	 <1340069326.25903.177.camel@gandalf.stny.rr.com>
	 <20120620122549.GA10561@gmail.com> <20120621171338.GF3270@kroah.com>
	 <1340300509.27036.185.camel@gandalf.stny.rr.com>
	 <1340302623.22065.9.camel@joe2Laptop>
	 <1340303360.27036.194.camel@gandalf.stny.rr.com>
	 <1340303969.22218.9.camel@joe2Laptop>
	 <1340304566.27036.200.camel@gandalf.stny.rr.com>
	 <1340304902.22218.12.camel@joe2Laptop>
	 <1340307523.27036.207.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to enable/disable printk buffering.
Add a function to force any buffered output to be emitted.

printk_flush() also emits "printk_flush\n" at KERN_DEFAULT.

---

Perhaps something like this instead of just the one printk_flush()?
Doesn't require any additional KERN_LEVEL '<f>' addition.

Compiled but completely untested...

 include/linux/printk.h |   18 ++++++++++++++++++
 kernel/printk.c        |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1bec2f7..165b6a2 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -111,6 +111,11 @@ asmlinkage int printk_emit(int facility, int level,
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
+bool printk_set_buffering(bool enable);
+bool printk_get_buffering(void);
+void printk_flush(void);	/* forcibly emit any internal buffers */
+
+
 /*
  * Special printk facility for scheduler use only, _DO_NOT_USE_ !
  */
@@ -143,6 +148,17 @@ int printk(const char *s, ...)
 {
 	return 0;
 }
+static bool printk_set_buffering(bool enable)
+{
+	return false;
+}
+bool printk_get_buffering(void)
+{
+	return false;
+}
+static inline void printk_flush(void)
+{
+}
 static inline __printf(1, 2) __cold
 int printk_sched(const char *s, ...)
 {
@@ -191,6 +207,8 @@ extern void dump_stack(void) __cold;
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+#define pr_flush printk_flush
+
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
diff --git a/kernel/printk.c b/kernel/printk.c
index a2276b9..0e35931 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1144,6 +1144,23 @@ module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
+atomic_t printk_buffering = ATOMIC_INIT(1);
+
+bool printk_set_buffering(bool enable)
+{
+	if (enable)
+		return atomic_inc_and_test(&printk_buffering);
+
+	return atomic_dec_and_test(&printk_buffering);
+}
+EXPORT_SYMBOL(printk_set_buffering);
+
+bool printk_get_buffering(void)
+{
+        return atomic_read(&printk_buffering);
+}
+EXPORT_SYMBOL(printk_get_buffering);
+
 /*
  * Call the console drivers, asking them to write out
  * log_buf[start] to log_buf[end - 1].
@@ -1288,6 +1305,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	bool newline = false;
 	bool prefix = false;
+	bool buffered = atomic_read(&printk_buffering);
 	int printed_len = 0;
 
 	boot_delay_msec();
@@ -1355,8 +1373,16 @@ asmlinkage int vprintk_emit(int facility, int level,
 		}
 	}
 
-	if (level == -1)
+	switch (level) {
+	case -1:
 		level = default_message_loglevel;
+		break;
+	case -2:
+		prefix = true;
+		level = default_message_loglevel;
+		buffered = false;
+		break;
+	}
 
 	if (dict) {
 		prefix = true;
@@ -1364,7 +1390,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	if (!newline) {
-		if (cont_len && (prefix || cont_task != current)) {
+		if (cont_len && (prefix || cont_task != current || !buffered)) {
 			/*
 			 * Flush earlier buffer, which is either from a
 			 * different thread, or when we got a new prefix.
@@ -1454,6 +1480,12 @@ asmlinkage int printk_emit(int facility, int level,
 }
 EXPORT_SYMBOL(printk_emit);
 
+void printk_flush(void)
+{
+	printk_emit(0, -2, NULL, 0, "printk_flush\n");
+}
+EXPORT_SYMBOL(printk_flush);
+
 /**
  * printk - print a kernel message
  * @fmt: format string


