Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1A0VHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:07:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59928 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752564Ab1A0VHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:07:22 -0500
Date: Thu, 27 Jan 2011 21:07:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
Message-ID: <20110127210729.79eef2c1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110127204354.GB1597@n2100.arm.linux.org.uk>
References: <201101111744.59712.jeremy.kerr@canonical.com>
	<20110111103929.GN24920@pengutronix.de>
	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
	<4D386ABF.9060908@fluff.org>
	<20110120190822.GK6335@n2100.arm.linux.org.uk>
	<4D3932B4.8010904@codeaurora.org>
	<20110121094042.GD13235@n2100.arm.linux.org.uk>
	<4D40F5CC.6080809@codeaurora.org>
	<20110127085438.GA25239@n2100.arm.linux.org.uk>
	<4D41D5EC.6030405@codeaurora.org>
	<20110127204354.GB1597@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For internal tree purposes, does .set_termios need to be atomic? Can it  
> > grab mutexes instead of spinlock?
> 
> I think I already answered that question above where I said "protect
> against the interrupt handler accessing the port->* stuff".

I'm not sure you answered it correctly however as the locking nowdays is
a bit different.

Architecturally the termios handling doesn't need a spin lock nor is it
called under one. In fact it's vital this is the case because of USB.

I see nothing in the 2.6.37 cpm_uart code that isn't trivially fixable.
There is already a mutex protecting termios serialization so all you seem
to need to do is call clk_set_rate after rather than before dropping the
lock surely ?

Oh if you are looking at the cpm_uart code and care about it the following
in the code isn't safe as tty could possibly go NULL and be freed under
you.

     struct tty_struct *tty = port->state->port.tty;

and you ought to be doing

	tty = tty_port_tty_get(&port->state->port);

	if (tty)
		blah;
	tty_kref_put(tty);	/* put NULL is a no-op anyway */


probably in the main irq handler and pass tty to the helpers that need it.


Alan
