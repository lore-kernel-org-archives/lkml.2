Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1FFNK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:10:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab1FFNKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:10:55 -0400
Date: Mon, 6 Jun 2011 15:10:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606131024.GA7386@elte.hu>
References: <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <20110605152641.GA31124@elte.hu>
 <20110605153218.GA31471@elte.hu>
 <4DEBA9CC.4090503@die-jansens.de>
 <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
 <20110605172052.GA1036@elte.hu>
 <4DEBBFF9.2030101@die-jansens.de>
 <20110605185957.GA3452@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605185957.GA3452@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> So some essential piece of the puzzle is still missing.

Oh. I think the essential piece of the puzzle might be this code in 
printk():

asmlinkage int vprintk(const char *fmt, va_list args)
{
...
        lockdep_off();
        if (console_trylock_for_printk(this_cpu))
                console_unlock();

        lockdep_on();
...

So while i right now do not see how this (ancient) piece of logic 
causes trouble, could you try the patch below, does it make the 
WARN()+lockup go away?

Thanks,

	Ingo

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..1b9d2be 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -859,7 +859,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -947,7 +946,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	 * Try to acquire and then immediately release the
 	 * console semaphore. The release will do all the
 	 * actual magic (print out buffers, wake up klogd,
-	 * etc). 
+	 * etc).
 	 *
 	 * The console_trylock_for_printk() function
 	 * will release 'logbuf_lock' regardless of whether it
@@ -956,7 +955,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
-	lockdep_on();
 out_restore_irqs:
 	raw_local_irq_restore(flags);
 
