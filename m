Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2KMArh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:47:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:17141 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2KMArg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:47:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="167486377"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Martin Steigerwald <Martin@lichtvoll.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [REGRESSION] 3.7-rc3+git hard lockup on CPU after
 inserting/removing USB stick
Thread-Topic: [REGRESSION] 3.7-rc3+git hard lockup on CPU after
 inserting/removing USB stick
Thread-Index: AQHNwOHefquzpeMhkEmrM6LPTJGTnZfmEN0AgADbnjA=
Date: Tue, 13 Nov 2012 00:47:31 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1C3887@SHSMSX101.ccr.corp.intel.com>
References: <201211071501.38288.Martin@lichtvoll.de>
 <201211101734.07084.Martin@lichtvoll.de>
 <27240C0AC20F114CBF8149A2696CBE4A1C2915@SHSMSX101.ccr.corp.intel.com>
 (sfid-20121111_105423_761739_F064F5AE)
 <201211121527.02007.Martin@lichtvoll.de>
 <alpine.LFD.2.02.1211122025490.10000@ionos>
In-Reply-To: <alpine.LFD.2.02.1211122025490.10000@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, November 13, 2012 3:32 AM
> To: Martin Steigerwald
> Cc: Liu, Chuansheng; linux-kernel@vger.kernel.org; Ingo Molnar; Greg
> Kroah-Hartman
> Subject: Re: [REGRESSION] 3.7-rc3+git hard lockup on CPU after
> inserting/removing USB stick
> 
> On Mon, 12 Nov 2012, Martin Steigerwald wrote:
> > Am Sonntag, 11. November 2012 schrieb Liu, Chuansheng:
> > > > The first bad commit is:
> > > >
> > > > commit 73d4066055e0e2830533041f4b91df8e6e5976ff
> > > > Author: Chuansheng Liu <chuansheng.liu@intel.com>
> > > > Date:   Tue Sep 11 16:00:30 2012 +0800
> > > >
> > > >     USB/host: Cleanup unneccessary irq disable code
> > > >
> > > >     Because the IRQF_DISABLED as the flag is now a NOOP and has
> been
> > > >     deprecated and in hardirq context the interrupt is disabled.
> > > >
> > > >     so in usb/host code:
> > > >     Removing the usage of flag IRQF_DISABLED;
> > > >     Removing the calling local_irq save/restore actions in irq
> > > >     handler usb_hcd_irq();
> > > >
> > > >     Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > > >     Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > > >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > > >
> > > > But:
> > > >
> > > > This ony happens with threadirqs option!
> > > >
> > > > When I remove threadirqs from kernel command line and reboot with this
> > > > last bisect kernel USB sticks work.
> > > >
> > > > That may explain why nobody else has seen this.
> > > >
> > > > So I will try a 3.7-rc4 now, but without threadirqs enabled.
> > > >
> > > Thanks your pointing out, the USB HCD irq handler is designed to
> > > execute in irq handler with irq disabled.  When threadirqs is in
> > > commandline, it will be executed in thread context with local irq
> > > enabling, which causes this hardlockup.
> 
> No. The problem is caused by the commit above. USB with threaded
> interrupt handlers worked perfectly fine in the past.
The reason is that removing local_irq_save/restore() in function usb_hcd_irq().
The hard lockup analysis is:
CPU3
Usb_hcd_irq() -->
  ehci_irq -->
spin_lock (&ehci->lock);
...
if (status == ~(u32) 0) {

At this time, one hrtimer is coming:
ehci_hrtimer_func() -->
spin_lock_irqsave(&ehci->lock, flags);

Due to the spin_lock has been hold before, it causes the deadlock.

The dmesg is as below:
[  155.010424]  [<ffffffff814027b0>] ? _raw_spin_lock_irqsave+0x3f/0x48
[  155.010649]  [<ffffffff814027b0>] ? _raw_spin_lock_irqsave+0x3f/0x48
[  155.010884]  [<ffffffff814027b0>] ? _raw_spin_lock_irqsave+0x3f/0x48
[  155.011104]  <<EOE>>  <IRQ>  [<ffffffffa00c6836>] ehci_hrtimer_func+0x28/0xb5 [ehci_hcd]
[  155.011446]  [<ffffffff8105dc7d>] ? __remove_hrtimer+0x31/0x8b
[  155.011661]  [<ffffffffa00c680e>] ? end_free_itds+0x108/0x108 [ehci_hcd]
[  155.011911]  [<ffffffff8105e116>] __run_hrtimer+0xb9/0x176
[  155.012105]  [<ffffffff8105e804>] hrtimer_interrupt+0xcb/0x1b4
[  155.012311]  [<ffffffff810a4b6d>] ? irq_thread_fn+0x35/0x35
[  155.012509]  [<ffffffff8102abc2>] smp_apic_timer_interrupt+0x71/0x84
[  155.012742]  [<ffffffff81407b4a>] apic_timer_interrupt+0x6a/0x70
[  155.012950]  <EOI>  [<ffffffffa00c9087>] ? ehci_irq+0x39/0x267 [ehci_hcd]
[  155.013230]  [<ffffffff81401830>] ? __schedule+0x57f/0x5b2
[  155.013424]  [<ffffffff810a4b6d>] ? irq_thread_fn+0x35/0x35
[  155.013645]  [<ffffffffa003befc>] usb_hcd_irq+0x20/0x2f [usbcore]
[  155.013874]  [<ffffffff810a4b8d>] irq_forced_thread_fn+0x20/0x3e

> 
> > > --- a/drivers/usb/core/hcd.c
> > > +++ b/drivers/usb/core/hcd.c
> > > @@ -2349,7 +2349,7 @@ static int usb_hcd_request_irqs(struct usb_hcd
> *hcd,
> > >         if (hcd->driver->irq) {
> > >                 snprintf(hcd->irq_descr, sizeof(hcd->irq_descr),
> "%s:usb%d",
> > >                                 hcd->driver->description,
> hcd->self.busnum);
> > > -               retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
> > > +               retval = request_irq(irqnum, &usb_hcd_irq,
> irqflags|IRQF_NO_THREAD,
> > >                                 hcd->irq_descr, hcd);
> 
> NAK. This is exactly the wrong thing to do.
> 
> We want to be able to run that code in an handler thread. So you
As Martin's experience:
"I think that thread IRQs for USB based interrupts might not be a good
from another experience."
Maybe it shows something.

> removed the local_irq_save/restore() in the driver code and with
> forced threaded irqs this breaks. Now setting IRQF_NO_THREAD is just
> working around the problem that the above commit broke it.
> 
> There is no hard requirement to run USB interrupts in hard interrupt
> context. I'd rather see the above commit reverted and then a proper
> analysis done why removing local_irq_save/restore() breaks forced
> threaded interrupt handlers.
As you said, we can revert the patch directly, or submit a new patch to just add
local_irq_save/restore() back.
Anyway, hardlock reason is there.
Opinion?

> 
> Thanks,
> 
> 	tglx
