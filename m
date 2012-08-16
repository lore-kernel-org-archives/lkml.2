Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab2HPU2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:28:43 -0400
Received: from incomingmail.riverbed.com ([208.70.196.45]:64888 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2HPU2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:28:41 -0400
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Michael Chan <mchan@broadcom.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>
Subject: RE: [PATCH] bnx2: turn off the network statck during initialization
Thread-Topic: [PATCH] bnx2: turn off the network statck during initialization
Thread-Index: AQHNe9wN/GY2GzvEwk20Q1fuXq+2eJddP4KA//+NcgCAAHtYAP//kWDw
Date: Thu, 16 Aug 2012 20:28:36 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA834DB2B40@SFO1EXC-MBXP06.nbttech.com>
References: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
 <1345143431.6916.36.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2ABC@SFO1EXC-MBXP06.nbttech.com>
 <1345145318.6916.42.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
In-Reply-To: <1345145318.6916.42.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.249]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I see what you mean. In fact, I am working on an old RHEL based kernel and it still reports the link via ethtool_op_get_link. That is why I got the inconsistent report from the ethtool as I described in the patch. (the ethtool showed the link is up, but speed is unknown, duplex is half).

I guess I can just port in the patch for bnx2_get_link() to solve this problem.

Also, I have another comment related to link state.

Right now, the bnx2 driver powers up the device in bnx2_init_board(), regardless the netif_carrier is on or off. This may introduce following inconsistent behaviors:
1) suppose the cable is plugged in to the NIC and the other end is connected to a switch
2) user powers up the box
3) the Linux does not bring up the interface; i.e, ifconfig ethx shows it is down
4) ethtool ethx will show no link
5) if the user goes to check the light on the physical NIC, he will see the green link light is ON. That means the link is up, right? 

I think it is better to power down the device until bnx2_open is called. In this way, ethtool report and the physical link light will be consistent. 

Any suggestions? Thanks.

Regards,

Jiang

-----Original Message-----
From: Michael Chan [mailto:mchan@broadcom.com] 
Sent: Thursday, August 16, 2012 12:29 PM
To: Jiang Wang
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Chaitanya Lala; Francis St. Amant
Subject: RE: [PATCH] bnx2: turn off the network statck during initialization

On Thu, 2012-08-16 at 19:15 +0000, Jiang Wang wrote: 
> Hi Michael,
> 
> I just checked the code for netif_carrier_off(), and it will return if 
> the dev is not initialized (registered) as follows:
> 
> void netif_carrier_off(struct net_device *dev) {
>         if (!test_and_set_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
>                 if (dev->reg_state == NETREG_UNINITIALIZED)
>                         return;
>                 linkwatch_fire_event(dev);
>         }
> }
> 
> So linkwatch_fire_event should not fire in this case, right? Thanks 
> for the quick response.
> 
Yes, you're right.  Your patch should not cause any problem then.

But I still don't understand what problem you're trying to solve.  The link status from ethtool is determined by bnx2_get_link() and it should always return link down before bnx2_open() is called.  Can you please elborate?  Thanks.

> Regards,
> 
> Jiang
> 
> -------------------------------------
> Jiang Wang
> Member of Technical Staff
> Riverbed Technology
> Tel: (408) 522-5109
> Email: Jiang.Wang@riverbed.com
> www.riverbed.com
> 
> 
> -----Original Message-----
> From: Michael Chan [mailto:mchan@broadcom.com]
> Sent: Thursday, August 16, 2012 11:57 AM
> To: Jiang Wang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Chaitanya 
> Lala; Francis St. Amant; Jiang Wang
> Subject: Re: [PATCH] bnx2: turn off the network statck during 
> initialization
> 
> On Thu, 2012-08-16 at 11:21 -0700, Jiang Wang wrote: 
> > The initialization state of bnx2 driver is wrong. It does not turn 
> > of the Linux network stack using netif_carrier_off. This may lead to 
> > inconsistent report from ethtool as the link is up but speed is 
> > unknown when the cable is not plugged in.
> > 
> > E.g.
> >         Speed: Unknown! (0)<--------------------------------------
> >         Duplex: Half       <--------------------------------------
> >         MDI: Unknown! (0)
> >         Port: Twisted Pair
> >         PHYAD: 1
> >         Transceiver: internal
> >         Auto-negotiation: on
> >         Supports Wake-on: g
> >         Wake-on: d
> >         Link detected: yes <---------------------------------------
> > 
> > This patches fixed the problem by turning off the network stack 
> > during initialization.
> > 
> > Signed-off-by: Jiang Wang <jwang@riverbed.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnx2.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnx2.c
> > b/drivers/net/ethernet/broadcom/bnx2.c
> > index ac7b744..ce4548d 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2.c
> > +++ b/drivers/net/ethernet/broadcom/bnx2.c
> > @@ -8463,6 +8463,10 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	dev->features |= dev->hw_features;
> >  	dev->priv_flags |= IFF_UNICAST_FLT;
> >  
> > +	/* tell the stack to leave us alone until bnx2_open() is called */
> > +	netif_carrier_off(dev);
> 
> We have tried this before and this didn't work.  netif_carrier_off() 
> calls linkwatch_fire_event() to schedule the event.  If
> register_netdev() fails for whatever reason, the netdev will be freed but the link_watch event may still be scheduled.
> 
> Calling netif_carrier_off() after register_netdev() returns successfully also may not work as it will race with bnx2_open() which enables IRQ.
> An linkup IRQ can happen at time and we may end up with the wrong carrier state because of the race condition.
> 
> > +	netif_stop_queue(dev);
> > +
> >  	if ((rc = register_netdev(dev))) {
> >  		dev_err(&pdev->dev, "Cannot register net device\n");
> >  		goto error;
> 
> 
> 
> 



