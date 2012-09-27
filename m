Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2I0R6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:58:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52566 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2I0R6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:58:34 -0400
Date: Thu, 27 Sep 2012 21:58:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        gregkh@linuxfoundation.org, xemul@parallels.com
Subject: Re: [patch 2/2] tty: Add get- ioctls to fetch tty status v2
Message-ID: <20120927175830.GT6618@moon>
References: <20120927165958.287690622@openvz.org>
 <20120927170137.805935065@openvz.org>
 <506491C1.7060807@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506491C1.7060807@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:49:53PM +0200, Jiri Slaby wrote:
> On 09/27/2012 07:00 PM, Cyrill Gorcunov wrote:
> > @@ -199,6 +207,25 @@ static int pty_set_pktmode(struct tty_st
> >  	return 0;
> >  }
> >  
> > +/* Get the packet mode of a pty */
> > +static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
> > +{
> > +	unsigned long flags;
> > +	int pktmode;
> > +
> > +	if (tty->driver->subtype != PTY_TYPE_MASTER)
> > +		return -ENOTTY;
> 
> The same as for 1/2^UFixed in v3 ;).

Already sent update, thanks :-)

> 
> > +	spin_lock_irqsave(&tty->ctrl_lock, flags);
> 
> I believe the lock is not the right one. It protects ctrl_status in
> TIOCPKT, not the packet. And it very seems that packet is unprotected at
> all over the code => the lock does not improve anything and is redundant.

Indeed, thanks Jiri!

> 
> > +	pktmode = tty->packet;
> > +	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
> > +
> > +	if (put_user(pktmode, arg))
> > +		return -EFAULT;
> > +
> > +	return 0;
> 
> This can be just
>   return put_user(pktmode, arg);
> Right?

As far as I see, yeah, put_user_[n] does return -efault
as well.

> 
> > +}
> > +
> ...
> > --- tty.git.orig/include/asm-generic/ioctls.h
> > +++ tty.git/include/asm-generic/ioctls.h
> > @@ -74,6 +74,9 @@
> >  #define TCSETXW		0x5435
> >  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
> >  #define TIOCVHANGUP	0x5437
> > +#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
> > +#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
> > +#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
> 
> This is not enough. Some arches do not include this file in their
> ioctls.h. You need to update them all.

Crap, for some reason cscope has not indexed them but git grep helped.
I'll update. Thanks, Jiri!

	Cyrill
