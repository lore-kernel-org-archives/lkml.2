Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2FBUP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:15:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41909 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761Ab2FBUP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:15:57 -0400
Date: Sat, 2 Jun 2012 21:19:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
Message-ID: <20120602211917.14275f12@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com>
	<1338402812.2760.413.camel@edumazet-glaptop>
	<4FC66D3D.6080509@fusionio.com>
	<1338404902.2760.451.camel@edumazet-glaptop>
	<1338410107.2760.544.camel@edumazet-glaptop>
	<1338456918.2760.1318.camel@edumazet-glaptop>
	<1338574627.2760.1545.camel@edumazet-glaptop>
	<CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	<1338583498.2760.1648.camel@edumazet-glaptop>
	<20120601215620.305155c0@pyramind.ukuu.org.uk>
	<1338584389.2760.1653.camel@edumazet-glaptop>
	<1338621438.2760.1679.camel@edumazet-glaptop>
	<1338623708.2760.1691.camel@edumazet-glaptop>
	<1338624102.2760.1693.camel@edumazet-glaptop>
	<20120602125723.5b057570@pyramind.ukuu.org.uk>
	<1338640231.2760.1704.camel@edumazet-glaptop>
	<CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com>
	<CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I *think* this makes sense. But it has has had absolutely zero
> testing. It compiles in my config, and the locking is at least
> sensible and well-localized, but maybe I'm missing something.
> 
> Comments?

Yep. Been that way 8)

tty_driver_remove_tty is called from tty_shutdown is called from the
final tty_kref_put can be called from IRQ context.

If you move the tty_driver_remove_tty into the queued part of the code
path then driver->termios[] races appear between the destructor and the
next allocation of the same tty.

Really tty_driver_remove_tty should occur at the end of tty_release, and
tty->termios should simply be a struct ktermios (its a fairly small
structure) and copied back to the drivers array on drivers that need it.
That cleans up pty as well.

Alan
