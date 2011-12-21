Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1LULSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:18:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:43593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1LULS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:26 -0500
Message-Id: <20111221111143.511565321@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: [RFC][PATCH 4/7] printk: Rework printk recursion
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=printk-frobbery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current printk recursion detection mechanism has a couple of
problems:
 - it relies on being serialized on logbuf_lock
 - zap_locks() totally wrecks any and all output except maybe
   the recusion, but not even that in some cases.

The first problem is easy to understand and easy to fix, when the lock
operation recurses the recursion state is not detected and we deadlock
due to nested locking. Simply replace the printk_cpu thing with a
per-cpu recursion counter.

The second problem is slightly more difficult. The problem with
zap_locks() is that they re-init the locks possibly concurrently with
a user. The idea is that the current thread gets a 'fresh' unlocked
lock so that it can print its msgs, however if the concurrent printk()
cpu does raw_spin_unlock() it corrupts the spinlock state such that
nobody can print (tail is ahead of the head, *FAIL*).

Cure this by avoiding the logbuf_lock and console_sem alltogether for
recursive printk()s by using a separate per-cpu buffer to store the
msg in before dumping it out to the console.

As an extra reliability feature it prefers to use the early_console
when its available to avoid console->console nesting and resulting
deadlocks.

As a side effect of all this, recursive printk()s will not appear in
the logbuf and will thus be invisible for kmsg_dump(). The advantage
is a much more robust error path for normal consoles.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |   79 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 38 deletions(-)
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -497,10 +497,7 @@ void kdb_syslog_data(char *syslog_data[4
 }
 #endif	/* CONFIG_KGDB_KDB */
 
-/*
- * Call the console drivers on a range of log_buf
- */
-static void __call_console_drivers(unsigned start, unsigned end)
+static void con_write(const char *buf, unsigned len)
 {
 	struct console *con;
 
@@ -510,22 +507,25 @@ static void __call_console_drivers(unsig
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
+			con->write(con, buf, len);
 	}
 }
 
+#define PRINTK_BUF_SIZE 512
+static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_cpu_buf);
+
 #ifdef CONFIG_EARLY_PRINTK
 struct console *early_console;
 
 asmlinkage int early_vprintk(const char *fmt, va_list ap)
 {
-	char buf[512];
-	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
+	char *buf = get_cpu_var(printk_cpu_buf);
+	int n = vscnprintf(buf, PRINTK_BUF_SIZE, fmt, ap);
 	if (early_console)
 		early_console->write(early_console, buf, n);
 	else
 		n = 0;
-
+	put_cpu_var(printk_cpu_buf);
 	return n;
 }
 
@@ -542,6 +542,20 @@ asmlinkage int early_printk(const char *
 }
 #endif
 
+static int recursive_vprintk(const char *fmt, va_list ap)
+{
+	char *buf = get_cpu_var(printk_cpu_buf);
+	int n = vscnprintf(buf, PRINTK_BUF_SIZE, fmt, ap);
+#ifdef CONFIG_EARLY_PRINTK
+	if (early_console)
+		early_console->write(early_console, buf, n);
+	else
+#endif
+		con_write(buf, n);
+	put_cpu_var(printk_cpu_buf);
+	return n;
+}
+
 static int __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
@@ -558,6 +572,14 @@ MODULE_PARM_DESC(ignore_loglevel, "ignor
 	"print all kernel messages to the console.");
 
 /*
+ * Call the console drivers on a range of log_buf
+ */
+static void __call_console_drivers(unsigned start, unsigned end)
+{
+	con_write(&LOG_BUF(start), end - start);
+}
+
+/*
  * Write out chars from start to end - 1 inclusive
  */
 static void _call_console_drivers(unsigned start,
@@ -694,28 +716,6 @@ static void emit_log_char(char c)
 		logged_chars++;
 }
 
-/*
- * Zap console related locks when oopsing. Only zap at most once
- * every 10 seconds, to leave time for slow consoles to print a
- * full oops.
- */
-static void zap_locks(void)
-{
-	static unsigned long oops_timestamp;
-
-	if (time_after_eq(jiffies, oops_timestamp) &&
-			!time_after(jiffies, oops_timestamp + 30 * HZ))
-		return;
-
-	oops_timestamp = jiffies;
-
-	debug_locks_off();
-	/* If a crash is occurring, make sure we can't deadlock */
-	raw_spin_lock_init(&logbuf_lock);
-	/* And make sure that we print immediately */
-	sema_init(&console_sem, 1);
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static int printk_time = 1;
 #else
@@ -777,9 +777,6 @@ asmlinkage int printk(const char *fmt, .
 	return r;
 }
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int printk_cpu = UINT_MAX;
-
 /*
  * Can we actually use the console at this time on this cpu?
  *
@@ -823,7 +820,6 @@ static int console_trylock_for_printk(un
 			retval = 0;
 		}
 	}
-	printk_cpu = UINT_MAX;
 	if (wake)
 		up(&console_sem);
 	raw_spin_unlock(&logbuf_lock);
@@ -849,6 +845,9 @@ static inline void printk_delay(void)
 	}
 }
 
+static DEFINE_PER_CPU(int, printk_recursion);
+
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -869,7 +868,7 @@ asmlinkage int vprintk(const char *fmt, 
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
-	if (unlikely(printk_cpu == this_cpu)) {
+	if (unlikely(__this_cpu_read(printk_recursion))) {
 		/*
 		 * If a crash is occurring during printk() on this CPU,
 		 * then try to get the crash message out but make sure
@@ -881,11 +880,14 @@ asmlinkage int vprintk(const char *fmt, 
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
-		zap_locks();
+
+		debug_locks_off();
+		recursive_vprintk(fmt, args);
+		goto out_restore_irqs;
 	}
+	__this_cpu_inc(printk_recursion);
 
 	raw_spin_lock(&logbuf_lock);
-	printk_cpu = this_cpu;
 
 	if (recursion_bug) {
 		recursion_bug = 0;
@@ -947,7 +949,7 @@ asmlinkage int vprintk(const char *fmt, 
 				unsigned long long t;
 				unsigned long nanosec_rem;
 
-				t = cpu_clock(printk_cpu);
+				t = sched_clock_cpu(this_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
 						(unsigned long) t,
@@ -980,6 +982,7 @@ asmlinkage int vprintk(const char *fmt, 
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
+	__this_cpu_dec(printk_recursion);
 out_restore_irqs:
 	local_irq_restore(flags);
 


