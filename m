Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1CJRF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:05:29 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:36975 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1CJRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:05:27 -0500
X-Auth-Info: BCLNQxD+9YxEYwvpIyM/GlpRZszoSai6P6mNBcZ8HhQ=
Message-ID: <4D790554.20204@grandegger.com>
Date: Thu, 10 Mar 2011 18:07:32 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Abhilash K V <abhilash.kv@ti.com>
CC: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH] can : TI_HECC : Unintialized variables
References: <1299774087-8532-1-git-send-email-abhilash.kv@ti.com>
In-Reply-To: <1299774087-8532-1-git-send-email-abhilash.kv@ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 05:21 PM, Abhilash K V wrote:
> 1. In ti_hecc_xmit(), "data" is not initialized, causing
>    undesirable effects like setting the RTR field for every
>    transmit.

Does it need to be initialized to "data = cf->can_dlc"? If yes, please
correct the message, if not ...

> 2. In ti_hecc_probe(), the spinlock  priv->mbx_lock is not
>    inited, causing a spinlock lockup BUG.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Acked-by: Anant Gole <anantgole@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  drivers/net/can/ti_hecc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
> index 4d07f1e..73c6025 100644
> --- a/drivers/net/can/ti_hecc.c
> +++ b/drivers/net/can/ti_hecc.c
> @@ -503,6 +503,7 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
>  	spin_unlock_irqrestore(&priv->mbx_lock, flags);
>  
>  	/* Prepare mailbox for transmission */
> +	data = cf->can_dlc;
>  	if (cf->can_id & CAN_RTR_FLAG) /* Remote transmission request */
>  		data |= HECC_CANMCF_RTR;
>  	data |= get_tx_head_prio(priv) << 8;

... using the following expressions looks more reasonable:

  	data = get_tx_head_prio(priv) << 8;
 	if (cf->can_id & CAN_RTR_FLAG) /* Remote transmission request */
 		data |= HECC_CANMCF_RTR;
	
Wolfgang.
