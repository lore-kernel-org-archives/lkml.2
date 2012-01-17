Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2AQOiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:38:07 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:41718 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab2AQOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:38:05 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 09:38:04 EST
From: Tim Sander <tstone@iss.tu-darmstadt.de>
Organization: Integrierte Schaltungen und Systeme
To: Tim Sander <tim.sander@hbm.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet driver to blame?
Date: Tue, 17 Jan 2012 15:27:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Clark Williams" <williams@redhat.com>,
        "John Kacur" <jkacur@redhat.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <201201121757.25467.tim.sander@hbm.com> <201201131042.08323.tim.sander@hbm.com>
In-Reply-To: <201201131042.08323.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171527.19165.tstone@iss.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.1.17.141515
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have further input to the ksoftirq/0 using as much cpu as available on a
arm i.mx pcm043 platform without load with a 3.0.14-rt31 kernel and some local 
platform adaptions.

> I was thinking about this ksoftirq0 running on max cpu. The context:
> > > > and the running wild ksoftirqd0 most probably after the kernel
> > > > message: "sched: RT throttling activated"
I think that the message  "sched: RT throttling activated" and the ksoftirqd 
running on full cpu are possibly to seperate errors. Btw. is there a way to 
find out which processes where conuming this timeframe. It would be nice to add 
info output which processes caused the throtteling. Is it possible to get this 
information out of the scheduler structure?

> > > Hmm, that's not good. It means that an RT task is spinning too much.
> > 
> > Mh, sorry i was to terse on that. This only happens after first boot on
> > UBIFS update, but it shows that somehow there seems to be a corner case
> > when throtteling is activated. Since this seems to be the reason for
> > ksoftirq0 running as much cpu as it gets. I just patched out switch to rt
> > throtteling and i will ask the mtd guys about the work they presumably do
> > in interrupt context which causes this throtteling in the first place.
Ok, by taking a detour to the UBI stuff i an now convinced that the UBI 
subsystem seems not to be the culprit, of this throtteling message. Its just 
that right after UBI has been attached the network setting is restored after a 
firmware update so it seems that this triggers the error.

I have been toying around with connman (connman.net) which manages network
connections on embedded devices and stopping this daemon which seems to do a 
"ifconfig eth0 down" when terminated. After doing a manual "ifconfig eth0 up" 
ksoftirq/0 uses as much cpu as it gets. Just doing a "ifconfig eth0 down && 
ifconfig eth0 up" does not create 100% cpu load, so somehow connman triggers 
this error pretty reliably. 

Also the dmesg output seems to point to the FEC ethernet driver as culprit for 
this throtteling message:
eth0: Freescale FEC PHY driver [Micrel KS8041] (mii_bus:phy_addr=1:00, irq=-1)
sched: RT throttling activated
PHY: 1:00 - Link is Up - 100/Full

Other output in dmesg right before the ksoftirq is running wild:
eth0: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth0: Freescale FEC PHY driver [Micrel KS8041] (mii_bus:phy_addr=1:00, irq=-1)
eth0: no IPv6 routers present
PHY: 1:00 - Link is Up - 100/Full
eth0: Freescale FEC PHY driver [Micrel KS8041] (mii_bus:phy_addr=1:00, irq=-1)
FEC: MDIO read timeout
PHY: 1:00 - Link is Up - 100/Full
eth0: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth0: Freescale FEC PHY driver [Micrel KS8041] (mii_bus:phy_addr=1:00, irq=-1)
FEC: MDIO read timeout
PHY: 1:00 - Link is Up - 100/Full

It seems as if the polling of the phy might be a interfering with the above 
problem so i'd like to test if the problems go away with a phy irq defined:. I 
have the interrupt line of the phy connected but somehow i got stuck in all 
these layers how to set
 phy_dev->irq = gpio_to_irq(IMX_GPIO_NR(2,7) 
in the board definition mach-pcm043.c. So there must be an example how to define 
the phy irq?

Best regards
Tim
