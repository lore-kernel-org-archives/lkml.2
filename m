Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0FSVyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 17:54:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868Ab0FSVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 17:54:04 -0400
Date: Sat, 19 Jun 2010 22:57:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
Message-ID: <20100619225706.340eda52@lxorguk.ukuu.org.uk>
In-Reply-To: <201006192229.21971.arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com>
	<201006191432.04685.arnd@arndb.de>
	<201006192229.21971.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> I could reproduce the problem now and bisected it down to a cleanup
> patch that can fortunately get reverted. The symptom that I saw
> is that when I open a serial port for the second time (e.g. starting
> getty and logging in), the output gets garbled, while the first one
> worked fine. This does not rely on the console code at all.

So the init code isn't getting run somewhere for some reason. Almost
certainly a count bug.

> Alan, any idea where the problem may be with the broken patch?

I'll take a look. We really don't want to revert this as it fixes some
nasty things the BKL covers over so I'd be worried the races would become
exposed (and it possibly allows NULL->func() calls if it can which would
be bad)

First guess would be something in port->count going astray and the port
not getting re-initialised.

Important question - does it need a getty or will a simple cat < /dev/foo
twice get garbled (or cat > if its garbling the other way)

Which direction matters and whether a hangup is needed matters
