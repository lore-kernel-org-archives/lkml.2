Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030939Ab2CNRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab2CNRVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:21:49 -0400
Date: Wed, 14 Mar 2012 13:22:37 -0400
From: Andy Gospodarek <gospo@redhat.com>
To: Weiping Pan <panweiping3@gmail.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        "open list:BONDING DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net V2] bonding: send igmp report for its master
Message-ID: <20120314172237.GA12372@quad.redhat.com>
References: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
 <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:37:22AM +0800, Weiping Pan wrote:
> Liang Zheng(lzheng@redhat.com) found that in the following topo,
> bonding does not send igmp report when we trigger a fail-over of bonding.
> 
> eth0--
>       |-- bond0 -- br0
> eth1--
> 
> modprobe bonding mode=1 miimon=100 resend_igmp=10
> ifconfig bond0 up
> ifenslave bond0 eth0 eth1
> 
> brctl addbr br0
> ifconfig br0 192.168.100.2/24 up
> brctl addif br0 bond0
> 
> Add 192.168.100.2(br0) into a multicast group, like 224.10.10.10,
> then trigger a fali-over in bonding.
> You can see that parameter "resend_igmp" does not work.
> 
> The reason is that when we add br0 into a multicast group,
> it does not propagate multicast knowledge down to its ports.
> 
> If we choose to propagate multicast knowledge down to all ports for bridge,
> then we have to track every change that is done to bridge, and keep a backup
> for all ports. It is hard to track, I think.
> 
> Instead I choose to modify bonding to send igmp report for its master.
> 
> Changelog:
> V2: correct comments
> 
> Signed-off-by: Weiping Pan <panweiping3@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 435984a..300c490 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -794,6 +794,14 @@ static void bond_resend_igmp_join_requests_delayed(struct work_struct *work)
>  {
>  	struct bonding *bond = container_of(work, struct bonding,
>  					    mcast_work.work);
> +	struct net_device *bond_dev, *master_dev = NULL;
> +	bond_dev = bond->dev;
> +	master_dev = bond_dev->master;
> +
> +	if (unlikely(master_dev)) {
> +		__bond_resend_igmp_join_requests(master_dev);
> +	}
> +
>  	bond_resend_igmp_join_requests(bond);
>  }
>  

This check and call to __bond_resend_igmp_join_requests  would be better
in bond_resend_igmp_join_requests for 2 reasons:

1.  bond_resend_igmp_join_requests already has a check for vlan devices.
It seems logical to check for the bridging case there also.

2.  Calling __bond_resend_igmp_join_requests will not work as expected
when igmp_retrans>1 since no decrementing or rescheduling is done in
__bond_resend_igmp_join_requests.

