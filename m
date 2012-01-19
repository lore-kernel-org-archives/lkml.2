Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2ASTnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:43:24 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59119 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab2ASTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:43:22 -0500
Date: Thu, 19 Jan 2012 11:42:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Fix wakeup init logic to speed up startup
Message-ID: <20120119194242.GE2373@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1327001336-28703-1-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327001336-28703-1-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011919-5518-0000-0000-000001A91D63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:28:56AM -0800, Simon Glass wrote:
> The synchronize_rcu() call resulting from making every serial driver
> wake-up capable (commit b3b708fa) slows boot down on my Tegra2x system
> (with CONFIG_PREEMPT disabled).
> 
> But this is avoidable since it is the device_set_wakeup_enable() and then
> subsequence disable which causes the delay. We might as well just make
> the device wakeup capable but not actually enable it for wakeup until
> needed.
> 
> Effectively the current code does this:
> 
> 	device_set_wakeup_capable(dev, 1);
> 	device_set_wakeup_enable(dev, 1);
> 	device_set_wakeup_enable(dev, 0);
> 
> We can just drop the last two lines.
> 
> Before this change my boot log says:
> [    0.227062] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    0.702928] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
> 
> after:
> [    0.227264] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    0.227983] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
> 
> for saving of 450ms.

You have multiple CPUs running at this point, correct?  Before that
second CPU starts up, synchronize_rcu() is a no-op.

The patch looks good to me, but then again, I do not consider myself
qualified to have an opinion on the TTY layer.  ;-)

							Thanx, Paul

> Suggested-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> ---
>  drivers/tty/serial/serial_core.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index c7bf31a..1305618 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -2348,11 +2348,11 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>  	 */
>  	tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
>  	if (likely(!IS_ERR(tty_dev))) {
> -		device_init_wakeup(tty_dev, 1);
> -		device_set_wakeup_enable(tty_dev, 0);
> -	} else
> +		device_set_wakeup_capable(tty_dev, 1);
> +	} else {
>  		printk(KERN_ERR "Cannot register tty device on line %d\n",
>  		       uport->line);
> +	}
> 
>  	/*
>  	 * Ensure UPF_DEAD is not set.
> -- 
> 1.7.7.3
> 

