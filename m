Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1LLQfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:35:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:54161 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1LLQfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:35:54 -0500
Date: Mon, 12 Dec 2011 17:35:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Richard Weinberger <rw@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] printk: Disable migration instead of preemption
In-Reply-To: <1323703531.21400.1.camel@twins>
Message-ID: <alpine.LFD.2.02.1112121734580.3020@ionos>
References: <1323696956-11445-1-git-send-email-rw@linutronix.de> <1323703531.21400.1.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Peter Zijlstra wrote:

> On Mon, 2011-12-12 at 14:35 +0100, Richard Weinberger wrote:
> > There is no need do disable preemption in vprintk(),
> > disable_migrate() is sufficient.
> > This fixes also a the following bug in -rt:
> > 
> > [   14.759233] BUG: sleeping function called from invalid context
> > at /home/rw/linux-rt/kernel/rtmutex.c:645
> 
> > ---
> >  kernel/printk.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index a50af4e..13d0825 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -898,7 +898,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
> >  	boot_delay_msec();
> >  	printk_delay();
> >  
> > -	preempt_disable();
> > +	migrate_disable();
> >  	/* This stops the holder of console_sem just where we want him */
> >  	raw_local_irq_save(flags);
> >  	this_cpu = smp_processor_id();
> > @@ -1029,7 +1029,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
> >  out_restore_irqs:
> >  	raw_local_irq_restore(flags);
> >  
> > -	preempt_enable();
> > +	migrate_enable();
> >  	return printed_len;
> >  }
> >  EXPORT_SYMBOL(printk);
> 
> One has to wonder why this patch makes any difference what so ever, note
> how right after/before the preempt_disable/enable there's a
> raw_local_irq_save/restore and last time I checked those really did
> disable IRQs, even on -rt.

The point is that we drop that lock further down and on RT we also
reenable interrupts, so we have to prevent that we get migrated away.

Thanks,

	tglx
