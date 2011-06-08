Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1FHPut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:50:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1FHPuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:50:46 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1307380311.2322.223.camel@twins>
References: <20110606145827.GD30348@elte.hu>
	 <1307372989.2322.136.camel@twins> <1307375227.2322.161.camel@twins>
	 <20110606155236.GA7374@elte.hu> <1307376039.2322.164.camel@twins>
	 <20110606160810.GA16636@elte.hu> <1307376771.2322.168.camel@twins>
	 <20110606161749.GA22157@elte.hu> <4DED0292.1040605@die-jansens.de>
	 <4DED0423.4050904@die-jansens.de>  <20110606170725.GD2391@elte.hu>
	 <1307380311.2322.223.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Jun 2011 17:50:18 +0200
Message-ID: <1307548218.3941.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 19:11 +0200, Peter Zijlstra wrote:
> Delaying the console_sem release will delay anything touching the
> console_sem, including userland stuffs.
> 
> Delaying the console_sem acquire+release will delay showing important
> printk() lines on your serial.
> 
> Both suck. 

I came up with the below hackery, seems to actually boot and such on a
lockdep enabled kernel (although Ingo did report lockups with a partial
version of the patch, still need to look at that).

The idea is to use the console_sem.lock instead of the semaphore itself,
we flush the console when console_sem.count > 0, which means its
uncontended. Its more or less equivalent to down_trylock() + up(),
except it never releases the sem internal lock, and optimizes the count
fiddling away.

It doesn't require a wakeup because any real semaphore contention will
still be spinning on the spinlock instead of enqueueing itself on the
waitlist.

Its rather ugly, exposes semaphore internals in places it shouldn't,
although we could of course expose some primitives for this, but then
people might thing it'd be okay to use them etc..

/me puts on the asbestos underwear

comments?

---
 kernel/printk.c |  113 +++++++++++++++++++-----------------------------------
 1 files changed, 40 insertions(+), 73 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..127b003 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -686,6 +686,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -769,40 +770,6 @@ static inline int can_use_console(unsigned int cpu)
 	return cpu_online(cpu) || have_callable_console();
 }
 
-/*
- * Try to get console ownership to actually show the kernel
- * messages from a 'printk'. Return true (and with the
- * console_lock held, and 'console_locked' set) if it
- * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
- */
-static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
-{
-	int retval = 0;
-
-	if (console_trylock()) {
-		retval = 1;
-
-		/*
-		 * If we can't use the console, we need to release
-		 * the console semaphore by hand to avoid flushing
-		 * the buffer. We need to hold the console semaphore
-		 * in order to do this test safely.
-		 */
-		if (!can_use_console(cpu)) {
-			console_locked = 0;
-			up(&console_sem);
-			retval = 0;
-		}
-	}
-	printk_cpu = UINT_MAX;
-	spin_unlock(&logbuf_lock);
-	return retval;
-}
 static const char recursion_bug_msg [] =
 		KERN_CRIT "BUG: recent printk recursion!\n";
 static int recursion_bug;
@@ -823,6 +790,8 @@ static inline void printk_delay(void)
 	}
 }
 
+static void __console_flush(void);
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -836,9 +805,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -859,7 +827,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -942,25 +909,18 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		if (*p == '\n')
 			new_text_line = 1;
 	}
+	printk_cpu = UINT_MAX;
+	spin_unlock(&logbuf_lock);
 
-	/*
-	 * Try to acquire and then immediately release the
-	 * console semaphore. The release will do all the
-	 * actual magic (print out buffers, wake up klogd,
-	 * etc). 
-	 *
-	 * The console_trylock_for_printk() function
-	 * will release 'logbuf_lock' regardless of whether it
-	 * actually gets the semaphore or not.
-	 */
-	if (console_trylock_for_printk(this_cpu))
-		console_unlock();
+	spin_lock(&console_sem.lock);
+	if (console_sem.count > 0 && can_use_console(smp_processor_id()))
+		__console_flush();
+
+	spin_unlock(&console_sem.lock);
 
-	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
-	preempt_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
@@ -1224,31 +1184,12 @@ void wake_up_klogd(void)
 		this_cpu_write(printk_pending, 1);
 }
 
-/**
- * console_unlock - unlock the console system
- *
- * Releases the console_lock which the caller holds on the console system
- * and the console driver list.
- *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
- *
- * If there is output waiting for klogd, we wake it up.
- *
- * console_unlock(); may be called from any context.
- */
-void console_unlock(void)
+static void __console_flush(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
 	unsigned wake_klogd = 0;
 
-	if (console_suspended) {
-		up(&console_sem);
-		return;
-	}
-
 	console_may_schedule = 0;
 
 	for ( ; ; ) {
@@ -1271,11 +1212,37 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+
 	if (wake_klogd)
 		wake_up_klogd();
 }
+
+/**
+ * console_unlock - unlock the console system
+ *
+ * Releases the console_lock which the caller holds on the console system
+ * and the console driver list.
+ *
+ * While the console_lock was held, console output may have been buffered
+ * by printk().  If this is the case, console_unlock(); emits
+ * the output prior to releasing the lock.
+ *
+ * If there is output waiting for klogd, we wake it up.
+ *
+ * console_unlock(); may be called from any context.
+ */
+void console_unlock(void)
+{
+	if (console_suspended) {
+		up(&console_sem);
+		return;
+	}
+
+	__console_flush();
+
+	up(&console_sem);
+}
 EXPORT_SYMBOL(console_unlock);
 
 /**

