Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1KVAAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:00:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1KVAAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:00:30 -0500
MIME-Version: 1.0
In-Reply-To: <22b29c09790d922f6e84ec623b8a691a7c3cd0a3.1321917278.git.david.decotigny@google.com>
References: <cover.1321917278.git.david.decotigny@google.com> <22b29c09790d922f6e84ec623b8a691a7c3cd0a3.1321917278.git.david.decotigny@google.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Tue, 22 Nov 2011 01:00:09 +0100
Message-ID: <CAHXqBFKGym1+AkXmEGeTzXeF_hvzfXoMEKrHBNSK5htHKf9PoQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/4] net-e1000e: fix ethtool set_features
 taking new features into account too late
To: David Decotigny <david.decotigny@google.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/22 David Decotigny <david.decotigny@google.com>:
[...]
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index a5bd7a3..b63f316 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5901,24 +5901,28 @@ static void e1000_eeprom_checks(struct e1000_adapter *adapter)
>  }
>
>  static int e1000_set_features(struct net_device *netdev,
> -       netdev_features_t features)
> +                             netdev_features_t features)
>  {
>        struct e1000_adapter *adapter = netdev_priv(netdev);
>        netdev_features_t changed = features ^ netdev->features;
> +       int retval = 1;  /* telling netdev that we are updating
> +                         * netdev->features by ourselves */
> +
> +       netdev->features = features;
>
>        if (changed & (NETIF_F_TSO | NETIF_F_TSO6))
>                adapter->flags |= FLAG_TSO_FORCE;
>
>        if (!(changed & (NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_TX |
>                         NETIF_F_RXCSUM)))
> -               return 0;
> +               return retval;
>

Would be less code if you set netdev->features here...

>        if (netif_running(netdev))
>                e1000e_reinit_locked(adapter);
>        else
>                e1000e_reset(adapter);
>
> -       return 0;
> +       return retval;

... and return 1 here, noting in a comment that e1000e_reinit_locked()
might have changed netdev->features.

>  }

Best Regards,
Michał Mirosław
