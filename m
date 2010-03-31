Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0CaL2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 07:28:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60276 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab0CaL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 07:28:39 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [Patch] bonding: fix potential deadlock in bond_uninit()
References: <20100331105559.5607.38643.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 31 Mar 2010 04:28:33 -0700
In-Reply-To: <20100331105559.5607.38643.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Wed\, 31 Mar 2010 06\:52\:13 -0400")
Message-ID: <m1d3ykzq5a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com, jpirko@redhat.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> bond_uninit() is invoked with rtnl_lock held, when it does destroy_workqueue()
> which will potentially flush all works in this workqueue, if we hold rtnl_lock
> again in the work function, it will deadlock.
>
> So unlock rtnl_lock before calling destroy_workqueue().

Ouch.  That seems rather rude to our caller, and likely very
dangerous.

Is this a deadlock you actually hit, or is this something lockdep
warned about?

My gut feel says we need to move the destroy_workqueue into
the network device destructor.

Eric



> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Jay Vosburgh <fubar@us.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Jiri Pirko <jpirko@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>
> ---
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 5b92fbf..b781728 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4542,8 +4542,11 @@ static void bond_uninit(struct net_device *bond_dev)
>  
>  	bond_remove_proc_entry(bond);
>  
> -	if (bond->wq)
> +	if (bond->wq) {
> +		rtnl_unlock();
>  		destroy_workqueue(bond->wq);
> +		rtnl_lock();
> +	}
>  
>  	netif_addr_lock_bh(bond_dev);
>  	bond_mc_list_destroy(bond);
