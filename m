Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab2KLTcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 14:32:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:48741 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2KLTcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:32:01 -0500
Date: Mon, 12 Nov 2012 20:31:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION] 3.7-rc3+git hard lockup on CPU after inserting/removing
 USB stick
In-Reply-To: <201211121527.02007.Martin@lichtvoll.de>
Message-ID: <alpine.LFD.2.02.1211122025490.10000@ionos>
References: <201211071501.38288.Martin@lichtvoll.de> <201211101734.07084.Martin@lichtvoll.de> <27240C0AC20F114CBF8149A2696CBE4A1C2915@SHSMSX101.ccr.corp.intel.com> (sfid-20121111_105423_761739_F064F5AE) <201211121527.02007.Martin@lichtvoll.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Martin Steigerwald wrote:
> Am Sonntag, 11. November 2012 schrieb Liu, Chuansheng:
> > > The first bad commit is:
> > > 
> > > commit 73d4066055e0e2830533041f4b91df8e6e5976ff
> > > Author: Chuansheng Liu <chuansheng.liu@intel.com>
> > > Date:   Tue Sep 11 16:00:30 2012 +0800
> > > 
> > >     USB/host: Cleanup unneccessary irq disable code
> > > 
> > >     Because the IRQF_DISABLED as the flag is now a NOOP and has been
> > >     deprecated and in hardirq context the interrupt is disabled.
> > > 
> > >     so in usb/host code:
> > >     Removing the usage of flag IRQF_DISABLED;
> > >     Removing the calling local_irq save/restore actions in irq
> > >     handler usb_hcd_irq();
> > > 
> > >     Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > >     Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > 
> > > But:
> > > 
> > > This ony happens with threadirqs option!
> > > 
> > > When I remove threadirqs from kernel command line and reboot with this
> > > last bisect kernel USB sticks work.
> > > 
> > > That may explain why nobody else has seen this.
> > > 
> > > So I will try a 3.7-rc4 now, but without threadirqs enabled.
> > > 
> > Thanks your pointing out, the USB HCD irq handler is designed to
> > execute in irq handler with irq disabled.  When threadirqs is in
> > commandline, it will be executed in thread context with local irq
> > enabling, which causes this hardlockup.

No. The problem is caused by the commit above. USB with threaded
interrupt handlers worked perfectly fine in the past.
 
> > --- a/drivers/usb/core/hcd.c
> > +++ b/drivers/usb/core/hcd.c
> > @@ -2349,7 +2349,7 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
> >         if (hcd->driver->irq) {
> >                 snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
> >                                 hcd->driver->description, hcd->self.busnum);
> > -               retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
> > +               retval = request_irq(irqnum, &usb_hcd_irq, irqflags|IRQF_NO_THREAD,
> >                                 hcd->irq_descr, hcd);

NAK. This is exactly the wrong thing to do.

We want to be able to run that code in an handler thread. So you
removed the local_irq_save/restore() in the driver code and with
forced threaded irqs this breaks. Now setting IRQF_NO_THREAD is just
working around the problem that the above commit broke it.

There is no hard requirement to run USB interrupts in hard interrupt
context. I'd rather see the above commit reverted and then a proper
analysis done why removing local_irq_save/restore() breaks forced
threaded interrupt handlers.

Thanks,

	tglx
