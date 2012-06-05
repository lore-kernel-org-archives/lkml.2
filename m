Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2FEXXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:23:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2FEXXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:23:44 -0400
Date: Wed, 6 Jun 2012 00:27:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tty_insert_flip_string_fixed_flag, unable to handle kernel
 NULL pointer dereference at 00000004
Message-ID: <20120606002725.5fc9ffe9@pyramind.ukuu.org.uk>
In-Reply-To: <43517e56ecce834d141078f1918eba15@visp.net.lb>
References: <43517e56ecce834d141078f1918eba15@visp.net.lb>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ 5350.556089]  [<c027adc4>] pty_write+0x2c/0x4c
> [ 5350.556089]  [<c0277a44>] n_tty_write+0x24e/0x2d6
> [ 5350.556089]  [<c0144a2b>] ? try_to_wake_up+0x18c/0x18c

Basically the other end hung up just as it went to write.

It's a known race. In the current codebase it's very hard to fix up nicely
as we have to drop tty_lock during a pty close or we deadlock. It's very
hard to hit but your environment sounds rather like my test case for it !

It's one of a series of related bugs (another in n_gsm) that we can't fix
elegantly until the tty locking is fixed - which has been pushed from 3.5
hopefully to 3.6 assuming we can fix a couple of other locking problems
first.

What may reduce it a lot is to change pty_write to do


	struct tty_struct *to = tty->link;

	if (tty->stopped)
		return 0;

	if (to == NULL)
		return -ENODEV;
	to = tty_kref_get(to);
	if (tty->link == NULL) {
		tty_kref_put(to);
		return -ENODEV;
	}
	if (c > 0) {
		...
	}
	tty_kref_put(to);
	return c;
}

Thats a pretty ugly bandaid but I'd be interested to know if it helps, as
that would verify the race you are hitting is the one I think it is.

Alan
