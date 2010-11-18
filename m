Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab0KRSPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:15:11 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:38584
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758308Ab0KRSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:15:09 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzz8275bhz2dh2a8h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Date: Thu, 18 Nov 2010 12:13:56 -0600
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur@freescale.com>
CC: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118121356.3491da72@udp111988uds.am.freescale.net>
In-Reply-To: <4CE5657D.8060105@freescale.com>
References: <4CE44B1B.9040709@freescale.com>
	<20101117215147.GA26792@suse.de>
	<4CE452CD.3050001@freescale.com>
	<20101117221903.GA4066@suse.de>
	<4CE45A4E.70308@freescale.com>
	<20101118022434.GA9833@suse.de>
	<4CE546C5.8060401@freescale.com>
	<20101118153912.GA1443@suse.de>
	<4CE54E40.9040503@freescale.com>
	<20101118112146.3275eb08@udp111988uds.am.freescale.net>
	<4CE5657D.8060105@freescale.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 18:15:00.0701 (UTC) FILETIME=[83B320D0:01CB874C]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 11:42:21 -0600
Timur Tabi <timur@freescale.com> wrote:

> Scott Wood wrote:
> 
> > The tty driver doesn't register the bus, but rather a driver for
> > some type of device on that bus.  The code to create the bus goes
> > elsewhere, and would not be specific to byte channels.
> 
> Which code to create the bus?  Are you saying that the driver should call
> bus_register()?

No, the bus code calls that (probably drivers/base/platform.c in this
case).

> >> Also, this is an Open Firmware driver.  I already have a mechanism whereby I get
> >> probed for each instance of a byte channel.  Isn't that my "bus"?
> > 
> > It would be if you actually had it -- but it looks like you just loop
> > over the nodes.
> 
> Well, ok, but I can change that.  If I drop the normal character driver
> registration and register the byte channels only as tty devices, then I can make
> it probe-able.

OK.

> > We should add a proper bus for the "handles" node.  Then sysfs should
> > show the link between the tty device and a device tree node -- which is
> > really what we're after, the handle is just a means to that end.
> 
> How exactly do I do that?

Pass the platform device pointer to tty_register_device.

Then, in the sysfs node, "driver" should be a symlink to
another sysfs node whose path looks lind of like an OF path.

Unfortunately, it's not an exact match, and the fact that reg doesn't
translate to a physical address means that AFAICT you'll currently get
something like "byte-channel.nnn", where "nnn" is an arbitrary
kernel-assigned number.

It would be nice if platform devices that are created from device tree
nodes included a link to the corresponding /proc/device-tree node in
their sysfs node.

Other than that, I guess you could add hv handle support to
of_device_make_bus_id.

-Scott

