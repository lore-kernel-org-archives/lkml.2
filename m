Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2JWQag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:30:36 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41440 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880Ab2JWQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:30:34 -0400
Message-ID: <1351009822.2621.158.camel@thor>
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Tue, 23 Oct 2012 12:30:22 -0400
In-Reply-To: <20121023105140.5996c3a5@pyramind.ukuu.org.uk>
References: <1350565015.23730.4.camel@thor>
	 <20121022224505.GD24489@kroah.com> <1350959679.2621.55.camel@thor>
	 <20121023105140.5996c3a5@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-serial]

On Tue, 2012-10-23 at 10:51 +0100, Alan Cox wrote:
> > 1. The ldisc drops the contents of tty_buffer on hangup (rather than
> > waiting for completion). Maybe for other devices this isn't so
> > noticeable because the ldisc can mostly keep up with the device, but on
> > firewire the ldisc lags well behind. Right now, this driver works around
> > this by holding off the hangup until the ldisc empties the tty_buffer.
> > The driver determines how much data is still left in the tty_buffer by
> > walking the flip buffers.
> 
> The driver should not be trying to look at this, so it's good that it
> broke now. If you need it to process the data on then hangup then the
> core code wants fixing to allow this to occur.

Sorry. I assumed not waiting for ldisc completion on hangup was
architectural.

tty_ldisc_hangup() has this comment from '09:

	/*
	 * FIXME: Once we trust the LDISC code better we can wait here for
	 * ldisc completion and fix the driver call race
	 */

and then several lines below specifically stops emptying the tty_buffer:

	cancel_work_sync(&tty->buf.work);

But even earlier in tty_ldisc_hangup(), the ldisc has been flushed
(which the n_tty ldisc interprets as a reset).

> > 2. Because this driver can fill the entire tty_buffer (64K +) before the
> > ldisc even runs once, this driver has to self-throttle when feeding the
> > tty_buffer.
> 
> That wants investigating properly. We do multiple megabits quite happily
> via the tty layer with 3G modems over USB. What is your data rate ?

The _slowest_ Firewire does 125 Mbits/sec using only the portion of the
bus cycle assigned for async tx (which is what this driver uses). That's
2Kbytes every 125us. Real world can be pretty close to that because
Firewire uses autonomous DMA and most controllers allow spillover into
the portion of bus cycle assigned for sync tx (which is another 4Kbytes
per 125us).  (Technical note: the actual total max for combined async
and sync tx is 6144 bytes per 125us clock)

2Kbytes/125us = 16Kbytes/1ms = 160Kbytes/jiffy (for CONFIG_HZ_100)

Some retail Firewire controllers do twice that, controllers in
early-production do 4x that, and reportedly at least one prototype does
8x that (although I haven't seen it or tested it).

'cat /dev/fwtty0' using this driver gets considerably less that, but
still enough to find this race.

Ignoring for a moment the data rates, the throttling logic is racy
because the ldisc sends the throttle from non-atomic context (so that
termios can be locked and accessed) but the driver fills the tty_buffer
from atomic context. In other words, the condition for which the ldisc
will send a throttle (receive_room < TTY_THRESHOLD_THROTTLE) hasn't yet
happened, but it will the next time receive_buf() runs.

So, the best that tty_insert_flip_string_* can do is return an error
that tty_buffer_alloc() refuses to allocate more than 64k. But the
problem is this driver has data that __must__ go somewhere at that
particular point in time. This driver could introduce another layer of
buffering in front of this but that would defeat the purpose of even
having tty_buffer in the first place.

Checking how much space might be avail for future rx and throttling if
too low seems like the natural solution here. Of course, directly
peeking at tty_buffer is the wrong way to go about doing it. But what if
that was properly exposed by tty_buffer, such as (adjusted for Jiri's
recent changes):

int tty_buffer_space_avail(struct tty_struct *tty)
{
	struct tty_port *port = tty->port;
	struct tty_bufhead *buf = &port->buf;
	unsigned long flags;
	int avail;

	spin_lock_irqsave(&buf->lock, flags);
	avail = 65536 - buf.memory_used;  /* threshold used by tty_buffer_alloc() */
	spin_unlock_irqrestore(&buf->lock, flags);
	return avail;
}

Regards,
Peter Hurley




