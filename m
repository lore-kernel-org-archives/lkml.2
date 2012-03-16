Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031755Ab2CPNhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030751Ab2CPNhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:37:07 -0400
Date: Fri, 16 Mar 2012 09:38:03 -0400
From: Andy Gospodarek <gospo@redhat.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Weiping Pan <panweiping3@gmail.com>, Andy Gospodarek <andy@greyhouse.net>,
        "open list:BONDING DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net V3] bonding: send igmp report for its master
Message-ID: <20120316133803.GB12372@quad.redhat.com>
References: <20120314172237.GA12372@quad.redhat.com>
 <3072c40712c2f5506fc57937da921da0d3d83450.1331778582.git.panweiping3@gmail.com>
 <31016.1331869399@death.nxdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31016.1331869399@death.nxdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 08:43:19PM -0700, Jay Vosburgh wrote:
> Weiping Pan <panweiping3@gmail.com> wrote:
> 
> >Liang Zheng(lzheng@redhat.com) found that in the following topo,
> >bonding does not send igmp report when we trigger a fail-over of bonding.
> >
> >eth0--
> >      |-- bond0 -- br0
> >eth1--
> >
> >modprobe bonding mode=1 miimon=100 resend_igmp=10
> >ifconfig bond0 up
> >ifenslave bond0 eth0 eth1
> >
> >brctl addbr br0
> >ifconfig br0 192.168.100.2/24 up
> >brctl addif br0 bond0
> >
> >Add 192.168.100.2(br0) into a multicast group, like 224.10.10.10,
> >then trigger a fali-over in bonding.
> >You can see that parameter "resend_igmp" does not work.
> >
> >The reason is that when we add br0 into a multicast group,
> >it does not propagate multicast knowledge down to its ports.
> >
> >If we choose to propagate multicast knowledge down to all ports for bridge,
> >then we have to track every change that is done to bridge, and keep a backup
> >for all ports. It is hard to track, I think.
> >
> >Instead I choose to modify bonding to send igmp report for its master.
> >
> >Changelog:
> >V2: correct comments
> >V3: move this check into bond_resend_igmp_join_requests()
> >
> >Signed-off-by: Weiping Pan <panweiping3@gmail.com>
> >---
> > drivers/net/bonding/bond_main.c |   14 +++++++++++---
> > 1 files changed, 11 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 435984a..037fdd3 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -766,18 +766,26 @@ static void __bond_resend_igmp_join_requests(struct net_device *dev)
> >  */
> > static void bond_resend_igmp_join_requests(struct bonding *bond)
> > {
> >-	struct net_device *vlan_dev;
> >+	struct net_device *bond_dev, *vlan_dev, *master_dev;
> > 	struct vlan_entry *vlan;
> >
> > 	read_lock(&bond->lock);
> >
> >+	bond_dev = bond->dev;
> >+
> > 	/* rejoin all groups on bond device */
> >-	__bond_resend_igmp_join_requests(bond->dev);
> >+	__bond_resend_igmp_join_requests(bond_dev);
> >+
> >+	/* rejoin all groups on its master */
> >+	master_dev = bond_dev->master;
> >+	if (unlikely(master_dev)) {
> >+		__bond_resend_igmp_join_requests(master_dev);
> >+	}
> 
> 	Will this do the right thing if the master is not a bridge?
> Granted, right now the only other possible master is a team (since
> bonding will not enslave itself), but is this generically safe and
> desirable for any possible master_dev?
> 

I agree with Jay.  You should also check the private flags to see if
IFF_BRIDGE_PORT is set.
