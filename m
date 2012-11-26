Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2KZShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:37:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43427 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab2KZShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:37:07 -0500
From: Jay Vosburgh <fubar@us.ibm.com>
To: Michal Kubecek <mkubecek@suse.cz>
cc: netdev@vger.kernel.org, Andy Gospodarek <andy@greyhouse.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: in balance-rr mode, set curr_active_slave only if it is up
In-reply-to: <20121122125202.14252C35B8@unicorn.suse.cz>
References: <20121122125202.14252C35B8@unicorn.suse.cz>
Comments: In-reply-to Michal Kubecek <mkubecek@suse.cz>
   message dated "Thu, 22 Nov 2012 13:48:39 +0100."
X-Mailer: MH-E 8.2; nmh 1.4; GNU Emacs 23.4.1
Date: Mon, 26 Nov 2012 10:36:46 -0800
Message-ID: <1380.1353955006@death.nxdomain>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112618-9360-0000-0000-00000D2E0777
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Kubecek <mkubecek@suse.cz> wrote:

>If all slaves of a balance-rr bond with ARP monitor are enslaved
>with down link state, bond keeps down state even after slaves
>go up.
>
>This is caused by bond_enslave() setting curr_active_slave to
>first slave not taking into account its link state. As
>bond_loadbalance_arp_mon() uses curr_active_slave to identify
>whether slave's down->up transition should update bond's link
>state, bond stays down even if slaves are up (until first slave
>goes from up to down at least once).

	The bond_loadbalance_arp_mon function actually uses
curr_active_slave to determine whether or not to do a "failover" (select
a new active slave), which in turn will call bond_set_carrier() from
within bond_select_active_slave().

	Other than that nitpick about the description, I see how setting
curr_active_slave to a down slave would cause loadbalance_arp_mon to
skip the "failover" step (because it presumes that an active slave is
always up, and therefore no new one needs to be selected), and thus skip
setting the master's carrier state.

	-J

>Before commit f31c7937 "bonding: start slaves with link down for
>ARP monitor", this was masked by slaves always starting in UP
>state with ARP monitor (and MII monitor not relying on
>curr_active_slave being NULL if there is no slave up).
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>


> drivers/net/bonding/bond_main.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 5f5b69f..c8bff3e 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1838,7 +1838,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
> 		 * anyway (it holds no special properties of the bond device),
> 		 * so we can change it without calling change_active_interface()
> 		 */
>-		if (!bond->curr_active_slave)
>+		if (!bond->curr_active_slave && new_slave->link == BOND_LINK_UP)
> 			bond->curr_active_slave = new_slave;
>
> 		break;
>-- 
>1.7.10.4
>

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

