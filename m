Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2BLTGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 14:06:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53266 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2BLTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 14:06:20 -0500
Date: Sun, 12 Feb 2012 19:06:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: your mail
Message-ID: <20120212190611.GP23916@ZenIV.linux.org.uk>
References: <1329006070-4275-1-git-send-email-richard@nod.at>
 <20120212010211.GN23916@ZenIV.linux.org.uk>
 <4F37B34F.1040307@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F37B34F.1040307@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 01:40:47PM +0100, Jiri Slaby wrote:
> > Is tty_kref_put() safe in interrupt?  Here it seems to be OK, but in other
> > callers...  More or less at random: drivers/tty/serial/lantiq.c has it
> > called from lqasc_rx_int().  It seems to be possible to have it end up
> > calling ->ops->shutdown() and in this case that'd be lqasc_shutdown().
> > Which does a bunch of free_irq(), including the ->rx_irq, i.e. the one
> > we have it called from.  Alan?
> 
> I'm not Alan, but will reply anyway. Yes, it is safe (unless the driver
> does something tricky). In the driver you mention, this is uart_ops,
> called from tty_port_operations' ->shutdown. And that's a different from
> tty_operations' ->shutdown.
> 
> Yes, there are:
> * tty->ops
> * tty_port->ops
> * uart_port->ops
> 
> uart_port->ops->shutdown is supposed to tear down interrupts like in
> lantiq.c. It is called from tty_port->ops->shutdown. And that one is
> allowed to be called only from user context (tty->ops->close and
> tty->ops->hangup).

Yecchhh...  If I'm reading (and grepping) it right, there are only two
non-default instance of tty_operations ->shutdown() - pty and vt ones.
Lovely...  And while we are at it, vt instance is definitely not safe
from interrupts - calls console_lock().  Not that it was relevant in
this case...

It's probably too late in this case, but I would've called that method
->sync_cleanup().  Assuming I'm not misreading its intent and history...
