Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0JGUSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:18:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50391 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0JGUSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:18:16 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date: Fri, 8 Oct 2010 01:47:56 +0530
Subject: RE: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Topic: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Index: ActmW4p5ZZQsXZvfRQ217yh+uxNqYgAACuWg
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D248@dbde02.ent.ti.com>
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
 <20101007213503.657bcab0@lxorguk.ukuu.org.uk>
In-Reply-To: <20101007213503.657bcab0@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Thursday, October 07, 2010 3:35 PM
> To: Savoy, Pavan
> Cc: Jiri Slaby; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-bluetooth@vger.kernel.org
> Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
> 
> > ldisc is the ONLY way to do it, isn't it? Do I have any other option?
> 
> Userspace but even then it wouldn't solve your problem
> 
> > The situation was something similar here.
> > What I was trying to get to is how we can have a per-device context if a
> driver is just a line discipline driver?
> 
> tty->driver_data
> 		TTY private data
> tty->disc_data
> 		LDISC per instance private data
> 
> So when your ldisc is opened attach your data to the tty->disc_data, and
> when it is closed free the data.

But, I want to attach my data not when ldsic is opened, but when ldisc is registered.
I want to begin accessing the data when ldisc is opened.

> > I have 3 sub-devices if you will on a device which is interfaced over UART,
> > One of them is Bluetooth which requires any UART Bluetooth device to have
> its
> > Own line discipline - N_HCI.
> 
> The problem is that your chip by the sound of it does not talk the
> bluetooth ldisc - it talks something more complex.
> 
> The obvious question then is
> 
> Does it talk
> 
> 1.	HCI with bits nailed on
> 2.	Something rather different which contains muxed data some of
> which is reformatted up to create HCI
> 
> In the first case it may be worth seeing if the existing N_HCI could
> support forwarding unknown frame types to a helper. In the latter it's a
> lot trickier. It is possible to create a mux tty layer (see n_gsm.c) but
> that is almost certainly overkill for this.
> 
> I wonder what Marcel thinks in terms of re-using the bluetooth ldisc ?

Yes, Marcel did suggest extending N_HCI, But even then, there need
to be like a bunch of helpers (1 for FM, 1 for GPS, 1 for NFC, 1 for power-management), also the problem of who owns the /dev/tty begins to occur, Bluetooth has a utility called hciattach, I don't want my FM radio software to run hciattach when /dev/radio0 is opened and communicated via FM.

In any case, the ti-st/ seems better now by look of things, I certainly welcome suggestions to improve it.
Also, is there any plan to re-write whole of TTY like a the i2C or the SPI bus structure?

Here I can imagine, all TTY line disciplines being sort of protocol/client drivers, the TTY sub-system in itself would be like the algos driver and then
The uart drivers (like 8250.c) can be the adapter drivers.. What say?

With something like this all I had to do was to write a new client driver.


