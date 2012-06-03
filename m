Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2FCNCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:02:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42360 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2FCNCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:02:32 -0400
Date: Sun, 3 Jun 2012 14:06:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
Message-ID: <20120603140604.23b2a34b@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFwPdYfu5p5EPqZLnzps0v0+MaL7=dr9cK71EqhAL-Hebg@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com>
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
	<20120602211917.14275f12@pyramind.ukuu.org.uk>
	<CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
	<CA+55aFwPdYfu5p5EPqZLnzps0v0+MaL7=dr9cK71EqhAL-Hebg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, I think we could probably make it really trivial by forcing
> the free'ing of the tty itself to be RCU-delayed.

It doesn't solve the problem of the synchronization between ->ttys[] and
->termios[]. Thats two objects, and the root of the problem. Given the
size of struct ktermios it appears to be a win anyway to put it in the
tty.

At that point tty_release can do what it should do.

> What do you think?

Second complication is some ttys have their own private ->shutdown.

It's possibly a useful optimisation and way of doing it *once* the
termios tidy is done, but I think once that is done then ->shutdown goes
away or becomes an non IRQ path event in tty_release.

> Anyway, I'm closing the merge window now (doing the tagging, booting
> and checking that allmodconfig/allyesconfig/allnoconfigs all compile
> fine) so it's 3.6 material, but it doesn't sound bad.

I've been gradually putting in places the bits leading up to the tty_lock
fix. I hadn't realised that one needed to be ahead or was exposing the
termios/tty array race.

I'll just go back and put the termios stuff further ahead and get that
chunk right first. After that tty locking, and then we can worry about
the real nasty which is that if we fix the open/close paths for console
devices to be secure Fedora breaks because their userspace appears to be
completely broken in this area.

Alan
