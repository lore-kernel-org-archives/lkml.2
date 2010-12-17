Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0LQPZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:25:36 -0500
Received: from www.tglx.de ([62.245.132.106]:35632 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab0LQPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:25:34 -0500
Date: Fri, 17 Dec 2010 16:25:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D0B400D.8010903@siemens.com>
Message-ID: <alpine.LFD.2.00.1012171315260.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de>
 <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6> <4D0B3C11.4090307@siemens.com> <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6> <4D0B400D.8010903@siemens.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Jan Kiszka wrote:

> Am 17.12.2010 11:41, Thomas Gleixner wrote:
> > On Fri, 17 Dec 2010, Jan Kiszka wrote:
> >> Am 17.12.2010 11:23, Thomas Gleixner wrote:
> >>> OTOH, if we have to disable anyway, then we could simply keep it
> >>> disabled across the installation of a new handler. That would make the
> >>> notification business go away, wouldn't it ?
> >>
> >> No, the notification is still necessary in case the registered handler
> >> keeps the line off after returning from both hard and threaded handler.
> > 
> > And how should that happen? If it is in oneshot mode then the line is
> > reenabled when the thread handler returns.
> 
> disable_irq_nosync is called by the handler before returning. And it's
> the handler's job to revert this, properly synchronizing it internally.

disable_irq_nosync() is really the worst thing to do. That's simply
not going to work without a lot of fuglyness.

What about the following:

primary_handler(....)
{
	if (!shared)
		return IRQ_WAKE_THREAD;

	spin_lock(dev->irq_lock);

	if (from_my_device() || dev->irq_thread_waiting) {
	   	mask_dev();
		dev->masked = true;
		ret = IRQ_WAKE_THREAD;
	} else
		ret = IRQ_NONE;

	spin_unlock(dev->irq_lock);
	return ret;
}

check_timeout()
{
	if (dev->irq_active && wait_longer())
	   	return IRQ_WAKE_THREAD;
	return IRQ_HANDLED;
}

unmask_dev_if_necessary()
{
	if (dev->masked && dev->irq_active)
	   	umask_dev();
}

threaded_handler(....)
{
	if (!dev->irq_thread_waiting) {
		spin_lock_irq(dev->irq_lock);
		wake_user = do_magic_stuff_with_the_dev();
		dev->irq_thread_waiting = wake_user;
		spin_unlock(dev->irq_lock);
	   	if (wake_user)
			wake_up(user);
	}

	if (!dev->irq_thread_waiting) {
		spin_lock_irq(dev->irq_lock);
		unmask_dev_if_necessary();
		spin_unlock(dev->irq_lock);
		return IRQ_HANDLED;
	}

	/*
	 * Wait for user space to complete. Timeout is to
	 * avoid starvation of the irq line when
	 * something goes wrong
	 */
	wait_for_completion_timeout(dev->compl, SENSIBLE_TIMEOUT);

	spin_lock_irq(dev->irq_lock);
	if (timedout) {
		mask_dev();
		dev->masked = true;
		/*
		 * Leave dev->irq_thread_waiting untouched and let
		 * the core code reschedule us when check_timeout
		 * decides it's worth to wait. In any case we leave
		 * the device masked at the device level, so we don't
		 * cause an interrupt storm.
		 */
		ret = check_timeout();
	} else {
		unmask_dev_if_necessary();
		dev->irq_thread_waiting = false;
		ret = IRQ_HANDLED;
	}
	spin_unlock(dev->irq_lock);
	return ret;
}

userspace_complete()
{
	complete(dev->irq_compl);
}

Your aproach with disable_irq_nosync() is completely flawed, simply
because you try to pretend that your interrupt handler is done, while
it is not done at all. The threaded interrupt handler is done when
user space completes. Everything else is just hacking around the
problem and creates all that nasty transitional problems.

The above code does not have them at all. The threaded handler does
not care at all about the dev_id shared state encoding and the state
transitions. It merily cares about the device internal status
dev->masked. Everything else is handled by the genirq code and the
litte status check in the primary handler.

Neither does the user space completion care about it. It just
completes and is completely oblivious of the irq line state/mode. And
really, the user space part should not care at all. It can set some
status before calling complete(), but that's driver specific stuff and
has nothing to do with the irq handling magic.

It requires a few not too intrusive modifications to the genirq code:

   - Rescheduling the thread handler on IRQ_WAKE_THREAD
   - Changing the oneshot finalizing a bit
   - Adding the status manipulations for request/free_irq

Now you might argue that the timeout is ugly, but I don't think it's
ugly at all. You need it anyway in case user space failed
completely. And coming back after 100ms to let the genirq code handle
a disable_irq() or synchronize_irq() is a reasonable request, it's the
error/corner case at all. If there is code which installs/removes an
interrupt handler on the same line every 5ms, then this code becomes
rightfully blocked out for 100ms or such.

Thanks,

	tglx
