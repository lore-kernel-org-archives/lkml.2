Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1H2GX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 02:23:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45424 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1H2GXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 02:23:14 -0400
Subject: Re: [PATCH net-next ] Fix time-lag of IFF_RUNNING flag consistency
 between vlan and real devices
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Micha=C5=82Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, Jesse Gross <jesse@nicira.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl pp-manager tt <yrl.pp-manager.tt@hitachi.com>,
        HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
In-Reply-To: <f6ded72b-346d-43af-af47-4edae5060406@tahiti.vyatta.com>
References: <f6ded72b-346d-43af-af47-4edae5060406@tahiti.vyatta.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 08:23:05 +0200
Message-ID: <1314598985.3036.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 28 août 2011 à 23:06 -0700, Stephen Hemminger a écrit :
> 
> ----- Original Message -----
> > Le dimanche 28 août 2011 à 22:20 +0900, HAYASAKA Mitsuo a écrit :
> > > Hi Stephen and Herbert
> > > 
> > > Thank you for your comments.
> > > 
> > > (2011/08/26 15:08), Stephen Hemminger wrote:
> > > > I don't think this is the right way to solve the problem.
> > > >
> > > > The flags are supposed to propagate back from real device to vlan
> > > > via network notifications.
> > > >
> > > > Just doing this for ioctl is not enough, API's other than user
> > > > space depend on this.
> > > > Also the user may have manually set different flags on vlan than
> > > > on
> > > > the real device.
> > > 
> > > I agreed.
> > > I will try another way to solve this problem, as you said.
> > > 
> > > 
> > > (2011/08/26 15:45), Herbert Xu wrote:
> > > > On Thu, Aug 25, 2011 at 11:08:59PM -0700, Stephen Hemminger
> > > > wrote:
> > > >> Just doing this for ioctl is not enough, API's other than user
> > > >> space depend on this.
> > > >> Also the user may have manually set different flags on vlan than
> > > >> on
> > > >> the real device.
> > > > Right, anything that tests netif_carrier_ok directly on the VLAN
> > > > device will still be delayed.
> > > >
> > > > Now I remember discussing this issue in Japan.  However, I can't
> > > > recall the exact scenario in which the delay occured.
> > > >
> > > > Is the issue with the link status going down on the real device,
> > > > or the real device coming up?
> > > >
> > > > IIRC we already have mechanisms in place to ensure that down
> > > > events
> > > > are not delayed by linkwatch.  Of course it is possible that this
> > > > isn't working for some reason, or some other part of the system
> > > > is
> > > > causing the delay.
> > > >
> > > > So please clarify the scenario for us Hayasaka-san.  Also please
> > > > let us know how you measured the delay.
> > > >
> > > > Thanks,
> > > 
> > > This issue happens when the link status is going down on the real
> > > device.
> > > 
> > > ex) A cable is broken, or is unplugged from a NIC.
> > > 
> > > I measured the delay using ioctl with SIOCGIFFLAGS from userspace
> > > in order to check if there is a time-lag of the flag between vlan
> > > and real devices.
> > > 
> > > Also, you can check it using a script below.
> > > 
> > > -------------------------
> > > #!/bin/sh
> > > t=0
> > > while :
> > > do
> > > 	echo $t; t=$((t+1))
> > > 	echo -n real; ifconfig RealDev | grep UP
> > > 	echo -n vlan; ifconfig VlanDev | grep UP
> > > 	sleep 0.2
> > > done
> > > -------------------------
> > > 
> > > The result is shown as follows.
> > > It is observed that there is a time-lag of RUNNING status between
> > > real and vlan devices.
> > > 
> > > 
> > 
> > Hi !
> > 
> > This reminds me some work done in linkwatch
> > 
> > Please take a look at commit e014debecd3ee3832e647 (linkwatch:
> > linkwatch_forget_dev() to speedup device dismantle)
> > 
> > And more generally, code in net/core/link_watch.c
> 
> Maybe the problem is specific to a ethernet driver. Some devices poll
> for link changes, and also do a manual check when ioctl was done.
> This was mostly typical of older hardware that did not have a PHY
> interrupt.

Hmm, I just tried the script on my laptop, and reproduced the problem
with a tg3 driver, considered as a reference one ;)

the 'carrier is on' event is immediately present on both devices, but
the 'carrier is off' is delayed by one second.

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M
Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Dell Device 01f9
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at f1ef0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: tg3
	Kernel modules: tg3


