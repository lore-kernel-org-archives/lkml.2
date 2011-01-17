Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1AQSVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:21:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1AQSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aDIAKByZB2wmXE+6ZH0hnAPJMEyz8HTX6VIAZ0GyR0+yTpHiwiMfWm5oe8/uLp7Dvt
         7n24U9lH0H1zJzdekkd8j+XoUDJcEceQp3rWgYPQ1ya+eWfOrzgtgfyqdSQLGMNJcIBO
         wiIHZl3al+o6YS9Se4gmrJgDlBoJoTGcuORHQ=
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com, bhutchings@solarflare.com, joe@perches.com,
        dilinger@queued.net
In-Reply-To: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 19:21:02 +0100
Message-ID: <1295288462.3335.55.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 17 janvier 2011 à 17:21 +0800, Po-Yu Chuang a écrit :


> +
> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +	ftmac100_txdes_set_skb(txdes, skb);
> +	ftmac100_txdes_set_dma_addr(txdes, map);
> +
> +	ftmac100_txdes_set_first_segment(txdes);
> +	ftmac100_txdes_set_last_segment(txdes);
> +	ftmac100_txdes_set_txint(txdes);
> +	ftmac100_txdes_set_buffer_size(txdes, len);
> +

I wonder if its not too expensive to read/modify/write txdes->txdes1

Maybe you should use a temporary u32 var and perform one final write on
txdes->txdes1 (with the set_dma_own)

> +	priv->tx_pending++;
> +	if (priv->tx_pending == TX_QUEUE_ENTRIES) {
> +		if (net_ratelimit())
> +			netdev_info(netdev, "tx queue full\n");
> +
> +		netif_stop_queue(netdev);
> +	}
> +
> +	/* start transmit */
> +	ftmac100_txdes_set_dma_own(txdes);

	txdes->txdes1 = txdes1;

BTW, shouldnt you use cpu_to_be32() or cpu_to_le32(), if this driver is
multi platform ?



