Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705Ab2FASvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:51:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44487 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab2FASve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:51:34 -0400
MIME-Version: 1.0
In-Reply-To: <1338574627.2760.1545.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com> <1338402812.2760.413.camel@edumazet-glaptop>
 <4FC66D3D.6080509@fusionio.com> <1338404902.2760.451.camel@edumazet-glaptop>
 <1338410107.2760.544.camel@edumazet-glaptop> <1338456918.2760.1318.camel@edumazet-glaptop>
 <1338574627.2760.1545.camel@edumazet-glaptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 11:51:13 -0700
X-Google-Sender-Auth: BWcKaI3rkgwmS11rZhnN1hRBon8
Message-ID: <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
Subject: Re: [PATCH] tty: add lockdep annotations
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 11:17 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> About 10% of boots on my machine, and this looks like (hand written)
>
> general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> ...
> RIP : tty_shutdown+0x15/)x70

Ok, DEBUG_PAGEALLOC and with that offset fairly early in tty_shutdown,
it's almost certainly one of the accesses in the

  tty->driver->ops->remove

chain when it does the (inlined)

    tty_driver_remove_tty(tty->driver, tty);

you could check which one it is at that offset 0x15, but I think both
the ops and the driver structures should be statically allocated, so I
suspect it's the "tty" itself that is already freed.

Odd. But yes, smells very much like a refcount issue, probably due to
broken locking. Does the problem go away if you revert commits
d29f3ef39be4 ("tty_lock: Localise the lock") and 3af502b96649
("tty_lock: undo the old tty_lock use on the ctty")?

                  Linus
