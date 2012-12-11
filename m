Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2LKKrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:47:45 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:56890 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2LKKro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:47:44 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v2] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing issues
Date: Tue, 11 Dec 2012 12:47:35 +0200
User-Agent: KMail/1.9.10
Cc: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271929.32315.vitas@nppfactor.kiev.ua> <201212101224.05087.vitas@nppfactor.kiev.ua> <20121210221927.GB8359@local>
In-Reply-To: <20121210221927.GB8359@local>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212111247.36167.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2012 00:37:59 Hans J. Koch wrote:
> On Mon, Dec 10, 2012 at 12:24:04PM +0200, Vitalii Demianets wrote:
> > > > > Hi Vitalii,
> > > > > thanks a lot for analyzing the problem so thoroughly. It made me
> > > > > review uio_pdrv_genirq.c again, and I noticed several issues and
> > > > > came to the following conclusions:
> > > > >
> > > > > 1.) priv->lock is completely unnecessary. It is only used in one
> > > > >function,
> > > > > so there's nothing it could possibly protect.
> > > > >
> > > > > 2.) All these "test_and_clear_bit" and "test_and_set_bit" calls are
> > > > > also unnecessary. We can simply use enable_irq and disable_irq in
> > > > > both the irq handler and in uio_pdrv_genirq_irqcontrol.
> > > > >
> > > > > We should go "back to the roots" and have a look at how UIO works.
> > > > > The workflow it is intended for is like this:
> > > > >
> > > > > 1.) Hardware is in Reset State (e.g. after boot). Any decent
> > > > > hardware has its interrupt disabled at that time.
> > > > >
> > > > > 2.) uio_pdrv_genirq is loaded. Kernel enables the irq.
> > > > >
> > > > > 3.) Userspace part of the driver comes up. It will initialize the
> > > > > hardware
> > > > > (including setting the bits that enable the interrupt).
> > > > >
> > > > > 4.) Userspace will then issue a blocking read() on /dev/uioX.
> > > > > Typically, there'll be a loop or a thread with this blocking read()
> > > > > at the beginning
> > > > > (usually using the select() call).
> > > > >
> > > > > 5.) At some time, a hardware interrupt will occur. The irq handler
> > > > > in kernel space will be called, only to disable the irq. This will
> > > > > also cause the UIO core to make /dev/uioX readable.
> > > > >
> > > > > 6.) Userspace's blocking read returns. Userspace does its work by
> > > > > reading/writing device memory.
> > > > >
> > > > > 7.) As the last thing, Userspace writes a "1" to /dev/uioX, which
> > > > > causes uio_pdrv_genirq_irqcontrol to be called, re-enabling the
> > > > > interrupt.
> > > > >
> > > > > 8.) Goto 4.)
> > > > >
> > > > > We should also remember that uio_pdrv_genirq_handler() is NOT a
> > > > > real hardware irq handler. The real handler is in the UIO core,
> > > > > which will increment the event number and wake up userspace.
> > > > >
> > > > > So, although your scenario clearly shows a subtle race condition,
> > > > > there is none. If userspace does stupid things, no harm will be
> > > > > done to the kernel.
> > > >
> > > > With all due respect, I disagree here. If userspace does stupid
> > > > things, unintentionally because of poorly written code or
> > > > intentionally because of
> >
> > a
> >
> > > > malicious purpose, we could have irq depth counter disbalanced which,
> > > > in turn, could lead to the interrupt not enabled when it should be.
> > >
> > > It's just the interrupt of a broken UIO userspace driver. Note that
> > > this is also a security mechanism, disabling the irq when it is not
> > > handled properly.
> > >
> > > > In which
> > > > case the whole system would stop doing useful things which it was
> > > > designed to do.
> > >
> > > If the kernel irq depth counter can't track the irq, I don't really see
> > > a point in fixing it by adding extra flags in a simple driver.
> >
> > The flag in driver would be needed if we supposed that userspace can do
> > stupid things. For example, userspace can call write() twice with zero
> > data. Which would lead to disabling irq twice. Which means that someone
> > would need to enable irq twice. Which is not in the userspace-kernel
> > interaction scenario you so clearly described above previously.
>
> Indeed. It means that somebody wrote bad userspace code, and it needs to be
> fixed there.
>
> > Also, without that flag the irq could be disabled twice even when
> > userspace do not do double-disable. It could happen when userspace is
> > writing to the device file AND irq is running at this same moment on
> > another CPU core concurrently.
>
> If that happens, then either userspace is broken or the device cannot be
> handled by a UIO driver (e.g. because irq rate is too high which is usually
> an indicator for bad hardware design).
>
> > Yes, you are right that such a situation could be avoided if userspace
> > code was written carefully. But how can you assure that every user will
> > write good code?
>
> I don't care at all. I know the quality of code written in industry too
> well. They'll write bad code. All we can do is prevent damage to others.
>
> > > > > If userspace is designed the way described above (and in the
> > > > > documentation), it will always wake up with its interrupt disabled,
> > > > > do its work, and then re-enable the interrupt. You can probably
> > > > > think of a few things userspace could do to screw things up. But
> > > > > that's not our problem.
> > > >
> > > > Disagree again. I think we can not leave a hole in kernel which opens
> > > > DOS possibilities and hope userspace will behave well. There are
> > > > always errors in the code. And security issues, too.
> > >
> > > UIO is a risky thing to begin with. There are many more possibilities
> > > to do bad things. That's why UIO devices are root-only.
> >
> > We can assume that code running under root does not do bad things on
> > purpose.
>
> If that was true, there would be no security problems in the world. Making
> UIO devices root-only is only a prerequisite for constructing a safe
> system. BTW, there are more safety-critical devices in a typical Linux
> system, e.g. /dev/mem.
>
> > But that doesn't mean that code running under root is bug-free.
>
> Is that so? Then root has to fix his/her code, like anyone else.
>
> > > > > Could you hack up a patch for that? I think it should start with
> > > > > removing
> > > > > uio_pdrv_genirq_platdata->lock and
> > > > > uio_pdrv_genirq_platdata->flags...
> > > > >
> > > > > Thanks again for your work. What do you think about my theory?
> > > >
> > > > I think that we should fix the bug, not ignore it.
> > >
> > > I don't see a bug here.
> >
> > There is no bug as long as you trust userspace code.
>
> I don't.
>
> > Personally I don't trust it. I don't trust even my own code. There were
> > plenty of times when I looked at my code ant thought: "Oh gosh, how could
> > I be so dumb!"
>
> Same here.
>
> > And kernel should behave properly no matter what stupid things userspace
> > does, shouldn't it?
>
> Exactly. That's what it's all about.
>
> > Isn't it one of the reasons why we have distinction between
> > kernel and user space at all? Because kernel is by definition trusted
> > code, and userspace is not.
>
> Yes. And with what I have suggested, we are in the position that userspace
> might create a situation in which it won't work anymore. That is alright
> for me, because it is its own fault. The kernel has to provide an interface
> that allows a proper userspace to be written. But it's not our task to fix
> or prevent userspace problems in the kernel. We have to do our best that
> buggy userspace cannot harm the rest of the kernel or other processes. But
> if some crap userspace code doesn't work or causes a few error messages in
> the logs, I still sleep very well.
>

I understand your position. I simply don't agree with it. I can't sleep well 
knowing that there is a potential concurrency issue that could be fixed, but 
wasn't. Even if it harms nobody else except the (userspace) driver which 
caused the issue in the first place.
At least now this discussion and patch for the issue sits in the LKML archive 
so that anybody can find it in case of necessity.
So, let's agree to disagree.

Please, review the v3 of "Fix memory freeing issues" patch (first in the 
series I posted yesterday) and ignore the second, as we haven't agreed 
on it.
