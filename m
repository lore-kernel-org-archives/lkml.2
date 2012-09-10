Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2IJTNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:13:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab2IJTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:13:52 -0400
Date: Mon, 10 Sep 2012 20:18:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 06/14] tty/serial/core: Introduce poll_init callback
Message-ID: <20120910201810.409a58ea@pyramind.ukuu.org.uk>
In-Reply-To: <20120910175725.GA13673@lizard>
References: <20120910040802.GA1261@lizard>
	<20120910041335.GF29537@lizard>
	<20120910121320.03c9dfc7@pyramind.ukuu.org.uk>
	<20120910175725.GA13673@lizard>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What stops a parallel open or close changing ASYNC_INITIALIZED after you
> > test and before you lock ?
> 
> Yeah, I should do the whole thing under the mutex.

Can you use test_bit() as well. I'm trying to gradually push all the code
that way so people habitually use set_bit() and we don't get any (more)
races where some compile situations and architectures otherwise create

	load to register
	register ored with constant
	write back

> Not related to this particular issue, but the fact that close() can powerdown
> the hardware is quite bad. Today it is always possible to use open,close
> sequence on /dev/ttyXXXX, and polling would break if close() deinitializes the
> hardware (e.g. via uart_change_pm()).

One of the long term goals of tty_port has always ben to have an object
with the lifetime of the physical port so this kind of thing can be fixed.

> In console= case, serial core handles the issue via uart_console(), checking if
> the port is used for console, preventing it to power down the hardware. We can
> do the same, or make tty_find_polling_driver() refcount individual ports/lines.
> But the issue is orthogonal to this particular patch, although needs to be
> fixed some day.

Agreed - however you'll need a separate refcount than the main tty one
for this, because we still need to do a hangup() on the final "tty" close
even if the hardware is 'pinned' for a debugger.

Alan
