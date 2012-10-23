Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2JWDPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:15:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58200 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2JWDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:15:14 -0400
Date: Mon, 22 Oct 2012 20:15:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: devel@driverdev.osuosl.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
Message-ID: <20121023031543.GA22155@kroah.com>
References: <1350565015.23730.4.camel@thor>
 <20121022224505.GD24489@kroah.com>
 <1350959679.2621.55.camel@thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350959679.2621.55.camel@thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:34:39PM -0400, Peter Hurley wrote:
> On Mon, 2012-10-22 at 15:45 -0700, Greg Kroah-Hartman wrote:
> > On Thu, Oct 18, 2012 at 08:56:55AM -0400, Peter Hurley wrote:
> > > Please consider this serial driver for review for submission to staging.
> > > The firewire-serial driver implements TTY over IEEE 1394. In its default
> > > configuration, it creates 4 TTY devices and one loopback device per
> > > firewire card (respectively, named fwtty<n>~fwtty<n+3> and fwloop<n>).
> > > 
> > > Currently, the TTY devices auto-connect to every cabled peer (the TODO
> > > list includes plans for providing a sysfs interface to control virtual
> > > cabling with whitelist/blacklist support per GUID).
> > > 
> > > Efforts are still ongoing for a companion console driver, with plans to
> > > eventually add early_printk & kgdb support (via additional drivers).
> > > 
> > > Some issues did arise with both the TTY and Firewire subsystems which
> > > are noted in the TODO file. Please review these workarounds.
> > > 
> > > Peter Hurley (1):
> > >   staging: fwserial: Add TTY-over-Firewire serial driver
> > 
> > I'd like to get an Ack from Stefan here, before I'll add this to the
> > staging tree.
> 
> Of course.
> 
> Jiri's newest series ("TTY buffer in tty_port and other stuff") does
> break this driver, so I'll need to resubmit to address those changes.
> Two of the workarounds mentioned in the TODO are related to the
> tty_buffer interface; specifically,
> 
> 1. The ldisc drops the contents of tty_buffer on hangup (rather than
> waiting for completion). Maybe for other devices this isn't so
> noticeable because the ldisc can mostly keep up with the device, but on
> firewire the ldisc lags well behind. Right now, this driver works around
> this by holding off the hangup until the ldisc empties the tty_buffer.
> The driver determines how much data is still left in the tty_buffer by
> walking the flip buffers.

That's not good.  Surely other drivers must see this, as we handle tty
over ethernet, that should be just as fast as firewire, right?  What do
those drivers do to handle this issue?

> 2. Because this driver can fill the entire tty_buffer (64K +) before the
> ldisc even runs once, this driver has to self-throttle when feeding the
> tty_buffer. So as not to drop data, the driver has to know when a
> watermark is reached in the tty_buffer, to ensure that in-flight +
> already-accepted data can safely be moved to what remains avail in the
> tty_buffer. (The tty_buffer maxs at 64K). Currently, the avail level in
> the tty_buffer is computed by this driver (in the same manner as
> tty_buffer_alloc()).

I suggest bringing this up on the linux-serial@vger mailing list, Alan
and Jiri should be able to help you out.

thanks,

greg k-h
