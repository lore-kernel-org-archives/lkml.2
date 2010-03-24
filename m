Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0CXRQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:16:05 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33235 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0CXRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:16:00 -0400
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Greg KH <gregkh@suse.de>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <132027.10140.qm@web94905.mail.in2.yahoo.com>
References: <132027.10140.qm@web94905.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 10:15:50 -0700
Message-ID: <1269450950.11714.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

> > > > > I wanted to somehow put this in staging
> > because then
> > > > it would probably have a thorough architectural
> > review
> > > > process.
> > > > > Some details about this driver - 
> > > > > 
> > > > > 1. This driver will be used by
> > Bluetooth-BlueZ/FM-V4L2
> > > > and GPS (probably character device driver) using
> > the
> > > > EXPORTED symbols (-register/_unregister).
> > > > > 
> > > > > 2. Much like the hciattach daemon which
> > maintains
> > > > N_HCI bluetooth line discipline, this driver will
> > also have
> > > > a User-Space  N_TI_WL Init manager (UIM)
> > maintaining
> > > > the Line discipline.
> > > > 
> > > > can you explain why you think this is needed and
> > we can not
> > > > interface
> > > > this directly. If it is a serial port, what
> > protocol does
> > > > it talk?
> > > 
> > > Illustration: The BT driver on top of this ST driver,
> > would create a hci0 interface, when someone does an DEVUP on
> > that interface, the BT driver would then do a st-register -
> > which in-turn would ask the hciattach-like daemon to install
> > the line discipline for it via the sysfs entry.
> > > The same concept goes for FM-V4L2 and GPS character
> > driver.
> > > 
> > > The core of the problem is we cannot
> > ask/install/ldisc_put for a line discipline from kernel
> > space.
> > 
> > so let us get the facts straight here. The device in
> > question is using a
> > serial port to connect to the host and then multiplexing
> > BT, FM and GPS
> > over it. My question again, what protocol does it talk.
> 
> Ok, On TTY/4-wire UART, BT talks standard HCI, and HCI-LL for power management as in hci_ll.c/hciattach_ti.c which is already upstream.
> 
> And in a very similar way, FM talks over what is known as "channel 8" and GPS over "channel 9", Although these are not standard.
> 
> So, basically data going/coming to/out of chip is 
> 1,2,3,4 - HCI 
> 30,31,32,33 for HCI-LL
> 8 - FM
> 9 - GPS.
> 
> So consider this an extension of hci_ll/hci_ldisc but only more features to accomodate the FM and GPS.

So why are we not making the hci_ll into a generic driver that can
register besides Bluetooth also FM and GPS.

Then we can attach that driver to the TTY via line discipline on boot
and let the LL part handle the power management.

Registration of Bluetooth device, FM and GPS nodes are done via RFKILL
that the LL driver exports.

> > Also why not just install the line discipline and then
> > control the
> > subdevices via RFKILL?
> 
> The chip side PM would be fine, and is being done so, st_kim.c creates the rfkill entries, and controls them locally, also allows applications to control them.
> But ldisc can't be install upon boot, because UART clks would be used up for no reason at all.
> (say on a mobile phone, how many times in a day - do we actually use BT/FM or GPS - so UART needs to be most often idle, and ldisc should be installed only upon requirement)

I think the driver should make sure it doesn't use the UART clocks if in
deep sleep. This has nothing to do with installing the line discipline
on boot via a userspace tool.

You do the power management for the hci_ll driver already today. So why
can't we do the same in this driver?

Another way to view this is that the LL driver has to create a virtual
bus for Bluetooth, FM and GPS devices. However RFKILL might be a bit
more suitable and simpler.

Regards

Marcel


