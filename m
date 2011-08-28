Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1H1OKC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 10:10:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38997 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1H1OJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 10:09:56 -0400
Subject: Re: [PATCH net-next ] Fix time-lag of IFF_RUNNING flag consistency
 between vlan and real devices
From: Eric Dumazet <eric.dumazet@gmail.com>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Micha=C5=82Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, Jesse Gross <jesse@nicira.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E5A40A9.2000404@hitachi.com>
References: <20110826060257.5304.62723.stgit@ltc219.sdl.hitachi.co.jp>
	 <20110825230859.11b2b132@nehalam.ftrdhcpuser.net>
	 <20110826064553.GA5874@gondor.apana.org.au>  <4E5A40A9.2000404@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Aug 2011 16:09:49 +0200
Message-ID: <1314540589.3036.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 28 août 2011 à 22:20 +0900, HAYASAKA Mitsuo a écrit :
> Hi Stephen and Herbert
> 
> Thank you for your comments.
> 
> (2011/08/26 15:08), Stephen Hemminger wrote:
> > I don't think this is the right way to solve the problem.
> >
> > The flags are supposed to propagate back from real device to vlan
> > via network notifications.
> >
> > Just doing this for ioctl is not enough, API's other than user space depend on this.
> > Also the user may have manually set different flags on vlan than on
> > the real device.
> 
> I agreed.
> I will try another way to solve this problem, as you said.
> 
> 
> (2011/08/26 15:45), Herbert Xu wrote:
> > On Thu, Aug 25, 2011 at 11:08:59PM -0700, Stephen Hemminger wrote:
> >> Just doing this for ioctl is not enough, API's other than user space depend on this.
> >> Also the user may have manually set different flags on vlan than on
> >> the real device.
> > Right, anything that tests netif_carrier_ok directly on the VLAN
> > device will still be delayed.
> >
> > Now I remember discussing this issue in Japan.  However, I can't
> > recall the exact scenario in which the delay occured.
> >
> > Is the issue with the link status going down on the real device,
> > or the real device coming up?
> >
> > IIRC we already have mechanisms in place to ensure that down events
> > are not delayed by linkwatch.  Of course it is possible that this
> > isn't working for some reason, or some other part of the system is
> > causing the delay.
> >
> > So please clarify the scenario for us Hayasaka-san.  Also please
> > let us know how you measured the delay.
> >
> > Thanks,
> 
> This issue happens when the link status is going down on the real 
> device.
> 
> ex) A cable is broken, or is unplugged from a NIC.
> 
> I measured the delay using ioctl with SIOCGIFFLAGS from userspace 
> in order to check if there is a time-lag of the flag between vlan 
> and real devices.
> 
> Also, you can check it using a script below.
> 
> -------------------------
> #!/bin/sh
> t=0
> while :
> do
> 	echo $t; t=$((t+1))
> 	echo -n real; ifconfig RealDev | grep UP
> 	echo -n vlan; ifconfig VlanDev | grep UP
> 	sleep 0.2
> done
> -------------------------
> 
> The result is shown as follows.
> It is observed that there is a time-lag of RUNNING status between 
> real and vlan devices.
> 
> 

Hi !

This reminds me some work done in linkwatch

Please take a look at commit e014debecd3ee3832e647 (linkwatch:
linkwatch_forget_dev() to speedup device dismantle)

And more generally, code in net/core/link_watch.c




