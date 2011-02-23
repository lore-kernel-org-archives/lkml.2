Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab1BWUac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:30:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:50965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1BWUab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:30:31 -0500
Date: Wed, 23 Feb 2011 12:29:15 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How important is it that tty_write_room doesn't lie?
Message-ID: <20110223202915.GB9081@suse.de>
References: <4D656679.90907@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D656679.90907@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:56:41PM -0600, Timur Tabi wrote:
> Greg,
> 
> As you may remember, I have a combination console/tty driver that talks to a
> serial-like FIFO provided by our hypervisor.  Both tty_operations.write() and
> console.write() talk to the same FIFO for character output.
> 
> I've implemented a tty_operations.write_room() function that queries the
> hypervisor for amount of free space in the FIFO.  I've noticed a subtle bug in
> this function, and I was hoping for some advice on how to fix it.
> 
> I believe I might have a problem when the following events happen in this order:
> 
> 1) The TTY layer calls write_room() to determine the amount of free space in the
> FIFO.
> 
> 2) The *console* layer calls console.write() to write some data (e.g. the kernel
> interrupted the TTY layer and executed a printk)
> 
> 3) Control returns to the TTY layer, which calls tty_operations.write(),
> assuming that the number returned by the previous call to write_room() is still
> correct.
> 
> Because of the interjected console write, the FIFO no longer has a much room as
> write_room() said it does.  When the TTY layer calls tty_operations.write(), my
> driver returns a number smaller than the size of the buffer passed to (i.e. not
> all characters were written).  The TTY layer, not expecting this, loses data.

Um, the tty layer should not loose data, but it is hard, if not
impossible, to re-write from within the tty layer due to lots of
different issues (if the data came from within it's hard, if it came
from userspace, it should be fine.)

> Is my assessment of the situation correct?  If so, is there any way around this
> problem that doesn't require implementing *two* software FIFOs in the driver:
> one for the console interface, and one for the TTY interface?  If every driver
> needs a FIFO like this, wouldn't it be simpler for the TTY and console layers to
> provide their own FIFOs?  I feel like I'm missing something obvious.

I think that people don't normally hit this as the console code isn't
used as a tty and a console at the same time, right?

How big is your buffer in your FIFO?  Can you always just say you have a
smaller ammount in order to try to work around the tty layer trying to
send you a few extra bytes at times?

thanks,

greg k-h
