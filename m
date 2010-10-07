Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0JGUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:09:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39014 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755139Ab0JGUJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:09:25 -0400
Date: Thu, 7 Oct 2010 21:35:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Message-ID: <20101007213503.657bcab0@lxorguk.ukuu.org.uk>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21D23B@dbde02.ent.ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
	<1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
	<4CACD234.7020900@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
	<4CACF5A7.3010601@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
	<4CAD7DAB.8030209@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
	<4CAE10C0.9000106@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21D220@dbde02.ent.ti.com>
	<20101007203801.1c55a1d3@lxorguk.ukuu.org.uk>
	<19F8576C6E063C45BE387C64729E739404AA21D23B@dbde02.ent.ti.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ldisc is the ONLY way to do it, isn't it? Do I have any other option?

Userspace but even then it wouldn't solve your problem

> The situation was something similar here.
> What I was trying to get to is how we can have a per-device context if a driver is just a line discipline driver?

tty->driver_data
		TTY private data
tty->disc_data
		LDISC per instance private data

So when your ldisc is opened attach your data to the tty->disc_data, and
when it is closed free the data.

> I have 3 sub-devices if you will on a device which is interfaced over UART,
> One of them is Bluetooth which requires any UART Bluetooth device to have its
> Own line discipline - N_HCI.

The problem is that your chip by the sound of it does not talk the
bluetooth ldisc - it talks something more complex.

The obvious question then is

Does it talk

1.	HCI with bits nailed on
2.	Something rather different which contains muxed data some of
which is reformatted up to create HCI

In the first case it may be worth seeing if the existing N_HCI could
support forwarding unknown frame types to a helper. In the latter it's a
lot trickier. It is possible to create a mux tty layer (see n_gsm.c) but
that is almost certainly overkill for this.

I wonder what Marcel thinks in terms of re-using the bluetooth ldisc ?

