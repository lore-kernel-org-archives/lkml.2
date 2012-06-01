Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab2FAUxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:53:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41150 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2FAUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:53:06 -0400
Date: Fri, 1 Jun 2012 21:56:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
Message-ID: <20120601215620.305155c0@pyramind.ukuu.org.uk>
In-Reply-To: <1338583498.2760.1648.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	<1338402812.2760.413.camel@edumazet-glaptop>
	<4FC66D3D.6080509@fusionio.com>
	<1338404902.2760.451.camel@edumazet-glaptop>
	<1338410107.2760.544.camel@edumazet-glaptop>
	<1338456918.2760.1318.camel@edumazet-glaptop>
	<1338574627.2760.1545.camel@edumazet-glaptop>
	<CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	<1338583498.2760.1648.camel@edumazet-glaptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, tty->driver deref is ok (tty points to valid memory), but crash is
> on tty->driver->ops (driver points to freed/illegal memory)
> 
> using slub_debug=FZPU, I can indeed see RDI=6b6b6b6b6b6b6b6b

driver and driver->ops is basically const and it's not what you'd expect
from a tty refcount bug. The driver side puts shouldn't have changed but
I'll take a look over that patch and the error paths closely again just
in case.

It could be that tty->driver is pointing at a valid but bogus location
but again its not something I'd expect.

> By the way, release_one_tty() uses the following racy code :
> 
> tty_driver_kref_put(driver);
> module_put(driver->owner);
> 
> I would use following patch to make sure bad things cant happen...

Agreed. Although we wouldn't be unloading console or pty so it's alas not
the real cause.


Alan
