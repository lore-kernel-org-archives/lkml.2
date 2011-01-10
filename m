Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1AJNQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:16:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52401 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753720Ab1AJNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:16:24 -0500
Date: Mon, 10 Jan 2011 13:13:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] char nvtty: Network Virtual Terminal support
Message-ID: <20110110131332.622e8a0d@lxorguk.ukuu.org.uk>
In-Reply-To: <1294664819-17960-2-git-send-email-giometti@linux.it>
References: <1294664819-17960-1-git-send-email-giometti@linux.it>
	<1294664819-17960-2-git-send-email-giometti@linux.it>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By using these devices and a proper compatible server (not included
> here but you can use sredird) you can get access to a remote tty
> device as the tty device itself was conneted with your local host.
> All data and settings are sent and received through the network.

And this is still something that should be done in userspace if necessary
by fixing up the tty layer to support pty/tty pair modem lines and
termios change reporting, or some kind of *generic* vt that can also
expose all the config other net protocols might need.

> +	default:
> +		tty->termios->c_cflag = B0;

This btw is wrong - if you don't recognize the baud rate you want to
force a new one. Also you shouldn't be writing all of c_cflag here just
the baud bits, also you shouldn't in fact ever be hand mangling the baud
bits but using the helpers.


> +	}
> +}
> +#undef TEST_SET_BAUDRATE
> +
> +#define TEST_SET_DATASIZE(b)	case b: tty->termios->c_cflag |= CS ## b ; break
> +static void nvtty_set_datasize(struct nvtty_serial *info, unsigned int datasize)
> +{
> +	struct tty_struct *tty = info->tty;
> +
> +	nvtty_dbg(info, "datasize=%d", datasize);
> +
> +	tty->termios->c_cflag &= ~CSIZE;
> +	switch (datasize) {
> +	TEST_SET_DATASIZE(5);
> +	TEST_SET_DATASIZE(6);
> +	TEST_SET_DATASIZE(7);
> +	TEST_SET_DATASIZE(8);
> +	default:
> +		tty->termios->c_cflag = CS5;

Should be |=
>

> +static void nvtty_set_parity(struct nvtty_serial *info, unsigned int parity)
> +{
> +	struct tty_struct *tty = info->tty;
> +
> +	nvtty_dbg(info, "parity=%d", parity);
> +
> +	tty->termios->c_cflag &= ~(PARENB | PARODD);

Needs to consider the CMSPAR bit.

Otherwise its a very nice implementation of something I don't think we
should have implemented in the kernel.
