Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2CYWdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 18:33:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55139 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2CYWdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 18:33:24 -0400
Date: Sun, 25 Mar 2012 23:33:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120325223315.GN6589@ZenIV.linux.org.uk>
References: <4F5BE1E6.9000201@nod.at>
 <4F5C861F.2000507@nod.at>
 <4F5DCF39.8080308@nod.at>
 <20120312105312.665d2362@pyramind.ukuu.org.uk>
 <4F5DDAD4.4060504@nod.at>
 <20120312114832.784bb6fe@pyramind.ukuu.org.uk>
 <20120324232001.GK6589@ZenIV.linux.org.uk>
 <20120325155143.7ca7cb13@ultron>
 <20120325183114.GM6589@ZenIV.linux.org.uk>
 <20120325220610.49063ad7@ultron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325220610.49063ad7@ultron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 10:06:10PM +0100, Alan Cox wrote:
> Serial had pre-exising gunge not all of which has been cleaned, just as
> it still has its own buffers that want to be using kfifo.
> 
> Best examples are probably USB serial and neatest may well be the sdio
> serial card driver.

Umm...  So we have
	* tty_port created for each physical device, index assigned to it
and tty_register_device() done to create sysfs junk/kick udev/etc.
	* TTY layer allocates tty on demand (open() time) and feeds them
to ->install(), which is where we associate the suckers with tty_port,
grabbing a reference to the latter and shoving it into ->driver_data (OK,
it or that to struct it's embedded into - all the same)
	* ->cleanup() is called when TTY layer decided to free tty; drops
a reference to port.  Nobody will see that tty_struct anymore.
	* port outlives tty; over the lifetime of the latter associated
port remains the same.
	* ->open()/->close()/->hungup() simply call tty_port_...()
[BTW, is there any reason why you do not set ->driver_data to port and
use container_of() in the places that want other parts of containing
struct?  That way you wouldn't need those wrappers at all and while
->write() is certainly called more often, there's no extra cost - compiler
is able to figure out that local variable remains equal to argument-constant
and turn accesses relative to it into ones relative to argument]
	* guts of opening the damn thing go into ->activate(), guts of
stopping - into ->shutdown().
	* removal does tty_unregister_device() + prevents ->install() from
finding it + (under port->mutex) does tty_hangup() on associated tty (if any).
BTW, I really don't like the look of that place - tty_hangup() is async
(otherwise it'd deadlock instantly), so what the devil is protecting tty
from being freed before __tty_hangup() is done with it?  And when should
the actual channel be killed?  It appears to be done right after tty_hangup()
returns, but since the actual work done by it is async... why is that safe?
	* ->activate() plays strange games with TTY_IO_ERROR; why do we
bother, seeing that it's under port->mutex and anybody trying to open the
same tty will wait anyway?
