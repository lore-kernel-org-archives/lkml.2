Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0LQQGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:06:32 -0500
Received: from goliath.siemens.de ([192.35.17.28]:18129 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab0LQQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:06:31 -0500
Message-ID: <4D0B8A73.4050005@siemens.com>
Date: Fri, 17 Dec 2010 17:06:11 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@ieee.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de> <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6> <4D0B3C11.4090307@siemens.com> <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6> <4D0B400D.8010903@siemens.com> <alpine.LFD.2.00.1012171315260.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012171315260.12146@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.12.2010 16:25, Thomas Gleixner wrote:
> On Fri, 17 Dec 2010, Jan Kiszka wrote:
> 
>> Am 17.12.2010 11:41, Thomas Gleixner wrote:
>>> On Fri, 17 Dec 2010, Jan Kiszka wrote:
>>>> Am 17.12.2010 11:23, Thomas Gleixner wrote:
>>>>> OTOH, if we have to disable anyway, then we could simply keep it
>>>>> disabled across the installation of a new handler. That would make the
>>>>> notification business go away, wouldn't it ?
>>>>
>>>> No, the notification is still necessary in case the registered handler
>>>> keeps the line off after returning from both hard and threaded handler.
>>>
>>> And how should that happen? If it is in oneshot mode then the line is
>>> reenabled when the thread handler returns.
>>
>> disable_irq_nosync is called by the handler before returning. And it's
>> the handler's job to revert this, properly synchronizing it internally.
> 
> disable_irq_nosync() is really the worst thing to do. That's simply
> not going to work without a lot of fuglyness.
> 
> What about the following:
> 
> primary_handler(....)
> {
> 	if (!shared)
> 		return IRQ_WAKE_THREAD;
> 
> 	spin_lock(dev->irq_lock);
> 
> 	if (from_my_device() || dev->irq_thread_waiting) {
> 	   	mask_dev();
> 		dev->masked = true;
> 		ret = IRQ_WAKE_THREAD;
> 	} else
> 		ret = IRQ_NONE;
> 
> 	spin_unlock(dev->irq_lock);
> 	return ret;
> }
> 
> check_timeout()
> {
> 	if (dev->irq_active && wait_longer())
> 	   	return IRQ_WAKE_THREAD;
> 	return IRQ_HANDLED;
> }
> 
> unmask_dev_if_necessary()
> {
> 	if (dev->masked && dev->irq_active)
> 	   	umask_dev();
> }
> 
> threaded_handler(....)
> {
> 	if (!dev->irq_thread_waiting) {
> 		spin_lock_irq(dev->irq_lock);
> 		wake_user = do_magic_stuff_with_the_dev();
> 		dev->irq_thread_waiting = wake_user;
> 		spin_unlock(dev->irq_lock);
> 	   	if (wake_user)
> 			wake_up(user);
> 	}
> 
> 	if (!dev->irq_thread_waiting) {
> 		spin_lock_irq(dev->irq_lock);
> 		unmask_dev_if_necessary();
> 		spin_unlock(dev->irq_lock);
> 		return IRQ_HANDLED;
> 	}
> 
> 	/*
> 	 * Wait for user space to complete. Timeout is to
> 	 * avoid starvation of the irq line when
> 	 * something goes wrong
> 	 */
> 	wait_for_completion_timeout(dev->compl, SENSIBLE_TIMEOUT);
> 
> 	spin_lock_irq(dev->irq_lock);
> 	if (timedout) {
> 		mask_dev();
> 		dev->masked = true;
> 		/*
> 		 * Leave dev->irq_thread_waiting untouched and let
> 		 * the core code reschedule us when check_timeout
> 		 * decides it's worth to wait. In any case we leave
> 		 * the device masked at the device level, so we don't
> 		 * cause an interrupt storm.
> 		 */
> 		ret = check_timeout();
> 	} else {
> 		unmask_dev_if_necessary();
> 		dev->irq_thread_waiting = false;
> 		ret = IRQ_HANDLED;
> 	}
> 	spin_unlock(dev->irq_lock);
> 	return ret;
> }
> 
> userspace_complete()
> {
> 	complete(dev->irq_compl);
> }
> 
> Your aproach with disable_irq_nosync() is completely flawed, simply
> because you try to pretend that your interrupt handler is done, while
> it is not done at all. The threaded interrupt handler is done when
> user space completes. Everything else is just hacking around the
> problem and creates all that nasty transitional problems.

disable_irq_nosync is the pattern currently used in KVM, it's nothing
new in fact.

The approach looks interesting but requires separate code for
non-PCI-2.3 devices, i.e. when we have no means to mask at device level.
Further drawbacks - unless I missed something on first glance:

- prevents any future optimizations that would work without IRQ thread
  ping-pong (ie. once we allow guest IRQ injection from hardirq context
  for selected but typical setups)
- two additional, though light-weight, context switches on each
  interrupt completion
- continuous polling if user space decides to leave the interrupt
  unhandled (e.g. because the virtual IRQ line is masked)

Maybe the latter can be solved in a nicer way, but I don't think we can
avoid the first two. I'm not saying yet that they are killing this
approach, we just need to asses their relevance.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
