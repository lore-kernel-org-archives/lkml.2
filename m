Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1HXVmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:42:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1HXVmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:42:15 -0400
Date: Wed, 24 Aug 2011 14:42:01 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Message-ID: <20110824214201.GB30829@suse.de>
References: <13141210141189@kroah.org>
 <201108241320.47635.arnd@arndb.de>
 <4E54E4D9.6070802@suse.cz>
 <201108241635.13502.arnd@arndb.de>
 <4E556CB7.2010102@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E556CB7.2010102@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:27:19PM +0200, Jiri Slaby wrote:
> On 08/24/2011 04:35 PM, Arnd Bergmann wrote:
> > On Wednesday 24 August 2011, Jiri Slaby wrote:
> >> On 08/24/2011 01:20 PM, Arnd Bergmann wrote:
> >>> It's not clear to me what state->mutex protects in the serial_core, but
> >>> it has been around forever (used to be called state->sem)
> >>
> >> It was actually moved in uart_close back in 2003. Formerly (when there
> >> was only a coarse grained port_sem) it was right before uart_shutdown.
> >> But there were some flags to handle some races. I'm not sure whether the
> >> flags protected any race here though.
> > 
> > ok
> > 
> >>> and is held in
> >>> all uart functions, which is at least consistent. IIRC what Alan's plan
> >>> for this was, uart_close should eventually get changed to use
> >>> tty_port_close_start or even tty_port_close. Maybe the time for that has
> >>> come now, lacking better alternatives?
> >>
> >> Yes, I have such a patch in my queue. But it's not easy to get there.
> >> You may take a look at:
> >> http://decibel.fi.muni.cz/gitweb/?p=linux.git;a=shortlog;h=refs/heads/devel
> >>
> >> But it's still far from ready. And yet, in the queue, I still have
> >> port->mutex locked before tty_port_close_start like it is now.
> > 
> > Ah, right. I still don't see why the port->mutex is or is not needed there,
> > and I think that's the main issue.
> > 
> > By comparison, getting *_wait_until_sent to be called without BTM seems
> > easy -- we know that all callers from ->close() hold it, while the ones
> > from ->ioctl() don't. We could have a helper like
> > 
> > void tty_wait_until_sent_from_close(struct tty_struct *tty, long timeout)
> > {
> > 	tty_unlock(); /* tty->ops->close holds the BTM, drop it while waiting */
> > 	tty_wait_until_sent(tty, timeout);
> > 	tty_lock();
> > }
> > 
> > to deal with that, if only we can sort the lock ordering with .
> 
> Ah, it looks like I just got the reason why port->mutex is locked in the
> top of uart_close. In uart, TTY_CLOSING flag is not used. So there is
> nothing to protect against races between ->close (the code between the
> two spinlock critical sections corresponding to port_close_start and
> _end) and ->open (block_til_ready).
> 
> Other than that I see no point for the lock to be in the beginning. So
> if we introduce CLOSING flag (I do that in my patches implicitly),
> everything should be OK:
> * port->count etc is and always was protected by the spinlock,
> * ->stop_rx stands as I wrote earlier.
> * uart_wait_until_sent -- that one is already called without port->mutex
> from set_termios and tty_set_ldisc.
> 
> So it looks like we should:
> - introduce CLOSING flag
> - move the lock below, before shutdown
> - introduce your magic _from_close helper
> - use it
> 
> Doing this after we have all the helpers in place would be easier. There
> would be no need to play with CLOSING bit. But there will be no option
> to backport this to stable trees then. And I know I will have to do that
> at least for 3.0.
> 
> Note that we may use the _from_close helper from tty_port_close_start
> almost instantly. All users should not hold port->mutex over
> tty_port_close_start. But I need to check. Tomorrow.
> 
> In the meantime, comments welcome.

So, is your original patch you sent in this thread still needed?

confused,

greg k-h
