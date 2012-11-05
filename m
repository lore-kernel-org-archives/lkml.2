Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2KEWpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:45:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52761 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2KEWpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:45:50 -0500
From: Jay Vosburgh <fubar@us.ibm.com>
To: Chris J Arges <chris.j.arges@canonical.com>
cc: Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next] bonding: extend bond_arp_send_all to bridge devices
In-reply-to: <1352154649-21089-1-git-send-email-chris.j.arges@canonical.com>
References: <1352154649-21089-1-git-send-email-chris.j.arges@canonical.com>
Comments: In-reply-to Chris J Arges <chris.j.arges@canonical.com>
   message dated "Mon, 05 Nov 2012 16:30:49 -0600."
X-Mailer: MH-E 8.2; nmh 1.4; GNU Emacs 23.4.1
Date: Mon, 05 Nov 2012 14:45:45 -0800
Message-ID: <26061.1352155545@death.nxdomain>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110522-8974-0000-0000-000010AE61E0
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00188779; UDB=6.00042750; UTC=2012-11-05
 22:45:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris J Arges <chris.j.arges@canonical.com> wrote:

>ARP monitoring does not work when we have a network in the
>following configuration:
>
>eth0----+ +----bond0.100----br0-100---{+virtual machines
>          | |
>          +----bond0----+----br0---(fixed IP)->--{LAN arp_ip_target}
>          | |
>eth1----+ +----bond0.200----br0-200---{+virtual machines
>
>This patch extends bond_arp_send_all to check if a device
>is also in a bridge.
>
>This is related to the following issues:
>http://launchpad.net/bugs/736226
>http://bugzilla.kernel.org/show_bug.cgi?id=31822
>
>Thanks to help from Andy Gospodarek <andy@greyhouse.net>.
>
>Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>

	What has changed that you're up to version 3 now?

> drivers/net/bonding/bond_main.c |   12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index b2530b0..cb791f6 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2708,6 +2708,18 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
> 			continue;
> 		}
>
>+		/*
>+		 * Check if the target is part of a bridge.
>+		 */

		/* Comment should be formatted like this.
		 */

>+		if (rt->dst.dev->priv_flags & IFF_EBRIDGE) {
>+			/* Confirm addr is part of the bridge */
>+			addr = bond_confirm_addr(rt->dst.dev, targets[i], 0);
>+
>+			/* Send ARP request */

	I think this comment is unnecessary.

	-J

>+			bond_arp_send(slave->dev, ARPOP_REQUEST, targets[i], addr, 0);
>+			continue;
>+		}
>+
> 		if (net_ratelimit()) {
> 			pr_warning("%s: no path to arp_ip_target %pI4 via rt.dev %s\n",
> 				   bond->dev->name, &targets[i],
>-- 
>1.7.9.5
>

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

