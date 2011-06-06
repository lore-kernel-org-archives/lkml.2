Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1FFNWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:22:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab1FFNWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:22:07 -0400
Date: Mon, 6 Jun 2011 15:21:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606132142.GA11223@elte.hu>
References: <20110605152641.GA31124@elte.hu>
 <20110605153218.GA31471@elte.hu>
 <4DEBA9CC.4090503@die-jansens.de>
 <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
 <20110605172052.GA1036@elte.hu>
 <4DEBBFF9.2030101@die-jansens.de>
 <20110605185957.GA3452@elte.hu>
 <20110606131024.GA7386@elte.hu>
 <1307365928.2322.103.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307365928.2322.103.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2011-06-06 at 15:10 +0200, Ingo Molnar wrote:
> 
> 
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index 3518539..1b9d2be 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -859,7 +859,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
> >  		zap_locks();
> >  	}
> >  
> > -	lockdep_off();
> 
> At the very least you should also do: s/raw_local_irq_/local_irq/ on
> this function.

Right, i've also removed the preempt_disable()/enable() pair - that 
looks superfluous.

Updated patch below - still untested.

Thanks,

	Ingo

---
 kernel/printk.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: tip/kernel/printk.c
===================================================================
--- tip.orig/kernel/printk.c
+++ tip/kernel/printk.c
@@ -836,9 +836,8 @@ asmlinkage int vprintk(const char *fmt, 
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -859,7 +858,6 @@ asmlinkage int vprintk(const char *fmt, 
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -947,7 +945,7 @@ asmlinkage int vprintk(const char *fmt, 
 	 * Try to acquire and then immediately release the
 	 * console semaphore. The release will do all the
 	 * actual magic (print out buffers, wake up klogd,
-	 * etc). 
+	 * etc).
 	 *
 	 * The console_trylock_for_printk() function
 	 * will release 'logbuf_lock' regardless of whether it
@@ -956,11 +954,9 @@ asmlinkage int vprintk(const char *fmt, 
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
