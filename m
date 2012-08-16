Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2HPS5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:57:22 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2585 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2HPS5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:57:20 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Subject: Re: [PATCH] bnx2: turn off the network statck during
 initialization
From: "Michael Chan" <mchan@broadcom.com>
To: "Jiang Wang" <Jiang.Wang@riverbed.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, clala@riverbed.com,
        Francis.St.Amant@riverbed.com, "Jiang Wang" <jwang@riverbed.com>
In-Reply-To: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
References: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
Date: Thu, 16 Aug 2012 11:57:11 -0700
Message-ID: <1345143431.6916.36.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7C339DB63NK16224006-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 11:21 -0700, Jiang Wang wrote: 
> The initialization state of bnx2 driver is wrong. It does not turn
> of the Linux network stack using netif_carrier_off. This may lead to
> inconsistent report from ethtool as the link is up but speed is
> unknown when the cable is not plugged in.
> 
> E.g.
>         Speed: Unknown! (0)<--------------------------------------
>         Duplex: Half       <--------------------------------------
>         MDI: Unknown! (0)
>         Port: Twisted Pair
>         PHYAD: 1
>         Transceiver: internal
>         Auto-negotiation: on
>         Supports Wake-on: g
>         Wake-on: d
>         Link detected: yes <---------------------------------------
> 
> This patches fixed the problem by turning off the network stack
> during initialization.
> 
> Signed-off-by: Jiang Wang <jwang@riverbed.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index ac7b744..ce4548d 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -8463,6 +8463,10 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev->features |= dev->hw_features;
>  	dev->priv_flags |= IFF_UNICAST_FLT;
>  
> +	/* tell the stack to leave us alone until bnx2_open() is called */
> +	netif_carrier_off(dev);

We have tried this before and this didn't work.  netif_carrier_off()
calls linkwatch_fire_event() to schedule the event.  If
register_netdev() fails for whatever reason, the netdev will be freed
but the link_watch event may still be scheduled.

Calling netif_carrier_off() after register_netdev() returns successfully
also may not work as it will race with bnx2_open() which enables IRQ.
An linkup IRQ can happen at time and we may end up with the wrong
carrier state because of the race condition.

> +	netif_stop_queue(dev);
> +
>  	if ((rc = register_netdev(dev))) {
>  		dev_err(&pdev->dev, "Cannot register net device\n");
>  		goto error;



