Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0KKOew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:34:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0KKOev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:34:51 -0500
Date: Thu, 11 Nov 2010 09:34:25 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace()
 at the same time on SMP
Message-ID: <20101111143425.GG4823@redhat.com>
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
 <20101111111702.GA12644@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111111702.GA12644@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:17:02PM +0100, Ingo Molnar wrote:
> 
> Hm, another thing i noticed is that there's two of these:

I guess it depends how we want to deprecate the old nmi watchdog.
Dongdong was just patching the old and new code.

There are 3 ways we can go here.

- rip out the 'arch_trigger_all_cpu_backtrace' from the old nmi_watchdog,
  rework the Makefile and have both watchdogs use common code in hw_nmi.c

- patch both places

- rely on the fact that the old watchdog doesn't really work any more and
  only patch the new watchdog

I can put together a patch to do the first one, then have Dongdong put his
patch on top.  Selfishly I wouldn't mind just doing the third option. ;-)

Thoughts?

Cheers,
Don

> 
> >  #ifdef ARCH_HAS_NMI_WATCHDOG
> > +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> > +static unsigned long backtrace_flag;
> > +
> >  void arch_trigger_all_cpu_backtrace(void)
> >  {
> >  	int i;
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * Have to disable irq here, as the
> > +	 * arch_trigger_all_cpu_backtrace() could be
> > +	 * triggered by "spin_lock()" with irqs on.
> > +	 */
> > +	local_irq_save(flags);
> 
> > +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> > +static unsigned long backtrace_flag;
> > +
> >  void arch_trigger_all_cpu_backtrace(void)
> >  {
> >  	int i;
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * Have to disable irq here, as the
> > +	 * arch_trigger_all_cpu_backtrace() could be
> > +	 * triggered by "spin_lock()" with irqs on.
> > +	 */
> > +	local_irq_save(flags);
> > +
> > +	if (test_and_set_bit(0, &backtrace_flag))
> 
> A fair amount of code is being duplicated in two places - which is not nice. Lets 
> try to create a shared facility instead?
> 
> Thanks,
> 
> 	Ingo
