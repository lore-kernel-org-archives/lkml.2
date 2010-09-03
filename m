Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0ICLzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:55:11 -0400
Received: from www.tglx.de ([62.245.132.106]:51096 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0ICLzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:55:09 -0400
Date: Fri, 3 Sep 2010 13:54:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        arve@android.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: lazy disabling and idle states
In-Reply-To: <4C80720A.40503@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1009031347490.3301@localhost6.localdomain6>
References: <4C80720A.40503@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2 Sep 2010, Abhijeet Dharmapurikar wrote:

> I understand that lazy disabling was introduced so that we don't loose wakeup
> interrupts while going in to suspend. The way lazy disabling is implemented is

No, that's wrong. lazy irq disabling has nothing to do with suspend at
all. It's there to avoid expensive access to interrupt controller
hardware. In most cases when an interrupt is disabled via
disable_irq(), then the device does not issue an interrupt, so we
optimize that case and do the lazy disable. The suspend code just
utilizes this detail.

If a driver is shutdown completely and called free_irq() then the irq
line is disabled at the hardware level in any case.

> in disable_irq() the interrupt is marked as IRQ_DISABLED but the irq_chip's
> mask function is not called. As a result the interrupt remains enabled in the
> irq controller and is masked in the controller only when it is raised again.
> 
> This raises the question of unnecessary wakeups in idle power collapse case.
> By idle power collapse I mean the low power state where the processor is shut
> off during long idle periods. While in idle power collapse, the cpu could wake
> up from a disabled interrupt only to realize that it was marked IRQ_DISABLED
> (as a part of lazy disabling) and would call the mask function and go to idle
> power collapse again. This behavior could have negative effect on power
> consumption.
> 
> One solution that comes to mind is that the idle power collapse code, before
> going to sleep, could iterate over the irq_desc's of all the interrupts and
> call mask on the ones marked as IRQ_DISABLED to make sure that they are
> actually masked in the controller. This would fix the unnecessary wakeups from
> idle power collapse. But this operation is very lengthy and inefficient
> because it may end up calling mask on interrupts that have been already
> masked.
> 
> Are there other solutions to address this issue? Feel free to correct me if I
> missed a something and my conclusion is incorrect.

Fix the device drivers which keep a device in a state which will fire
interrupts after the driver called disable_irq(). 
 
Thanks,

	tglx
