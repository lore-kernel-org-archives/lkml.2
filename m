Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965399Ab2FBSi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:38:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37485 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab2FBSi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <1338640231.2760.1704.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com> <1338402812.2760.413.camel@edumazet-glaptop>
 <4FC66D3D.6080509@fusionio.com> <1338404902.2760.451.camel@edumazet-glaptop>
 <1338410107.2760.544.camel@edumazet-glaptop> <1338456918.2760.1318.camel@edumazet-glaptop>
 <1338574627.2760.1545.camel@edumazet-glaptop> <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
 <1338583498.2760.1648.camel@edumazet-glaptop> <20120601215620.305155c0@pyramind.ukuu.org.uk>
 <1338584389.2760.1653.camel@edumazet-glaptop> <1338621438.2760.1679.camel@edumazet-glaptop>
 <1338623708.2760.1691.camel@edumazet-glaptop> <1338624102.2760.1693.camel@edumazet-glaptop>
 <20120602125723.5b057570@pyramind.ukuu.org.uk> <1338640231.2760.1704.camel@edumazet-glaptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Jun 2012 11:38:06 -0700
X-Google-Sender-Auth: 7ZGyBNi4z4pf7V9XRyD2WSy-na4
Message-ID: <CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com>
Subject: Re: [PATCH] tty: add lockdep annotations
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 5:30 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> With following debugging patch I now have crashes at every boot, so it
> might be more easy to find the bug :

I'm seeing *something* odd.

We call tty_shutdown() without holding the tty_mutex as far as I can
tell. Which means that we remove the tty from the tty lists with *no*
serialization with looking them up.

The fact that we lock the tty *after* we have found it is kind of
irrelevant. By then it's too late.

And I think this is the fundamental bug that was introduced in commit
d29f3ef39be4 ("tty_lock: Localise the lock"). We *used* to do
tty_lock() before the lookup - early in tty_open(). And we held it
until the very end of tty_release(), so the tty lock actually
protected the lookup of the tty.

That's simply not true any more. The comments for
tty_driver_remove_tty() say "Locking: tty_mutex for now", but that's
just garbage and wishful thinking. The callers don't actually hold
tty_mutex, and never have. Sure, some of them may do so (there's a lot
of potential callers through tty_kref_put()) but most of them
definitely don't. Look at tty_release(), most of the final refcounts
will be dropped after the mutex_unlock(&tty_mutex) afaik.

I'm pretty sure this is the bug. And there's no way we can make
'tty_mutex' protect every tty_kref_put(). So I think we have two
options:

 - revert all the tty locking changes

 - make a new global lock that protects just driver->ops->lookup(),
driver->ttys[idx], and driver->ops->remove()

Hmm?

         Linus
