Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0FBHTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:19:31 -0400
Received: from www.tglx.de ([62.245.132.106]:51471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0FBHT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:19:29 -0400
Date: Wed, 2 Jun 2010 09:19:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Long playing threaded interrupt handlers
In-Reply-To: <20100602070922.GC3713@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.1006020913310.2933@localhost.localdomain>
References: <20100602070922.GC3713@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010, Dmitry Torokhov wrote:

> HI Thomas,
> 
> The threaded IRQ infrastructure that went into the kernel is extremely
> helpful, however in the input land there are quite a few devices that
> require polling after an IRQ has been raised.
> 
> Currently most such drivers, instead of threaded interrupts, still use
> [delayed] work to do the polling, and still face the issue of shutting
> down interrupt and scheduled work in a raceless way leaving irq enable
> counter balanced. Is it allowed to have threaded ISR execute for
> extended a amount of time, and do the required polling, provided that
> ISR does certain checks to finish promply in case when we unbind the
> driver or try to suspend the device?

Sure, why not ? The only thing we need to think about is when the poll
is busy polling for a long time, then we need to lower the irq thread
priority to SCHED_OTHER in order not to hog the CPU.

Vs. shutdown: The thread handler needs to be aware of a shutdown
request in it's poll loop, so something like this should work:

handler()
{
	while (work_to_do() && !shutdown) {
	      .....
	}
}

unbind()
{
	shutdown = 1;
	free_irq();
}

Thanks,

	tglx
