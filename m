Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0KHV7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:59:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59798 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755693Ab0KHV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:59:30 -0500
Date: Mon, 8 Nov 2010 16:59:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <kgdb-bugreport@lists.sourceforge.net>,
        Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC PATCH 1/5] usb-hcd: implement polling a specific usb device
In-Reply-To: <4CD85575.2080305@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1011081650090.1340-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010, Jason Wessel wrote:

> > Let's put it this way: Your polling mechanism has conflated two 
> > separate issues.  The matter of polling the host controller driver is 
> > distinct from the question of which URBs to stick on the queue.
> > 
> > While kdb is running, it makes sense to give back only the URBs that 
> > are for the console device.  But if you are polling during the normal 
> > operation of printk and the usb serial console, then there's no reason 
> > not to give back all the URBs that complete during polling.
> > 
> 
> That is an interesting way to look at things...  You metioned I
> conflated to issues, but in my mind they were the same (kdb vs printk
> requiremetns).  I just figured we should do the minimum possible when
> trying to exec a printk() because we want it to be as reliable as
> possible.  I had the following example in mind where a usb camera
> driver executes a pile of printk()'s and the poll kicks in, we would
> only like the completion handler to run for the usb serial device and
> to defer the rest.

It's true that drivers might not expect URB completions to occur in the
middle of a printk.  Particularly on UP systems with interrupts
disabled!  And there is always a possibility of deadlock: If an URB
completion handler takes a spinlock and then calls printk, draining the
queue could end up waiting on the same spinlock.  But of course the
same thing would happen regardless of whether or not URBs are deferred
via the queue.

It seems clear that you don't want to drain the queue while kdb is 
running, so the usb serial console code shouldn't do it.  This in turn 
implies that when polling during normal console operation, URBs should 
not be put on the queue.  Try doing things that way and see if you run 
into trouble.

> What about the printk() case though?  My argument for queuing and
> scheduling was to minimize the ability that printk() will get deferred
> by something else.

I don't think giving back URBs at the end of a printk is any better 
than giving them back in the middle of a printk.  For example, consider 
the case where there are two printk statements in a row.

The place you will really run into trouble is if the driver for the 
USB console serial device includes a printk in its completion handler!

Alan Stern

