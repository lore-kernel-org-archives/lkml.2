Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2IGHTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:19:40 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:12238 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab2IGHTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:19:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAByfSVBtgnW5/2dsb2JhbABFhge1SoEIgiABAQUjBC8jEAsYAgImAgIUJQQgLod5B6hmky2BIYlwhR8yYAOVWZAdgmU
Date: Fri, 7 Sep 2012 09:19:34 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] can: rename LED trigger name on netdev renames
Message-ID: <20120907071934.GB37685@macbook.local>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
References: <20120904071128.GB416@vandijck-laurijssen.be>
 <1346750951-10451-1-git-send-email-kurt.van.dijck@eia.be>
 <20120906185938.GA4043@gmail.com>
 <5048F9FB.9020207@hartkopp.net>
 <20120906204559.GB4043@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120906204559.GB4043@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:46:00PM +0200, Fabio Baltieri wrote:
> On Thu, Sep 06, 2012 at 09:31:07PM +0200, Oliver Hartkopp wrote:
> > >> +
> > >> +/*
> > >> + * NETDEV rename notifier to rename the associated led triggers too
> > >> + */
> > >> +static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
> > >> +			void *data)
> > >> +{
> > >> +	struct net_device *netdev = (struct net_device *)data;
> > >> +	struct can_priv *priv = netdev_priv(netdev);
> > > 
> > > That's the main problem, which I also got stuck into when I did my first
> > > can-led implementation.  As LED structures are in netdev's private data,
> > > you can only use it if your driver is based on the can-dev API, and
> > > there are no way to be sure of that if you get outside driver's code
> > > itself.
> > > 
> > > This would give problems with vcan, slcan, and probabily other
> > > non-mainlined drivers.
> > 
> > 
> > Do you think, this is really a problem?
> > 
> > If a driver decides not to use the can-dev framework it has to implement own
> > solutions or just adopt can-dev.
> 
> Agreed, but this still means that we can't assume that
> netdev_priv(netdev) to a netdev where netdev->type == ARPHRD_CAN points
> to a struct can_priv, right?

It remains a problem for vcan & slcan.
I tend to start looking at how netlink deals with it.
I see 2 options:
* Invent a new flag for netdev->features, like NETIF_F_CANDEV, to be assigned
  at http://lxr.free-electrons.com/source/drivers/net/can/dev.c#L464

* test for the rtnl_link_ops:
  We put a function can_priv_safe(netdev) in driver/net/can/dev.c that tests
  netdev->rtnl_link_ops == &can_link_ops, like in
  http://lxr.free-electrons.com/source/drivers/net/can/dev.c#L751
  and for candev based drivers, it returns a can_priv*, otherwise NULL.
  I'll prepare something early next week ...

Kind regards,
Kurt
