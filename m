Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2JWCer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:34:47 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55333 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800Ab2JWCeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:34:46 -0400
Message-ID: <1350959679.2621.55.camel@thor>
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 22:34:39 -0400
In-Reply-To: <20121022224505.GD24489@kroah.com>
References: <1350565015.23730.4.camel@thor>
	 <20121022224505.GD24489@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 15:45 -0700, Greg Kroah-Hartman wrote:
> On Thu, Oct 18, 2012 at 08:56:55AM -0400, Peter Hurley wrote:
> > Please consider this serial driver for review for submission to staging.
> > The firewire-serial driver implements TTY over IEEE 1394. In its default
> > configuration, it creates 4 TTY devices and one loopback device per
> > firewire card (respectively, named fwtty<n>~fwtty<n+3> and fwloop<n>).
> > 
> > Currently, the TTY devices auto-connect to every cabled peer (the TODO
> > list includes plans for providing a sysfs interface to control virtual
> > cabling with whitelist/blacklist support per GUID).
> > 
> > Efforts are still ongoing for a companion console driver, with plans to
> > eventually add early_printk & kgdb support (via additional drivers).
> > 
> > Some issues did arise with both the TTY and Firewire subsystems which
> > are noted in the TODO file. Please review these workarounds.
> > 
> > Peter Hurley (1):
> >   staging: fwserial: Add TTY-over-Firewire serial driver
> 
> I'd like to get an Ack from Stefan here, before I'll add this to the
> staging tree.

Of course.

Jiri's newest series ("TTY buffer in tty_port and other stuff") does
break this driver, so I'll need to resubmit to address those changes.
Two of the workarounds mentioned in the TODO are related to the
tty_buffer interface; specifically,

1. The ldisc drops the contents of tty_buffer on hangup (rather than
waiting for completion). Maybe for other devices this isn't so
noticeable because the ldisc can mostly keep up with the device, but on
firewire the ldisc lags well behind. Right now, this driver works around
this by holding off the hangup until the ldisc empties the tty_buffer.
The driver determines how much data is still left in the tty_buffer by
walking the flip buffers.

2. Because this driver can fill the entire tty_buffer (64K +) before the
ldisc even runs once, this driver has to self-throttle when feeding the
tty_buffer. So as not to drop data, the driver has to know when a
watermark is reached in the tty_buffer, to ensure that in-flight +
already-accepted data can safely be moved to what remains avail in the
tty_buffer. (The tty_buffer maxs at 64K). Currently, the avail level in
the tty_buffer is computed by this driver (in the same manner as
tty_buffer_alloc()).

Eventually, I'd like to move these changes into tty_buffer but I wanted
to present the use case first.

Regards,
Peter Hurley

