Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1ANLxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:53:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1ANLxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:53:07 -0500
Date: Fri, 14 Jan 2011 12:53:05 +0100
From: Libor Pechacek <lpechacek@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Berger <pberger@brimson.com>,
        Al Borchers <alborchers@steinerpoint.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.36-rc3] USB: serial: handle Data Carrier Detect
	changes
Message-ID: <20110114115305.GB19887@fm.suse.cz>
References: <20101217153422.GE20400@fm.suse.cz> <20110104135313.7bdd6deb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104135313.7bdd6deb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18-muttng (2008-05-17-r1399)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-01-11 13:53:13, Alan Cox wrote:
> On Fri, 17 Dec 2010 16:34:23 +0100 Libor Pechacek <lpechacek@suse.cz> wrote:
> > @Greg: There are two drivers left to be fixed - drivers/usb/serial/cp210x.c and
> > drivers/usb/serial/keyspan_pda.c.  cp210x device does not seem to have an
> > interrupt endpoint to report the changes so a polling thread seems to be needed
> > to detect DCD changes.  I can implement the polling for cp210x if you don't
> > have a better idea.
> 
> It might be worth making tty_port_open know how to handle such devices as
> I'd bet there will be others out there somewhere. Perhaps add a dcd_poll
> field that holds the poll time in ms then in the tty_port_block_til_ready
> code change from
> 
> 	tty_unlock();
> 	schedule();
> 	tty_lock();
> 
> to 
> 
> 	tty_unlock();
> 	if (port->dcd_poll)
> 		schedule_timeout(port->dcd_poll);
> 	else
> 		schedule();
> 	tty_lock

I fell in love with the idea and implemented it.   Then between implementation
and the first testing I realized that we also need to handle the complementary
case - DCD drop - where we indicate hangup.

At the moment I don't see an elegant solution to sense DCD drop.  For some
devices reading the status lines also involves an extra USB control transaction
that should be done quite often.  That looks too clumsy to me and I'd like to
avoid that if possible.

> > +/**
> > + *	usb_serial_handle_dcd_change - handle a change of carrier detect state
> > + *	@port: usb_serial_port structure for the open port
> > + *	@status: new carrier detect status, nonzero if active
> > + */
> > +void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
> > +						unsigned int status)
> > +{
> > +	struct tty_port *port = &usb_port->port;
> > +	struct tty_struct *tty = port->tty;
> > +
> > +	dbg("%s - port %d, status %d", __func__, usb_port->number, status);
> > +
> > +	if (status)
> > +		wake_up_interruptible(&port->open_wait);
> > +	else if (tty && !C_CLOCAL(tty))
> > +		tty_hangup(tty);
> > +}
> > +EXPORT_SYMBOL_GPL(usb_serial_handle_dcd_change);
> 
> This looks good except that port->tty isn't necessarily a safe
> de-reference so it would be better to pass the tty into the function so
> the caller must think about that problem (and all the calling points
> appear to have a tty reference held ready)

Thanks for the hint.  I like the separation and added the parameter.

Updated patch will follow.

Libor
-- 
Libor Pechacek
SUSE L3 Team, Prague
