Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2CYRU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:20:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52790 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2CYRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:20:26 -0400
Date: Sun, 25 Mar 2012 18:20:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120325172018.GL6589@ZenIV.linux.org.uk>
References: <4F5BDB09.3020407@suse.cz>
 <4F5BE1E6.9000201@nod.at>
 <4F5C861F.2000507@nod.at>
 <4F5DCF39.8080308@nod.at>
 <20120312105312.665d2362@pyramind.ukuu.org.uk>
 <4F5DDAD4.4060504@nod.at>
 <20120312114832.784bb6fe@pyramind.ukuu.org.uk>
 <20120324232001.GK6589@ZenIV.linux.org.uk>
 <20120325155143.7ca7cb13@ultron>
 <4F6F365D.5060703@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6F365D.5060703@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 05:14:37PM +0200, Richard Weinberger wrote:
> >> FWIW, uml console in default config is basically "start xterm for each VC".
> >> What do you suggest to do on vhangup() on one of those?
> > 
> > What posix says must happen. Which is that the running processes get a
> > hangup. So a vhangup() would ensure there were no old apps on the UML
> > guess talking to the xterm (eg stealing login credentials, or abusing
> > TIOCSTI etc).

IIRC, vhangup(2) is Linux-specific, so I would be surprised if POSIX had
anything on it...

> Looks like Debian's /bin/login is violating POSIX. AFACT it does not
> call vhangup() at all.

... and Alan said nothing about /bin/login being required to call it,
be it by POSIX or by anything else.

login(1) from util-linux does vhangup(); login(1) from shadow doesn't.

> > The fact it's an xterm isn't really relevant. That's just the physical
> > interface and vhangup is about breaking the logical link. The xterm would
> > continue, no reason for it to do otherwise I can see ?
> > 
> 
> As I wrote in my very first mail, if I implement tty_operations->hangup()
> a vhangup() closes the current TTY and the shiny new login shell dies because
> read/write() returns EIO.

Hm?  If login(1) does vhangup(), it has to reopen tty - and util-linux
one does just that.  open() *after* vhangup() is supposed to work - it's
pre-existing openers that get screwed.  Which is why the sequence is
	fchown/fchmod to prevent new unpriveleged openers
	ignore SIGHUP
	vhangup to bugger all old openers (including ourselves - at that
point our stdin becomes unusable)
	open tty (BTW, I'd probably open /proc/self/0 instead of using
ttyname(3) result as util-linux is doing)
	replace stdin/stdout/stderr with it
And yes, it's far too convoluted...

	What makes me more concerned about the tty_port model is the
mechanism uml got for reconfiguring its ttys.  There's a control channel,
independent from the regular tty driver.  You can run mconsole(1) on host
to connect to it and issue commands; e.g. "config con2=pts" will remove
whatever you have as /dev/tty2 and associate it with pty pair on host.

The thing is, we don't want to do that when port is in use.  And we definitely
don't want somebody to open the damn thing when it's halfway through getting
set up.  I don't see any natural way to do that exclusion with tty_port -
port->{count,block_open} is protected only by a spinlock and port setup
we need to do is blocking...
