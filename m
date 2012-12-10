Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2LJJwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:52:32 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:48595 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab2LJJwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:52:30 -0500
Date: Mon, 10 Dec 2012 10:52:18 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Cong Ding <dinggnu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing
 issues
Message-ID: <20121210095218.GA8359@local>
References: <201211271929.32315.vitas@nppfactor.kiev.ua>
 <201212071700.54367.vitas@nppfactor.kiev.ua>
 <20121207234720.GB3786@local>
 <201212101103.59917.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212101103.59917.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:03:59AM +0200, Vitalii Demianets wrote:
> On Saturday 08 December 2012 01:47:21 Hans J. Koch wrote:
> > On Fri, Dec 07, 2012 at 05:00:54PM +0200, Vitalii Demianets wrote:
> > > > On second thought, we can't call enable_irq()/disable_irq()
> > > > unconditionally because of the potential disable counter
> > > > (irq_desc->depth) disbalance. That's why we need UIO_IRQ_DISABLED flag,
> > > > and that's why we should check it in uio_pdrv_genirq_irqcontrol().
> > > > On the other hand, you are right in that we don't need to check it
> > > > inside irq handler. Inside irq handler we can disable irq and set the
> > > > flag unconditionally, because:
> > > > a) We know for sure that irqs are enabled, because we are inside
> > > > (not-shared) irq handler;
> > > >  and
> > > > b) We are guarded from potential race conditions by spin_lock_irqsave()
> > > > call in uio_pdrv_genirq_irqcontrol().
> > > >
> > > > So,yes, we can get rid of costly atomic call to
> > > > test_and_set_bit(UIO_IRQ_DISABLED,..) inside irq handler. But I still
> > > > don't like the idea of mixing this optimization with bug fixes in a
> > > > single patch.
> > >
> > > On the third thought, we can't ;)
> > > Imagine the SMP system where uio_pdrv_genirq_irqcontrol() is being
> > > executed on CPU0 and irq handler is running concurrently on CPU1. To
> > > protect from disable_irq counter disbalance we must first check current
> > > irq status, and in atomic manner. Thus we prevent  double-disable, one
> > > from
> > > uio_pdrv_genirq_irqcontrol() running on CPU0 and another form irq handler
> > > running on CPU1.
> > > Above consideration justifies current code.
> > >
> > > But it seems we have potential concurrency problem here anyway. Here is
> > > theoretical scenario:
> > > 1) Initial state: irq is enabled, uio_pdrv_genirq_irqcontrol() starts
> > > being executed on CPU0 with irq_on=1 and at the same time, concurrently,
> > > irq handler starts being executed on CPU1;
> > > 2) irq handler executes line
> > >    if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
> > > as irq was enabled, the condition holds. And now UIO_IRQ_DISABLED is set.
> > > 3) uio_pdrv_genirq_irqcontrol() executes line
> > >    if (test_and_clear_bit(UIO_IRQ_DISABLED, &priv->flags))
> > > as UIO_IRQ_DISABLED was set by CPU1, the condition holds. And now
> > > UIO_IRQ_DISABLED is cleared.
> > > 4) CPU0 executes enable_irq() . IRQ is enabled. "Unbalanced enable for
> > > IRQ %d\n" warning is issued.
> > > 5) irq handler on CPU1 executes disable_irq_nosync(). IRQ is disabled.
> > >
> > > And now we are in situation where IRQ is disabled, but UIO_IRQ_DISABLED
> > > is cleared. Bad.
> > >
> > > The above scenario is purely theoretical, I have no means to check it in
> > > hardware.
> > > The (theoretical) solution is to guard UIO_IRQ_DISABLED test and actual
> > > irq disabling inside irq handler by priv->lock.
> > >
> > > What do you think about it? Is it worth worrying about?
> >
> > Hi Vitalii,
> > thanks a lot for analyzing the problem so thoroughly. It made me review
> > uio_pdrv_genirq.c again, and I noticed several issues and came to the
> > following conclusions:
> >
> > 1.) priv->lock is completely unnecessary. It is only used in one function,
> > so there's nothing it could possibly protect.
> >
> > 2.) All these "test_and_clear_bit" and "test_and_set_bit" calls are also
> > unnecessary. We can simply use enable_irq and disable_irq in both the
> > irq handler and in uio_pdrv_genirq_irqcontrol.
> >
> > We should go "back to the roots" and have a look at how UIO works.
> > The workflow it is intended for is like this:
> >
> > 1.) Hardware is in Reset State (e.g. after boot). Any decent hardware
> > has its interrupt disabled at that time.
> >
> > 2.) uio_pdrv_genirq is loaded. Kernel enables the irq.
> >
> > 3.) Userspace part of the driver comes up. It will initialize the hardware
> > (including setting the bits that enable the interrupt).
> >
> > 4.) Userspace will then issue a blocking read() on /dev/uioX. Typically,
> > there'll be a loop or a thread with this blocking read() at the beginning
> > (usually using the select() call).
> >
> > 5.) At some time, a hardware interrupt will occur. The irq handler in
> > kernel space will be called, only to disable the irq. This will also cause
> > the UIO core to make /dev/uioX readable.
> >
> > 6.) Userspace's blocking read returns. Userspace does its work by
> > reading/writing device memory.
> >
> > 7.) As the last thing, Userspace writes a "1" to /dev/uioX, which causes
> > uio_pdrv_genirq_irqcontrol to be called, re-enabling the interrupt.
> >
> > 8.) Goto 4.)
> >
> > We should also remember that uio_pdrv_genirq_handler() is NOT a real
> > hardware irq handler. The real handler is in the UIO core, which will
> > increment the event number and wake up userspace.
> >
> > So, although your scenario clearly shows a subtle race condition, there is
> > none. If userspace does stupid things, no harm will be done to the kernel.
> 
> With all due respect, I disagree here. If userspace does stupid things, 
> unintentionally because of poorly written code or intentionally because of a 
> malicious purpose, we could have irq depth counter disbalanced which, in 
> turn, could lead to the interrupt not enabled when it should be.

It's just the interrupt of a broken UIO userspace driver. Note that this is
also a security mechanism, disabling the irq when it is not handled properly.

> In which 
> case the whole system would stop doing useful things which it was designed to 
> do.

If the kernel irq depth counter can't track the irq, I don't really see a
point in fixing it by adding extra flags in a simple driver.

> 
> > If userspace is designed the way described above (and in the
> > documentation), it will always wake up with its interrupt disabled, do its
> > work, and then re-enable the interrupt. You can probably think of a few
> > things userspace could do to screw things up. But that's not our problem.
> >
> 
> Disagree again. I think we can not leave a hole in kernel which opens DOS 
> possibilities and hope userspace will behave well. There are always errors in 
> the code. And security issues, too.

UIO is a risky thing to begin with. There are many more possibilities to
do bad things. That's why UIO devices are root-only.

> 
> > Could you hack up a patch for that? I think it should start with removing
> > uio_pdrv_genirq_platdata->lock and uio_pdrv_genirq_platdata->flags...
> >
> > Thanks again for your work. What do you think about my theory?
> >
> 
> I think that we should fix the bug, not ignore it.

I don't see a bug here.

Thanks,
Hans

> 
> Ok, less words, more code. I am posting a new series of two patches. First 
> is "Fix memory freeing issues" (with improved wording in the comment which 
> you found unclear) and the second is about fixing SMP race condition.
> 
