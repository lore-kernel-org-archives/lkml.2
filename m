Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2ASUNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:13:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34867 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab2ASUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:13:03 -0500
Date: Thu, 19 Jan 2012 12:12:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Fix wakeup init logic to speed up startup
Message-ID: <20120119201234.GG2373@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1327001336-28703-1-git-send-email-sjg@chromium.org>
 <20120119194242.GE2373@linux.vnet.ibm.com>
 <CAPnjgZ0kB8L6fFrcjq_0MSoh7KkL-051JHYptNQMaZNi89MavQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnjgZ0kB8L6fFrcjq_0MSoh7KkL-051JHYptNQMaZNi89MavQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011920-1780-0000-0000-000002785F55
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00106367; UDB=6.00026768; UTC=2012-01-19
 20:13:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:51:47AM -0800, Simon Glass wrote:
> Hi Paul,
> 
> On Thu, Jan 19, 2012 at 11:42 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Jan 19, 2012 at 11:28:56AM -0800, Simon Glass wrote:
> >> The synchronize_rcu() call resulting from making every serial driver
> >> wake-up capable (commit b3b708fa) slows boot down on my Tegra2x system
> >> (with CONFIG_PREEMPT disabled).
> >>
> >> But this is avoidable since it is the device_set_wakeup_enable() and then
> >> subsequence disable which causes the delay. We might as well just make
> >> the device wakeup capable but not actually enable it for wakeup until
> >> needed.
> >>
> >> Effectively the current code does this:
> >>
> >>       device_set_wakeup_capable(dev, 1);
> >>       device_set_wakeup_enable(dev, 1);
> >>       device_set_wakeup_enable(dev, 0);
> >>
> >> We can just drop the last two lines.
> >>
> >> Before this change my boot log says:
> >> [    0.227062] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> >> [    0.702928] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
> >>
> >> after:
> >> [    0.227264] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> >> [    0.227983] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
> >>
> >> for saving of 450ms.
> >
> > You have multiple CPUs running at this point, correct?  Before that
> > second CPU starts up, synchronize_rcu() is a no-op.
> 
> Yes that's right, although I didn't get different behavior with 'nosmp'.

If you are running CONFIG_PREEMPT=y, that is expected behavior, though
that grace period is a bit on the long side.  What is the value of HZ?

On the other hand, if you are running CONFIG_PREEMPT=n on recent kernels,
synchronize_rcu() will be a no-op any time that you are running with
only a single CPU.

The reason for this difference is that with CONFIG_PREEMPT=y, there might
be a preempted RCU reader, and RCU must check for this condition, waiting
for any such reader to complete.  In contrast, when CONFIG_PREEMPT=n on a
single-CPU system, the fact that you are executing in synchronize_rcu()
guarantees that there are no running RCU readers, so synchronize_rcu()
need do nothing in that case.

							Thanx, Paul

> > The patch looks good to me, but then again, I do not consider myself
> > qualified to have an opinion on the TTY layer.  ;-)
> 
> Thanks, me neither :-)
> 
> Regards,
> Simon
> 
> >
> >                                                        Thanx, Paul
> >
> >> Suggested-by: Rafael J. Wysocki <rjw@sisk.pl>
> >> Signed-off-by: Simon Glass <sjg@chromium.org>
> >> ---
> >>  drivers/tty/serial/serial_core.c |    6 +++---
> >>  1 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> >> index c7bf31a..1305618 100644
> >> --- a/drivers/tty/serial/serial_core.c
> >> +++ b/drivers/tty/serial/serial_core.c
> >> @@ -2348,11 +2348,11 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
> >>        */
> >>       tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
> >>       if (likely(!IS_ERR(tty_dev))) {
> >> -             device_init_wakeup(tty_dev, 1);
> >> -             device_set_wakeup_enable(tty_dev, 0);
> >> -     } else
> >> +             device_set_wakeup_capable(tty_dev, 1);
> >> +     } else {
> >>               printk(KERN_ERR "Cannot register tty device on line %d\n",
> >>                      uport->line);
> >> +     }
> >>
> >>       /*
> >>        * Ensure UPF_DEAD is not set.
> >> --
> >> 1.7.7.3
> >>
> >
> 

