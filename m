Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170Ab2J2WOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:14:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35167 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761252Ab2J2WO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:14:27 -0400
Date: Mon, 29 Oct 2012 18:14:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Richard Retanubun <richardretanubun@ruggedcom.com>
cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
In-Reply-To: <508EEB48.9070508@ruggedcom.com>
Message-ID: <Pine.LNX.4.44L0.1210291806360.31151-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Richard Retanubun wrote:

> do the disconnect without actually removing the power to the device.
> I tried "echo 1 > /sys/bus/usb/drivers/usb/2-1.2/remove" and then take down the power
> but this produced the same leak signature even before I take down the power.
> 
> Update on trigger to problem
> ============================
> This will happen as the modem is powered down and /dev/ttyUSB from sierra is teared down
> either by powering it off/removing it, or sending at!reset.
> 
> It does not happen when the same thing is done using a simple usb to serial converter (pl2303)
> 
> Focusing down on one of the dumps:
> 
> unreferenced object 0xd3849740 (size 8):
>    comm "khubd", pid 1026, jiffies 232553037 (age 506.597s)
>    hex dump (first 8 bytes):
>      4d 43 38 37 30 35 00 00                          MC8705..
>    backtrace:
>      [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
>      [<e30e77bc>] usb_enumerate_device+0x44/0xf8 [usbcore]
>      [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
>      [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
>      [<c0043aa8>] kthread+0x7c/0x80
>      [<c000ed48>] kernel_thread+0x4c/0x68
> 
> I have a small question. How does the memory kmalloc-ed() in usb_cache_string is supposed to be released?
> (during usb_serial_disconnect()?)

It doesn't get released during usb_serial_disconnect().  It gets 
released during usb_release_dev() in drivers/usb/core/usb.c.

>  Is the sierra driver is supposed to participate
> in the tear down process (in sierra_release() maybe) and not doing something that is expected?

Probably not.

> I am still missing the link between the actions done by the hub_thread() for the caching the stings
> and the sierra driver code.

They aren't all that closely related.

usb_release_dev() won't be called until all references to the USB
device have been dropped.  Maybe there's an extra reference hanging 
around.

Alan Stern

