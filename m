Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1FFQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:44:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:47074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1FFQoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:44:23 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606161749.GA22157@elte.hu>
References: <4DEB933C.1070900@die-jansens.de>
	 <20110605151323.GA30590@elte.hu> <1307349530.2353.7374.camel@twins>
	 <20110606145827.GD30348@elte.hu> <1307372989.2322.136.camel@twins>
	 <1307375227.2322.161.camel@twins> <20110606155236.GA7374@elte.hu>
	 <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins>  <20110606161749.GA22157@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 18:44:09 +0200
Message-ID: <1307378649.2322.198.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:17 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2011-06-06 at 18:08 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Mon, 2011-06-06 at 17:52 +0200, Ingo Molnar wrote:
> > > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > 
> > > > > > Needs more staring at, preferably by someone who actually 
> > > > > > understands that horrid mess :/ Also, this all still doesn't make 
> > > > > > printk() work reliably while holding rq->lock.
> > > > > 
> > > > > So, what about my suggestion to just *remove* the wakeup from there 
> > > > > and use the deferred wakeup mechanism that klogd uses.
> > > > > 
> > > > > That would make printk() *visibly* more robust in practice.
> > > > 
> > > > That's currently done from the jiffy tick, do you want to effectively
> > > > delay releasing the console_sem for the better part of a jiffy?
> > > 
> > > Yes, and we already do it in some other circumstances. 
> > 
> > We do?
> 
> Yes, see the whole printk_pending logic, it delays:
> 
>                 wake_up_interruptible(&log_wait);
> 
> to the next jiffies tick.

Again, that's not console_sem ("..delay releasing console_sem.."
"..already done.." isn't true).

> > > Can you see 
> > > any problem with that? klogd is an utter slowpath anyway.
> > 
> > but console_sem isn't klogd. We delay klogd and that's perfectly 
> > fine, but afaict we don't delay console_sem.
> 
> But console_sem is really a similar special case as klogd. See, it's 
> about a *printk*. That's rare by definition.

But its not rare, its _the_ lock that serialized the whole console
layer. Pretty much everything a console does goes through that lock.

By delaying this with 10ms (CONFIG_HZ=100) per printk could really delay
the whole boot process.

> If someone on the console sees it he'll be startled by at least 10 
> msecs ;-) So delaying the wakeup to the next jiffy really fits into 
> the same approach as we already do with &log_wait, hm?

Not convinced yet, I mean, don't get me wrong, I'd love to rid us of the
thing, but I'm not sure delaying the release of a resource like this is
the right approach.

Ahh, what we could do is something like the below and delay both the
acquire and release of the console_sem.

---
 kernel/printk.c |   86 +++++++++++++++++++++++++-----------------------------
 1 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..d3bdf5a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -686,6 +686,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -774,16 +775,13 @@ static inline int can_use_console(unsigned int cpu)
  * messages from a 'printk'. Return true (and with the
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
  */
 static int console_trylock_for_printk(unsigned int cpu)
 	__releases(&logbuf_lock)
 {
 	int retval = 0;
 
+	spin_lock(&logbuf_lock);
 	if (console_trylock()) {
 		retval = 1;
 
@@ -803,12 +801,27 @@ static int console_trylock_for_printk(unsigned int cpu)
 	spin_unlock(&logbuf_lock);
 	return retval;
 }
+
 static const char recursion_bug_msg [] =
 		KERN_CRIT "BUG: recent printk recursion!\n";
 static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
 
+static DEFINE_PER_CPU(int, printk_pending);
+
+int printk_needs_cpu(int cpu)
+{
+	if (cpu_is_offline(cpu))
+		printk_tick();
+	return __this_cpu_read(printk_pending);
+}
+
+void printk_set_pending(void)
+{
+	this_cpu_write(printk_pending, 1);
+}
+
 int printk_delay_msec __read_mostly;
 
 static inline void printk_delay(void)
@@ -836,9 +849,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -859,7 +871,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -942,25 +953,13 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		if (*p == '\n')
 			new_text_line = 1;
 	}
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
+	printk_set_pending();
 
-	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
-	preempt_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
@@ -1201,29 +1200,6 @@ int is_console_locked(void)
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
@@ -1273,11 +1249,29 @@ void console_unlock(void)
 
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+
 	if (wake_klogd)
-		wake_up_klogd();
+		wake_up_interruptible(&log_wait);
 }
 EXPORT_SYMBOL(console_unlock);
 
+void printk_tick(void)
+{
+	if (!__this_cpu_read(printk_pending))
+		return;
+
+	/*
+	 * Try to acquire and then immediately release the
+	 * console semaphore. The release will do all the
+	 * actual magic (print out buffers, wake up klogd,
+	 * etc). 
+	 */
+	if (console_trylock_for_printk(smp_processor_id())) {
+		console_unlock();
+		__this_cpu_write(printk_pending, 0);
+	}
+}
+
 /**
  * console_conditional_schedule - yield the CPU if required
  *

