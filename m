Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1ADNyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:54:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47366 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034Ab1ADNyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:54:08 -0500
Date: Tue, 4 Jan 2011 13:53:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Libor Pechacek <lpechacek@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Berger <pberger@brimson.com>,
        Al Borchers <alborchers@steinerpoint.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.36-rc3] USB: serial: handle Data Carrier Detect
 changes
Message-ID: <20110104135313.7bdd6deb@lxorguk.ukuu.org.uk>
In-Reply-To: <20101217153422.GE20400@fm.suse.cz>
References: <20101217153422.GE20400@fm.suse.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 16:34:23 +0100
Libor Pechacek <lpechacek@suse.cz> wrote:

> Alan's commit 335f8514f200e63d689113d29cb7253a5c282967 introduced
> .carrier_raised function in several drivers.  That also means
> tty_port_block_til_ready can now suspend the process trying to open the serial
> port when Carrier Detect is low and put it into tty_port.open_wait queue.  We
> need to wake up the process when the Carrier Detect goes high.

(catching up after Christmas break)

> @Greg: There are two drivers left to be fixed - drivers/usb/serial/cp210x.c and
> drivers/usb/serial/keyspan_pda.c.  cp210x device does not seem to have an
> interrupt endpoint to report the changes so a polling thread seems to be needed
> to detect DCD changes.  I can implement the polling for cp210x if you don't
> have a better idea.

It might be worth making tty_port_open know how to handle such devices as
I'd bet there will be others out there somewhere. Perhaps add a dcd_poll
field that holds the poll time in ms then in the tty_port_block_til_ready
code change from

	tty_unlock();
	schedule();
	tty_lock();

to 

	tty_unlock();
	if (port->dcd_poll)
		schedule_timeout(port->dcd_poll);
	else
		schedule();
	tty_lock

??

> The keyspan_pda can report the changes asynchronously, but I haven't found the
> message format description anywhere.  Any idea how that driver can be fixed
> besides dropping .carrier_raised?

I don't - Greg may have info or of course you could cheat and wake the
queue whenever you see an unknown message format, then ask the device 8)

> +/**
> + *	usb_serial_handle_dcd_change - handle a change of carrier detect state
> + *	@port: usb_serial_port structure for the open port
> + *	@status: new carrier detect status, nonzero if active
> + */
> +void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
> +						unsigned int status)
> +{
> +	struct tty_port *port = &usb_port->port;
> +	struct tty_struct *tty = port->tty;
> +
> +	dbg("%s - port %d, status %d", __func__, usb_port->number, status);
> +
> +	if (status)
> +		wake_up_interruptible(&port->open_wait);
> +	else if (tty && !C_CLOCAL(tty))
> +		tty_hangup(tty);
> +}
> +EXPORT_SYMBOL_GPL(usb_serial_handle_dcd_change);

This looks good except that port->tty isn't necessarily a safe
de-reference so it would be better to pass the tty into the function so
the caller must think about that problem (and all the calling points
appear to have a tty reference held ready)

Looks good

Alan
