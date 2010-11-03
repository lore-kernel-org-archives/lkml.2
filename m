Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0KCKfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:35:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39870 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753914Ab0KCKfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:35:50 -0400
Date: Wed, 3 Nov 2010 10:34:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eli Billauer <eli@billauer.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Message-ID: <20101103103458.2f0bac8c@lxorguk.ukuu.org.uk>
In-Reply-To: <201011030432.15393.arnd@arndb.de>
References: <4CCBCD8E.1020601@billauer.co.il>
	<201011012039.16312.arnd@arndb.de>
	<4CD0A988.4070204@billauer.co.il>
	<201011030432.15393.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I hope Alan can figure out if it's either safe to drop both here, or if we
> might be able to call uart_close without tty_lock() held in the first place.

That was always my intention and why I moved it to tty_port. I think it
is safe to do that, but as far as I can tell the port mutex is assumed
held by the low level drivers during the uart ops calls some of the time.

Safest is probably to drop the tty lock before we take the port mutex and
take it again when we exit.

The tty_port fields are protected by the port mutex/lock

The uport methods by the uport lock

The only two points of concern I see are updating of closing_wait as it
is read (no big deal), and the nasty - which is tty_ldisc_flush. I am not
sure what assumptions lurk in the ldisc flush paths but I think it's ok.

uart_wait_until_sent will also need to not take the tty lock at that
point to fix it properly.
