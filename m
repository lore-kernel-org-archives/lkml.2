Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab2FCBiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 21:38:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59471 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759168Ab2FCBiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 21:38:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com> <1338402812.2760.413.camel@edumazet-glaptop>
 <4FC66D3D.6080509@fusionio.com> <1338404902.2760.451.camel@edumazet-glaptop>
 <1338410107.2760.544.camel@edumazet-glaptop> <1338456918.2760.1318.camel@edumazet-glaptop>
 <1338574627.2760.1545.camel@edumazet-glaptop> <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
 <1338583498.2760.1648.camel@edumazet-glaptop> <20120601215620.305155c0@pyramind.ukuu.org.uk>
 <1338584389.2760.1653.camel@edumazet-glaptop> <1338621438.2760.1679.camel@edumazet-glaptop>
 <1338623708.2760.1691.camel@edumazet-glaptop> <1338624102.2760.1693.camel@edumazet-glaptop>
 <20120602125723.5b057570@pyramind.ukuu.org.uk> <1338640231.2760.1704.camel@edumazet-glaptop>
 <CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com>
 <CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
 <20120602211917.14275f12@pyramind.ukuu.org.uk> <CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Jun 2012 18:37:47 -0700
X-Google-Sender-Auth: GUL0J8zvApMDXupYjqEHhF2IWbI
Message-ID: <CA+55aFwPdYfu5p5EPqZLnzps0v0+MaL7=dr9cK71EqhAL-Hebg@mail.gmail.com>
Subject: Re: [PATCH] tty: add lockdep annotations
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 3:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. Ok. Looking at it, the ".shutdown" and ".remove" functions are
> all very limited, so I suspect we could just make the rule be that the
> install/lookup functions are serialized against each other by the
> pty_mutex (true today), and then we just add a small spinlock for the
> actual driver array insert/lookup.

Actually, I think we could probably make it really trivial by forcing
the free'ing of the tty itself to be RCU-delayed.

Then shutdown/remove would remove the entry with no locking
what-so-ever (which is really nice if you're in an interrupt - because
now *other* users don't need to use those annoying irq-safe versions),
and simply just clear the ttys[] array index.

The lookup side would need to just do a RCU read lock, read the
->ttys[index] thing using ACCESS_ONCE, and then just do the
atomic_inc_not_zero() dance I already did to validate that the thing
is still alive.

Voila - very cheap locking, and the part that could possibly happen
from interrupts (shutdown/remove) needs no locking at all.

Making the tty freeing be rcu-delayed sounds pretty dang simple too.

What do you think?

Anyway, I'm closing the merge window now (doing the tagging, booting
and checking that allmodconfig/allyesconfig/allnoconfigs all compile
fine) so it's 3.6 material, but it doesn't sound bad.

                Linus
