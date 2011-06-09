Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1FIOHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:07:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1FIOHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:07:13 -0400
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
In-Reply-To: <20110609135542.GD21100@elte.hu>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.590149293@chello.nl> <20110609133228.GB21100@elte.hu>
	 <1307626856.3941.80.camel@twins>  <20110609135542.GD21100@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Jun 2011 16:06:33 +0200
Message-ID: <1307628393.3941.87.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 15:55 +0200, Ingo Molnar wrote:

> > @@ -943,19 +939,14 @@ asmlinkage int vprintk(const char *fmt, 
> >  		if (*p == '\n')
> >  			new_text_line = 1;
> >  	}
> > +	printk_cpu = UINT_MAX;
> > +	spin_unlock(&logbuf_lock);
> 
> Hm, is that printk_cpu setting inside the critical section safe? What 
> happens if we get an NMI on this CPU in that window?

That's what the old code did, also NMI really shouldn't printk(), but
yeah, can flip those two lines, but in that same vein I should also flip
the setting of that variable with acquiring the lock.

Lots of churn due to moving __console_flush around.

---
Subject: printk: Avoid all wakeups from printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jun 08 17:29:59 CEST 2011

Since printk() has to acquire the console_sem in order to write its
data out to the console we have an up() in printk(). Even though
contention on the console_sem is rare under normal circumstances, when
it happens printk() will issue a wakeup. If printk us used from a
context that already owns the scheduler locks or locks that have a
reverse ordering with the scheduler locks this gives potential for
deadlocks.

Avoid the wakeup by creating special semaphore operations that keep
the semaphore internal spinlock held, this ensures console_sem
contention will spin on this lock and not get queued on the wait_list.

For now keep these special semaphore operations private to printk,
if there ever appears another valid user we can move them over to
semaphore.c (along with extending the interface to provide
{_irq,_irqsave} versions, as the current ones assume IRQs are disabled
(as per the use-case in printk).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |  210 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 103 insertions(+), 107 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -765,47 +765,11 @@ static volatile unsigned int printk_cpu 
  * being able to cope (CON_ANYTIME) don't call them until
  * this CPU is officially up.
  */
-static inline int can_use_console(unsigned int cpu)
+static inline int can_use_console(void)
 {
-	return cpu_online(cpu) || have_callable_console();
+	return cpu_online(smp_processor_id()) || have_callable_console();
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
-	int retval = 0, wake = 0;
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
-			wake = 1;
-			retval = 0;
-		}
-	}
-	printk_cpu = UINT_MAX;
-	spin_unlock(&logbuf_lock);
-	if (wake)
-		up(&console_sem);
-	return retval;
-}
 static const char recursion_bug_msg [] =
 		KERN_CRIT "BUG: recent printk recursion!\n";
 static int recursion_bug;
@@ -826,6 +790,97 @@ static inline void printk_delay(void)
 	}
 }
 
+static DEFINE_PER_CPU(int, printk_pending);
+
+void printk_tick(void)
+{
+	if (__this_cpu_read(printk_pending)) {
+		__this_cpu_write(printk_pending, 0);
+		wake_up_interruptible(&log_wait);
+	}
+}
+
+int printk_needs_cpu(int cpu)
+{
+	if (cpu_is_offline(cpu))
+		printk_tick();
+	return __this_cpu_read(printk_pending);
+}
+
+void wake_up_klogd(void)
+{
+	if (waitqueue_active(&log_wait))
+		this_cpu_write(printk_pending, 1);
+}
+
+static void __console_flush(void)
+{
+	unsigned long flags;
+	unsigned _con_start, _log_end;
+	unsigned wake_klogd = 0;
+
+	console_may_schedule = 0;
+
+	for ( ; ; ) {
+		spin_lock_irqsave(&logbuf_lock, flags);
+		wake_klogd |= log_start - log_end;
+		if (con_start == log_end)
+			break;			/* Nothing to print */
+		_con_start = con_start;
+		_log_end = log_end;
+		con_start = log_end;		/* Flush */
+		spin_unlock(&logbuf_lock);
+		stop_critical_timings();	/* don't trace print latency */
+		call_console_drivers(_con_start, _log_end);
+		start_critical_timings();
+		local_irq_restore(flags);
+	}
+	console_locked = 0;
+
+	/* Release the exclusive_console once it is used */
+	if (unlikely(exclusive_console))
+		exclusive_console = NULL;
+
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	if (wake_klogd)
+		wake_up_klogd();
+}
+
+
+/*
+ * Special 'atomic' semaphore operations that mimic down_trylock() + up(),
+ * except they don't release the semaphore internal lock and optimize the
+ * sem->count fiddling away.
+ *
+ * The advantage is that this construct doesn't generate wakeups on atomic_up()
+ * since any contending semaphore acquisition will still be spinning on the
+ * internal lock, instead of having gotten queued on the wait_list.
+ *
+ * printk() uses this to avoid generating wakeups, which would make it unsafe
+ * to use in certain contexts (avoids lock inversion or lock recursion with
+ * the scheduler locks).
+ *
+ * Assumes IRQs are disabled.
+ *
+ * Note:  We emphatically do *not* want this function exported. Ever.
+ * Note2: Even asking for that will likely buy you a nasty response.
+ */
+static int atomic_down_trylock(struct semaphore *sem)
+{
+	spin_lock(&sem->lock);
+	if (sem->count > 0)
+		return 0;
+
+	spin_unlock(&sem->lock);
+	return 1;
+}
+
+static void atomic_up(struct semaphore *sem)
+{
+	spin_unlock(&sem->lock);
+}
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -861,8 +916,8 @@ asmlinkage int vprintk(const char *fmt, 
 		zap_locks();
 	}
 
-	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
+	spin_lock(&logbuf_lock);
 
 	if (recursion_bug) {
 		recursion_bug = 0;
@@ -943,19 +998,14 @@ asmlinkage int vprintk(const char *fmt, 
 		if (*p == '\n')
 			new_text_line = 1;
 	}
+	spin_unlock(&logbuf_lock);
+	printk_cpu = UINT_MAX;
 
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
+	if (!atomic_down_trylock(&console_sem)) {
+		if (can_use_console())
+			__console_flush();
+		atomic_up(&console_sem);
+	}
 
 out_restore_irqs:
 	local_irq_restore(flags);
@@ -1200,29 +1250,6 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-static DEFINE_PER_CPU(int, printk_pending);
-
-void printk_tick(void)
-{
-	if (__this_cpu_read(printk_pending)) {
-		__this_cpu_write(printk_pending, 0);
-		wake_up_interruptible(&log_wait);
-	}
-}
-
-int printk_needs_cpu(int cpu)
-{
-	if (cpu_is_offline(cpu))
-		printk_tick();
-	return __this_cpu_read(printk_pending);
-}
-
-void wake_up_klogd(void)
-{
-	if (waitqueue_active(&log_wait))
-		this_cpu_write(printk_pending, 1);
-}
-
 /**
  * console_unlock - unlock the console system
  *
@@ -1239,41 +1266,10 @@ void wake_up_klogd(void)
  */
 void console_unlock(void)
 {
-	unsigned long flags;
-	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0;
+	if (!console_suspended)
+		__console_flush();
 
-	if (console_suspended) {
-		up(&console_sem);
-		return;
-	}
-
-	console_may_schedule = 0;
-
-	for ( ; ; ) {
-		spin_lock_irqsave(&logbuf_lock, flags);
-		wake_klogd |= log_start - log_end;
-		if (con_start == log_end)
-			break;			/* Nothing to print */
-		_con_start = con_start;
-		_log_end = log_end;
-		con_start = log_end;		/* Flush */
-		spin_unlock(&logbuf_lock);
-		stop_critical_timings();	/* don't trace print latency */
-		call_console_drivers(_con_start, _log_end);
-		start_critical_timings();
-		local_irq_restore(flags);
-	}
-	console_locked = 0;
-
-	/* Release the exclusive_console once it is used */
-	if (unlikely(exclusive_console))
-		exclusive_console = NULL;
-
-	spin_unlock_irqrestore(&logbuf_lock, flags);
 	up(&console_sem);
-	if (wake_klogd)
-		wake_up_klogd();
 }
 EXPORT_SYMBOL(console_unlock);
 

