Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2FAUXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:23:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:29519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759247Ab2FAUXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:23:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173797059"
Date: Fri, 1 Jun 2012 21:38:44 +0100
From: Alan Cox <alan@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
Message-ID: <20120601213844.3abdae5e@bob.linux.org.uk>
In-Reply-To: <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com>
	<1338402812.2760.413.camel@edumazet-glaptop>
	<4FC66D3D.6080509@fusionio.com>
	<1338404902.2760.451.camel@edumazet-glaptop>
	<1338410107.2760.544.camel@edumazet-glaptop>
	<1338456918.2760.1318.camel@edumazet-glaptop>
	<1338574627.2760.1545.camel@edumazet-glaptop>
	<CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 11:51:13 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jun 1, 2012 at 11:17 AM, Eric Dumazet
> <eric.dumazet@gmail.com> wrote:
> >
> > About 10% of boots on my machine, and this looks like (hand written)
> >
> > general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> > ...
> > RIP : tty_shutdown+0x15/)x70
> 
> Ok, DEBUG_PAGEALLOC and with that offset fairly early in tty_shutdown,
> it's almost certainly one of the accesses in the
> 
>   tty->driver->ops->remove
> 
> chain when it does the (inlined)
> 
>     tty_driver_remove_tty(tty->driver, tty);
> 
> you could check which one it is at that offset 0x15, but I think both
> the ops and the driver structures should be statically allocated, so I
> suspect it's the "tty" itself that is already freed.

Might be worth checking tty->magic in queue_release_one_tty and the
entry to release_one_tty

You can also turn on TTY_PARANOIA_CHECK defines which may show more but
can also be mistriggered in a few cases.

What distro setup is this and is it booting to run level 3 or 5. I'm
just wondering which paths you hit. Some of the distros do weird stuff
(notably Fedora is totally broken on the console management) and that
might be hiding a race or two in saner cases where you get more console
hangups.

Alan
