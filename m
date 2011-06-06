Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab1FFNcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:32:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:37694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab1FFNcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:32:07 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606132142.GA11223@elte.hu>
References: <20110605152641.GA31124@elte.hu>
	 <20110605153218.GA31471@elte.hu> <4DEBA9CC.4090503@die-jansens.de>
	 <4DEBB05C.8090506@die-jansens.de> <4DEBB3DA.8060001@die-jansens.de>
	 <20110605172052.GA1036@elte.hu> <4DEBBFF9.2030101@die-jansens.de>
	 <20110605185957.GA3452@elte.hu> <20110606131024.GA7386@elte.hu>
	 <1307365928.2322.103.camel@twins>  <20110606132142.GA11223@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 15:31:47 +0200
Message-ID: <1307367107.2322.123.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 15:21 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2011-06-06 at 15:10 +0200, Ingo Molnar wrote:
> > 
> > 
> > > diff --git a/kernel/printk.c b/kernel/printk.c
> > > index 3518539..1b9d2be 100644
> > > --- a/kernel/printk.c
> > > +++ b/kernel/printk.c
> > > @@ -859,7 +859,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
> > >  		zap_locks();
> > >  	}
> > >  
> > > -	lockdep_off();
> > 
> > At the very least you should also do: s/raw_local_irq_/local_irq/ on
> > this function.
> 
> Right, i've also removed the preempt_disable()/enable() pair - that 
> looks superfluous.

aside from the preempt thing, such a patch was just tested, I had a
module trigger a lockdep warning, and stuck a printk() in the middle of
ttwu (conditional so I could actually boot).

So go ahead, and merge this.

We still need the patch to lock_is_held() though, since there's a few
other lockdep_off() sites in the kernel, and at least the NTFS one needs
to be able to schedule.


