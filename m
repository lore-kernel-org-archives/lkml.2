Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab1HJEEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 00:04:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38723 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1HJEEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 00:04:49 -0400
Date: Wed, 10 Aug 2011 05:04:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
Message-ID: <20110810040445.GM2203@ZenIV.linux.org.uk>
References: <1312066923.22074.53.camel@i7.infradead.org>
 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
 <1312151063.18010.25.camel@i7.infradead.org>
 <20110731224834.GC2203@ZenIV.linux.org.uk>
 <20110731225801.GD2203@ZenIV.linux.org.uk>
 <1312153988.18010.39.camel@i7.infradead.org>
 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
 <20110801043207.GE2203@ZenIV.linux.org.uk>
 <CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
 <20110809233817.GL2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809233817.GL2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 12:38:17AM +0100, Al Viro wrote:

> 	* tty-on-xterm sometimes crashes on the first keysyms reaching it;
> as far as I can tell, it's something related to SIGWINCH handling - whether
> it happens or not depends on the way xterm windows are laid out and flipping
> between them first seems to prevent that shit.  If it hasn't happened at once,
> it won't happen at all...  Something in drivers/chan or drivers/line, most
> likely...

FWIW, what I'm seeing there is chan_interrupt() with tty that has definitely
been kfree'd.  What happens is that we have several opened files for
given tty and they all get closed in parallel.  Now, ->release() of
tty calls ->close() of driver (line_close() in this case) and then
gets around to decrementing tty->count.  As the result, *all* callers
of line_close() see line->tty->count > 1 and leave line->tty not reset to
NULL.  Oops...

Moral: do not use the counters on upper layer objects unless you know
what you are doing *and* know what will happen to that upper layer in
years to come...
