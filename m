Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1FFN0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:26:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab1FFN0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:26:00 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Arne Jansen <lists@die-jansens.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1307356017.2353.7511.camel@twins>
References: <20110605151323.GA30590@elte.hu>
	 <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu>
	 <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de>
	 <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>
	 <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu>
	 <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>
	 <4DEBE3DF.70104@die-jansens.de> <1307350909.2353.7408.camel@twins>
	 <4DECA525.7030503@die-jansens.de>  <1307356017.2353.7511.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 15:25:42 +0200
Message-ID: <1307366742.2322.118.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 12:26 +0200, Peter Zijlstra wrote:
> On Mon, 2011-06-06 at 12:00 +0200, Arne Jansen wrote:
> > As expected this apparently fixes the problem. But are we confident
> > enough this is the true source? If it's really that simple, printk
> > calling into the scheduler, why am I the only one seeing this?
> 
> Right, so apparently you have contention on console_sem and the up()
> actually does a wakeup. I'm still trying to figure out how to do that.

On a related note, I'm not quite sure what we need that
lockdep_{off,on}() for, I just build and booted a kernel without them
and so far life is good.

I tried lockdep splats and in-scheduler printk()s (although the latter
will still mess up the box if printk()'s up(console_sem) triggers a
wakeup for obvious reasons).

---
Subject: lockdep, printk: Remove lockdep_off from printk()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jun 06 13:37:22 CEST 2011

Remove the lockdep_{off,on}() usage from printk() as it appears
superfluous, a kernel with this patch on can printk lockdep output just
fine.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -838,7 +838,7 @@ asmlinkage int vprintk(const char *fmt,
 
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -859,7 +859,6 @@ asmlinkage int vprintk(const char *fmt,
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -956,9 +955,8 @@ asmlinkage int vprintk(const char *fmt,
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
-	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	preempt_enable();
 	return printed_len;

