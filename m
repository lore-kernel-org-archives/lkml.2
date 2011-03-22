Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1CVLeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:34:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58152 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1CVLel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NCUgLtpoP3KRP12mTGLcqX5tYugG56l95qGG85u5u52mXUz+9R1PvEH0xksBXCy8G4
         Pit6WHnlGKeJHADm94xhSv+prO2dP+aspt7y2BWeEcLHED7cqar4gcH/upOcSfLKdLc7
         Ld9dL9WkmU1i4OBxMzTTzK20IKGvMqX6h8M1Y=
Date: Tue, 22 Mar 2011 12:34:35 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Toby Gray <toby.gray@realvnc.com>, Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: Prevent data loss when filling tty
 buffer.
Message-ID: <20110322113435.GC21027@localhost>
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
 <1300730698-17099-1-git-send-email-toby.gray@realvnc.com>
 <20110322100526.GB21343@localhost>
 <20110322103534.2284099e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322103534.2284099e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:35:34AM +0000, Alan Cox wrote:
> > re-submitted. So the only way this will work is if it can be guaranteed
> > that the line discipline will throttle and later unthrottle us. I
> > doubt that is the case, but perhaps Alan can give a more definite
> > answer?
> 
> If an ldisc throttles it should always later unthrottle. However flow
> control is async so at high enough data rates it'll be too slow.

So my suspicion that no guarantees can be made that ldisc will _eventually_
throttle us, is correct?

The patch would introduce its parallel throttling scheme (through not
rescheduling the tasklet), and will only work if a throttle request is
guaranteed to eventually arrive:

	16 x read_urb_bulk 
	 - queues up 16 urbs and buffers

	rx_tasklet
	 - attempt to push 16 buffers -- one is only partially pushed,
	   e.g.  64k of tty buffers full (or out of mem?)
	 - returns without resubmitting any urb or rescheduling tasklet
		
	Q: will ldisc always throttle us as the 64K worth of data is
	   later propagated to ldisc?

	A: Yes -- ldisc will throttle and later unthrottle, thereby
	          rescheduling tasklet which resumes reading.

	   No -- read will lock up

> > I would also prefer a more generic solution to the problem so that we
> > don't need to re-introduce driver buffering again. Since we already have
> > the throttelling mechanism in place, if we could only be notified/find
> > out that the tty buffers are say half-full, we could throttle (from
> 
> The tty layer actually knows this fact
> 
> > within the driver) but still push the remaining buffer still on the wire
> > as they arrive. It would of course require a guarantee that such a
> > throttle-is-about-to-happen notification is actually followed by (a
> > throttle and) unthrottle. Thoughts on that?
> 
> tty throttling is at the ldisc layer, the tty buffers are below this. The
> space left being 64K - tty->buf.memory_used
> 
> So you can certainly add the following routine
> 
> int tty_constipated(struct tty *t)
> {
> 	if (tty->buf.memory_used > 49152)
> 		return 1;
> 	return 0;
> }
> EXPORT_SYMBOL_GPL(tty_constipated);
> 
> to drivers/tty/tty_buffer.c
> 
> The wakeup side is a bit trickier.
> 
> The down side of this of course is that you are likely to run at below
> peak performance as you'll keep throttling back the hardware, whereas if
> you have a tickless kernel with HZ set to 1000 it's probably sufficient
> to bump the buffer sizes.
> 
> Right now (see tty_buffer.c) it's simply set to 64K as a sanity check
> against throttled devices not stopping, but there isn't actually any
> reason it couldn't be configurable at port setup time.

So you suggest increasing the tty buffering instead of solving the wake
up problem? Would this really be sufficient, though? What if a driver
pushes and resubmits from interrupt context and with sufficiently many
bulk urbs on the wire at high speeds manage to starve the tty work
queue so nothing gets flushed to the ldisc? Or this cannot happen?

Thanks,
Johan
