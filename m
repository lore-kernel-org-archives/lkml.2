Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0IHUgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:36:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53131
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484Ab0IHUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:36:10 -0400
Date: Wed, 08 Sep 2010 13:36:27 -0700 (PDT)
Message-Id: <20100908.133627.70178420.davem@davemloft.net>
To: masa-korg@dsn.okisemi.com
Cc: randy.dunlap@oracle.com, ralf@linux-mips.org, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, meego-dev@meego.com, mbizon@freebox.fr,
        linux-kernel@vger.kernel.org, kristoffer@gaisler.com,
        john.linn@xilinx.com, joe@perches.com, gregory.v.rose@intel.com,
        yong.y.wang@intel.com, qi.wang@intel.com, okada533@dsn.okisemi.com,
        morinaga526@dsn.okisemi.com, shimizu394@dsn.okisemi.com,
        joel.clark@intel.com, margie.foster@intel.com,
        andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C85A6AD.9080301@dsn.okisemi.com>
References: <4C81019E.1010808@dsn.okisemi.com>
	<4C85A6AD.9080301@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Date: Tue, 07 Sep 2010 11:42:53 +0900

> +/**
> + * pch_gbe_clean_rx - Send received data up the network stack; legacy
> + * @adapter:     Board private structure
> + * @rx_ring:     Rx descriptor ring
> + * @work_done:   Completed count
> + * @work_to_do:  Request count
> + * Returns
> + *	true:  Cleaned the descriptor
> + *	false: Not cleaned the descriptor
> + */
> +static bool
> +pch_gbe_clean_rx(struct pch_gbe_adapter *adapter,
> +		 struct pch_gbe_rx_ring *rx_ring,
> +		 int *work_done, int work_to_do)
> +{
..
> +			if (netif_receive_skb(skb) == NET_RX_DROP) {
> +				adapter->stats.rx_dropped++;

pch_gbe_clean_rx() should be given the "napi_struct" pointer
argument from it's caller, and packets should be given to the
stack using napi_gro_receive().  Finally, NETIF_F_GRO should
be set in netdev->flags at probe time.

Also, you should not use the return value of netif_receive_skb() to
bump the standard rx_dropped statistics value, those return code are
for other purposes.  No other driver does what you are doing with this
return value.

If you wish to increment some extended stastic value (like
drivers/net/gianfar.c does) with another name, that's fine.
