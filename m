Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0K0DAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 22:00:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0K0DAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 22:00:04 -0500
Date: Fri, 26 Nov 2010 21:59:55 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101127025954.GA15818@bombadil.infradead.org>
References: <4CEE93FF.3040507@suse.cz>
 <1290705383-6608-1-git-send-email-jslaby@suse.cz>
 <20101126002840.GL22651@bombadil.infradead.org>
 <4CEF65CA.9020403@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEF65CA.9020403@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 08:46:18AM +0100, Jiri Slaby wrote:
> >> -	if (test_bit(TTY_CLOSING, &tty->flags))
> >> +	if (test_bit(TTY_CLOSING, &tty->flags) ||
> >> +			test_bit(TTY_LDISC_CHANGING, &tty->flags))
> >>  		return -EIO;
> >>  
> >>  	if (driver->type == TTY_DRIVER_TYPE_PTY &&
> > 
> > Unfortunately, users report this doesn't seem to fix things for them
> > (built against 2.6.36 (plus another patch you wrote iirc.))
> 
> Which patches exactly do you have? You need three of mine in 2.6.36.
> 
> > https://bugzilla.redhat.com/show_bug.cgi?id=630464#c27
> 

Hrm, I'm still seeing it on top of Linus' latest with that patch. :/

Even more bizarrely, I tried to come up with ways this could be failing,
and decided to test a few things...

I set_bit(TTY_DEBUG, &tty->flags) just before returning from
tty_init_dev (which, afaict, should be called for vc/tty$n and ptys?)
and then checked it with a similar WARN_ON in tty_reopen, and found that
I was hitting it fairly regularly.

As far as I can tell, for this to occur, we'd need something to open
/dev/tty1 first, which hits the tty_init_dev, and something else to very
closely follow that, hit the linking of driver->ttys[idx] and so skip
into tty_reopen, and smack into my WARN_ON.

Of course, given the locking, I have no idea how it could possibly be
happening.

I'm poking around to see, I think maybe something might be dropping
locks in the callchain that gives us a window where this might be
possible... I don't see any other way we could end up with tty1 having
TTY_LDISC unset.

(I'm poking in some more debugging, and moving the 'linking in' of the
 device until after tty_ldisc_setup in tty_init_dev, but I'm not
 particularly hopeful.)

 --Kyle
