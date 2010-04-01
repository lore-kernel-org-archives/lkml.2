Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0DAGMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:12:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56815 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0DAGM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:12:28 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [Patch V2] bonding: fix potential deadlock in bond_uninit()
References: <20100401061014.4815.7341.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 31 Mar 2010 23:12:22 -0700
In-Reply-To: <20100401061014.4815.7341.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Thu\, 1 Apr 2010 02\:06\:28 -0400")
Message-ID: <m1r5mzsnuh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com, jpirko@redhat.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> bond_uninit() is invoked with rtnl_lock held, when it does destroy_workqueue()
> which will potentially flush all works in this workqueue, if we hold rtnl_lock
> again in the work function, it will deadlock.
>
> So move destroy_workqueue() to destructor where rtnl_lock is not held any more,
> suggested by Eric.

The error handling on creating a bond device needs to be updated as well.

Eric


> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Jay Vosburgh <fubar@us.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Jiri Pirko <jpirko@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>
> ---
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 5b92fbf..9f0aaa2 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4450,6 +4450,14 @@ static const struct net_device_ops bond_netdev_ops = {
>  	.ndo_vlan_rx_kill_vid	= bond_vlan_rx_kill_vid,
>  };
>  
> +static void bond_destructor(struct net_device *bond_dev)
> +{
> +	struct bonding *bond = netdev_priv(bond_dev);
> +	if (bond->wq)
> +		destroy_workqueue(bond->wq);
> +	free_netdev(bond_dev);
> +}
> +
>  static void bond_setup(struct net_device *bond_dev)
>  {
>  	struct bonding *bond = netdev_priv(bond_dev);
> @@ -4470,7 +4478,7 @@ static void bond_setup(struct net_device *bond_dev)
>  	bond_dev->ethtool_ops = &bond_ethtool_ops;
>  	bond_set_mode_ops(bond, bond->params.mode);
>  
> -	bond_dev->destructor = free_netdev;
> +	bond_dev->destructor = bond_destructor;
>  
>  	/* Initialize the device options */
>  	bond_dev->tx_queue_len = 0;
> @@ -4542,9 +4550,6 @@ static void bond_uninit(struct net_device *bond_dev)
>  
>  	bond_remove_proc_entry(bond);
>  
> -	if (bond->wq)
> -		destroy_workqueue(bond->wq);
> -
>  	netif_addr_lock_bh(bond_dev);
>  	bond_mc_list_destroy(bond);
>  	netif_addr_unlock_bh(bond_dev);
