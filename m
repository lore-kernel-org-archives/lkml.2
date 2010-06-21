Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0FUWy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:54:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab0FUWy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:54:56 -0400
Date: Mon, 21 Jun 2010 15:53:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 1/3] arch/um/drivers: remove duplicate structure field
 initialization
Message-Id: <20100621155349.8f314499.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.1006201539080.6207@ask.diku.dk>
References: <Pine.LNX.4.64.1006201539080.6207@ask.diku.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 15:40:02 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> There are two initializations of ndo_set_mac_address, one to a local
> function that is not used otherwise and one to a function that is defined
> elsewhere.  This patch keeps the initialization to the local function.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier I, s, fld;
> position p0,p;
> expression E;
> @@
> 
> struct I s =@p0 { ... .fld@p = E, ...};
> 
> @s@
> identifier I, s, r.fld;
> position r.p0,p;
> expression E;
> @@
> 
> struct I s =@p0 { ... .fld@p = E, ...};
> 
> @script:python@
> p0 << r.p0;
> fld << r.fld;
> ps << s.p;
> pr << r.p;
> @@
> 
> if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
>   cocci.print_main(fld,p0)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This fix was sent previously, in September 2009.
> 
>  arch/um/drivers/net_kern.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
> index f053726..d2d42d8 100644
> --- a/arch/um/drivers/net_kern.c
> +++ b/arch/um/drivers/net_kern.c
> @@ -380,7 +380,6 @@ static const struct net_device_ops uml_netdev_ops = {
>  	.ndo_tx_timeout 	= uml_net_tx_timeout,
>  	.ndo_set_mac_address	= uml_net_set_mac,
>  	.ndo_change_mtu 	= uml_net_change_mtu,
> -	.ndo_set_mac_address 	= eth_mac_addr,
>  	.ndo_validate_addr	= eth_validate_addr,
>  };

Your patch is actually a functional change.

Geeze, whatamess.


This duplicated field was added by

: commit 8bb95b39a16ed55226810596f92216c53329d2fe
: Author:     Stephen Hemminger <shemminger@linux-foundation.org>
: AuthorDate: Thu Mar 26 15:11:17 2009 +0000
: Commit:     David S. Miller <davem@davemloft.net>
: CommitDate: Fri Mar 27 00:46:40 2009 -0700
:
:    uml: convert network device to netdevice ops

Either Stephen fat-fingered it, or it was a secret, unchangelogged (and
partial) cleanup.

Presumably the spin_lock_irq(&lp->lock); stuff is in uml_net_set_mac()
for a reason so presumably we should restore it.


- Use the standard eth_mac_addr() in uml_net_set_mac()

- Remove unneeded and racy local set_ether_mac()

- Remove duplicated (and incorrect)
  uml_netdev_ops.ndo_set_mac_address initializer.

Fixes 8bb95b39a16ed55226810596f92216c53329d2fe ("uml: convert network
device to netdevice ops").

diff -puN arch/um/drivers/net_kern.c~arch-um-drivers-remove-duplicate-structure-field-initialization arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~arch-um-drivers-remove-duplicate-structure-field-initialization
+++ a/arch/um/drivers/net_kern.c
@@ -25,11 +25,6 @@
 #include "net_kern.h"
 #include "net_user.h"
 
-static inline void set_ether_mac(struct net_device *dev, unsigned char *addr)
-{
-	memcpy(dev->dev_addr, addr, ETH_ALEN);
-}
-
 #define DRIVER_NAME "uml-netdev"
 
 static DEFINE_SPINLOCK(opened_lock);
@@ -266,7 +261,7 @@ static int uml_net_set_mac(struct net_de
 	struct sockaddr *hwaddr = addr;
 
 	spin_lock_irq(&lp->lock);
-	set_ether_mac(dev, hwaddr->sa_data);
+	eth_mac_addr(dev, hwaddr->sa_data);
 	spin_unlock_irq(&lp->lock);
 
 	return 0;
@@ -380,7 +375,6 @@ static const struct net_device_ops uml_n
 	.ndo_tx_timeout 	= uml_net_tx_timeout,
 	.ndo_set_mac_address	= uml_net_set_mac,
 	.ndo_change_mtu 	= uml_net_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -478,7 +472,7 @@ static void eth_configure(int n, void *i
 	    ((*transport->user->init)(&lp->user, dev) != 0))
 		goto out_unregister;
 
-	set_ether_mac(dev, device->mac);
+	eth_mac_addr(dev, device->mac);
 	dev->mtu = transport->user->mtu;
 	dev->netdev_ops = &uml_netdev_ops;
 	dev->ethtool_ops = &uml_net_ethtool_ops;
_

