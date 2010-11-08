Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0KHTTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:19:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40865 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752141Ab0KHTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:19:28 -0500
Date: Mon, 8 Nov 2010 14:19:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <kgdb-bugreport@lists.sourceforge.net>,
        Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC PATCH 1/5] usb-hcd: implement polling a specific usb device
In-Reply-To: <4CD81995.8060003@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1011081355050.1340-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010, Jason Wessel wrote:

> >> +static void usb_poll_irq_flush_helper(struct work_struct *dummy)
> >> +{
> >> +	struct urb *urb;
> >> +	struct urb *scratch;
> >> +	unsigned long flags;
> >> +
> >> +	mutex_lock(&usb_poll_irq_flush_mutex);
> > 
> > What is this mutex used for?
> 
> 
> This mutex exists because I did not see a way to create a static
> workqueue with the attribute WQ_NON_REENTRANT.  When the workqueue
> does not have this attribute there is a corner case that between two
> usb poll intervals (one being handled on cpu 0 and the next on cpu 1)
> that you can get two units of work to run concurrently.

So this reduces to the more fundamental question of why you need to use 
a workqueue in the first place.

> >> +	local_irq_save(flags);
> > 
> > Isn't this function meant to be called with interrupts disabled on all 
> > CPUs anyway?
> 
> 
> The usb_poll_irq_flush_helper() is called from a work queue at some
> point after the work had been originally been scheduled with the IRQ's
> off.  We might be able to simply lock the HCD instead, but it looked
> like the this code should really be called with the irq's off.  I came
> to that conclusion based on looking at if the irqs were on or off in
> the original context the HCD giveback was executed.
> 
> If you believe we don't need it, we'll simply remove the irq
> save/restore.

Oh, there's no question that interrupts need to be disabled.  However 
if this routine isn't called from a workqueue then interrupts will 
already be disabled.

> >> +void usb_poll_irq_schedule_flush(void)
> >> +{
> >> +	schedule_work(&usb_poll_irq_flush_work);
> >> +}
> >> +EXPORT_SYMBOL_GPL(usb_poll_irq_schedule_flush);
> > 
> > Why do you want to do this in a workqueue?  Just move all the code from 
> > usb_poll_irq_flush_helper over here directly.
> > 
> 
> 
> I want this in a work queue because we need to schedule this to run at
> a later point when the interrupts are restored.

Why?  Why not run it before interrupts are restored?

>  If I don't put the
> code here, it has to get duplicated in the kdb keyboard stack, as well
> as the usb serial console code.  The alternative is that we need a
> logical place to drain the queue at another point in the kernel or a
> timer.

The queue should be drained just before you exit the debugger.

> The "schedule later via a workqueue" seemed the path of least
> resistance.
> 
> You could argue that we might have a user of this API that would want
> to flush the delayed urb queue in a safe place.  For now though, the
> two users of the new poll API (kdb, and usb serial console) do not
> need it and this leads me to believe we would be best served to not
> export the flush helper.

Why should usb serial console need to use the queue?

Let's put it this way: Your polling mechanism has conflated two 
separate issues.  The matter of polling the host controller driver is 
distinct from the question of which URBs to stick on the queue.

While kdb is running, it makes sense to give back only the URBs that 
are for the console device.  But if you are polling during the normal 
operation of printk and the usb serial console, then there's no reason 
not to give back all the URBs that complete during polling.

In other words, usb_poll_irq() doesn't need to set or clear
usb_poll_hcd_device.  (Incidentally, that's not a very good name -- I'd 
change to it usb_poll_device.)  Instead, set that pointer when you 
enter the debugger and clear it when you leave the debugger, at which 
time you can drain the queue.

> >> --- a/include/linux/usb.h
> >> @@ -1188,6 +1192,7 @@ struct urb {
> >> +	struct list_head poll_list;	/* Added to the poll queue */
> > 
> > You don't need to add an additional list_head to struct urb -- it
> > already contains too much stuff.  Simply use urb_list; that's what it's
> > for.
> > 
> 
> 
> It looked to me like it might have already been used when I was
> sifting through the other code in drivers/usb/*, but if you say it is
> safe, I trust you.  :-)

As the kerneldoc comment says, it is for use by whoever owns the URB.  
Just before the URB is given back to the driver, the USB core no longer 
owns it and the driver doesn't yet own it.  Hence kdb can take 
ownership of the URB.

> >> +static void usb_do_console_write(struct usb_serial *serial,
> >> +				 struct usb_serial_port *port,
> >> +				 const char *buf, unsigned count)
> >> +{
> >> +	int retval;
> >> +	int loops = 100;
> >> +try_again:
> >> +	/* pass on to the driver specific version of this function if
> >> +	   it is available */
> >> +	if (serial->type->write)
> >> +		retval = serial->type->write(NULL, port, buf, count);
> >> +	else
> >> +		retval = usb_serial_generic_write(NULL, port, buf, count);
> >> +	if (retval < count && retval >= 0 && loops--) {
> >> +		/* poll the hcd device because the queue is full */
> > 
> > In fact you can call the poll routine on every iteration.  Only the 
> > udelay needs to wait for the queue to be full.
> 
> 
> I figured it would be best to sleep a bit but if you feel we should be
> able to poll every time we could go with a udelay(1) and loops =
> 10000, or udelay(10) and loops(1000).

You don't need any delay when polling.  But polling does take some
time, so it will slow things down a little.  I don't know, perhaps
leaving it the way it is will be best for now.

Alan Stern

