Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0LHIQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:16:48 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:44361 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0LHIQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=I3BbCgIrXbkDrCIdw5d2jfkkorQsT1psT3KGO0WHsR1prn6XRqSjDpnZ4b7pPoeX0T
         se5KlX4mN7x7iVUn4EMKuBBBYysCIlNCLDcv8sYH3EZAV1lbl+fZEVFMn0AoP8Ne5PQ3
         lWxVs6zh98+F4m2i4YlRrZ8EsS3s+tMxVKrwA=
MIME-Version: 1.0
In-Reply-To: <20101208075218.5792.64791.sendpatchset@localhost.localdomain>
References: <20101208075208.5792.45247.sendpatchset@localhost.localdomain> <20101208075218.5792.64791.sendpatchset@localhost.localdomain>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 8 Dec 2010 16:16:22 +0800
Message-ID: <AANLkTindQMNKhC2aowUyjm=uO8gFKqOOPa9HXSU1q7Gh@mail.gmail.com>
Subject: Re: [v3 PATCH 2/2] netpoll: remove IFF_IN_NETPOLL flag
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 3:52 PM, Amerigo Wang <amwang@redhat.com> wrote:
> From: Amerigo Wang <amwang@redhat.com>
> Date: Thu, 2 Dec 2010 21:34:44 +0800
> Subject: [v3 PATCH 2/2] netpoll: remove IFF_IN_NETPOLL flag
>
> This patch removes the flag IFF_IN_NETPOLL, we don't need it any more since
> we have netpoll_tx_running() now.
>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Neil Horman <nhorman@redhat.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jay Vosburgh <fubar@us.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Jiri Pirko <jpirko@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>
> ---
>
>  drivers/net/bonding/bond_main.c |    6 ++----
>  drivers/net/bonding/bonding.h   |    2 +-
>  include/linux/if.h              |    9 ++++-----
>  net/core/netpoll.c              |    2 --
>  4 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 7fafe06..21ac08b 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -448,11 +448,9 @@ int bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
>        }
>
>        skb->priority = 1;
> -       if (unlikely(netpoll_tx_running(slave_dev))) {
> -               slave_dev->priv_flags |= IFF_IN_NETPOLL;
> +       if (unlikely(netpoll_tx_running(slave_dev)))
>                bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
> -               slave_dev->priv_flags &= ~IFF_IN_NETPOLL;
> -       } else
> +       else
>                dev_queue_xmit(skb);
>
>        return 0;
> diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
> index c4f6a94..493e645 100644
> --- a/drivers/net/bonding/bonding.h
> +++ b/drivers/net/bonding/bonding.h
> @@ -138,7 +138,7 @@ static inline void unblock_netpoll_tx(void)
>
>  static inline int is_netpoll_tx_blocked(struct net_device *dev)
>  {
> -       if (unlikely(dev->priv_flags & IFF_IN_NETPOLL))
> +       if (unlikely(netpoll_tx_running(dev)))
>                return cpumask_test_cpu(smp_processor_id(), netpoll_block_tx);
>        return 0;
>  }
> diff --git a/include/linux/if.h b/include/linux/if.h
> index 1239599..3bc63e6 100644
> --- a/include/linux/if.h
> +++ b/include/linux/if.h
> @@ -71,11 +71,10 @@
>                                         * release skb->dst
>                                         */
>  #define IFF_DONT_BRIDGE 0x800          /* disallow bridging this ether dev */
> -#define IFF_IN_NETPOLL 0x1000          /* whether we are processing netpoll */
> -#define IFF_DISABLE_NETPOLL    0x2000  /* disable netpoll at run-time */
> -#define IFF_MACVLAN_PORT       0x4000  /* device used as macvlan port */
> -#define IFF_BRIDGE_PORT        0x8000          /* device used as bridge port */
> -#define IFF_OVS_DATAPATH       0x10000 /* device used as Open vSwitch
> +#define IFF_DISABLE_NETPOLL    0x1000  /* disable netpoll at run-time */
> +#define IFF_MACVLAN_PORT       0x2000  /* device used as macvlan port */
> +#define IFF_BRIDGE_PORT        0x4000          /* device used as bridge port */
> +#define IFF_OVS_DATAPATH       0x8000  /* device used as Open vSwitch
>                                         * datapath port */
>

You can't change the values of these macros or delete some of them,
because they are exported to user space and are parts of ABI.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
