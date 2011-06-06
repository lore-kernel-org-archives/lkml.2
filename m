Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1FFPrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:47:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:47:18 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1307372989.2322.136.camel@twins>
References: <20110605110132.GB23463@elte.hu>
	 <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu>
	 <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu>
	 <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu>
	 <4DEB933C.1070900@die-jansens.de> <20110605151323.GA30590@elte.hu>
	 <1307349530.2353.7374.camel@twins>  <20110606145827.GD30348@elte.hu>
	 <1307372989.2322.136.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 17:47:07 +0200
Message-ID: <1307375227.2322.161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 17:09 +0200, Peter Zijlstra wrote:
> On Mon, 2011-06-06 at 16:58 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Sun, 2011-06-05 at 17:13 +0200, Ingo Molnar wrote:
> > > 
> > > > Now, this patch alone just removes a debugging check - but i'm not 
> > > > sure the debugging check is correct - we take the pi_lock in a raw 
> > > > way - which means it's not lockdep covered.
> > > 
> > > Ever since tglx did s/raw_/arch_/g raw_ is covered by lockdep.
> > 
> > It's not lockdep covered due to the lockdep_off(), or am i missing 
> > something?
> 
> Your initial stmt was about the raw_ part, raw_ locks are tracked by
> lockdep ever since tglx renamed them to arch_ and introduced new raw_
> primitives.
> 
> But yeah, the lockdep_off() stuff also disables all tracking, on top of
> that it also makes lock_is_held() return an unconditional false (even if
> the lock was acquired before lockdep_off and thus registered).
> 
> My patch that fixes lock_is_held() should avoid false
> lockdep_assert_held() explosions and this this printk() while rq->lock
> problem.
> 
> Removing lockdep_off() usage from printk() would also be nice, but Mike
> triggered logbuf_lock <-> rq->lock inversion with that due to the
> up(&console_sem) wakeup muck.
> 
> Ideally we'd pull the up() out from under logbuf_lock, am looking at
> that.

something like so,.. but then there's a comment about console_sem and
logbuf_lock interlocking in interating ways, but it fails to mention how
and why. But I think it should maybe work.. 

Needs more staring at, preferably by someone who actually understands
that horrid mess :/ Also, this all still doesn't make printk() work
reliably while holding rq->lock.

---
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -686,6 +686,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -782,7 +783,7 @@ static inline int can_use_console(unsign
 static int console_trylock_for_printk(unsigned int cpu)
 	__releases(&logbuf_lock)
 {
-	int retval = 0;
+	int retval = 0, wake = 0;
 
 	if (console_trylock()) {
 		retval = 1;
@@ -795,12 +796,14 @@ static int console_trylock_for_printk(un
 		 */
 		if (!can_use_console(cpu)) {
 			console_locked = 0;
-			up(&console_sem);
+			wake = 1;
 			retval = 0;
 		}
 	}
 	printk_cpu = UINT_MAX;
 	spin_unlock(&logbuf_lock);
+	if (wake)
+		up(&console_sem);
 	return retval;
 }
 static const char recursion_bug_msg [] =
@@ -836,9 +839,8 @@ asmlinkage int vprintk(const char *fmt,
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -859,7 +861,6 @@ asmlinkage int vprintk(const char *fmt,
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -956,11 +957,9 @@ asmlinkage int vprintk(const char *fmt,
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
-	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
-	preempt_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
@@ -1271,8 +1270,8 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+	up(&console_sem);
 	if (wake_klogd)
 		wake_up_klogd();
 }

