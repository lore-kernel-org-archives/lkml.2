Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1ATTAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:00:13 -0500
Received: from mail.perches.com ([173.55.12.10]:3223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1ATTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:00:11 -0500
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Joe Perches <joe@perches.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 11:00:09 -0800
Message-ID: <1295550009.28001.59.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 23:30 +0800, Po-Yu Chuang wrote:
>  drivers/net/ftmac100.c | 1243 ++++++++++++++++++++++++++++++++++++++++++++++++

[]

> +/******************************************************************************
> + * struct napi_struct functions
> + *****************************************************************************/
> +static int ftmac100_poll(struct napi_struct *napi, int budget)
> +{
> +	struct ftmac100 *priv = container_of(napi, struct ftmac100, napi);
> +	struct net_device *netdev = priv->netdev;
> +	unsigned int status;
> +	bool completed = true;
> +	int rx = 0;
> +
> +	status = ioread32(priv->base + FTMAC100_OFFSET_ISR);
> +
> +	if (status & (FTMAC100_INT_RPKT_FINISH | FTMAC100_INT_NORXBUF)) {
> +		/*
> +		 * FTMAC100_INT_RPKT_FINISH:
> +		 *	RX DMA has received packets into RX buffer successfully
> +		 *
> +		 * FTMAC100_INT_NORXBUF:
> +		 *	RX buffer unavailable
> +		 */
> +		bool retry;
> +
> +		do {
> +			retry = ftmac100_rx_packet(priv, &rx);
> +		} while (retry && rx < budget);
> +
> +		if (retry && rx == budget)
> +			completed = false;

Is it useful to retry the NORXBUF case?

> +	}
> +
> +	if (status & FTMAC100_INT_NORXBUF) {
> +		/* RX buffer unavailable */
> +		if (net_ratelimit())
> +			netdev_info(netdev, "INT_NORXBUF\n");
> +
> +		netdev->stats.rx_over_errors++;
> +	}

Perhaps this "if (status & FTMAC100_INT_NORXBUF)" block should be
moved into the test block above it before the retry?

> +
> +	if (status & (FTMAC100_INT_XPKT_OK | FTMAC100_INT_XPKT_LOST)) {
> +		/*
> +		 * FTMAC100_INT_XPKT_OK:
> +		 *	 packet transmitted to ethernet successfully
> +		 *
> +		 * FTMAC100_INT_XPKT_LOST:
> +		 *	packet transmitted to ethernet lost due to late
> +		 *	collision or excessive collision
> +		 */
> +		ftmac100_tx_complete(priv);
> +	}
> +
> +	if (status & FTMAC100_INT_RPKT_LOST) {
> +		/* received packet lost due to RX FIFO full */
> +		if (net_ratelimit())
> +			netdev_info(netdev, "INT_RPKT_LOST\n");
> +
> +		netdev->stats.rx_fifo_errors++;
> +	}
> +
> +	if (status & FTMAC100_INT_AHB_ERR) {
> +		/* AHB error */
> +		if (net_ratelimit())
> +			netdev_info(netdev, "INT_AHB_ERR\n");
> +
> +		/* do nothing */
> +	}
> +
> +	if (status & FTMAC100_INT_PHYSTS_CHG) {
> +		/* PHY link status change */
> +		if (net_ratelimit())
> +			netdev_info(netdev, "INT_PHYSTS_CHG\n");
> +
> +		mii_check_link(&priv->mii);
> +	}
> +
> +	if (completed) {
> +		/* stop polling */
> +		napi_complete(napi);
> +		ftmac100_enable_all_int(priv);
> +	}
> +
> +	return rx;
> +}

It's possible to miss multiple states because of the ratelimit.

If multiple ISR status bits are possible, it might be better to
combine all netdev_info uses into a single call.

Something like:

	if ((status & (FTMAC100_INT_NORXBUF | FTMAC100_INT_RPKT_LOST |
		       FTMAC100_INT_AHB_ERR | FTMAC100_INT_PHYSTS_CHG)) &&
	    net_ratelimit())
		netdev_info(netdev, "ISR status: %x%s%s%s%s\n",
			    status & FTMAC100_INT_NORXBUF ? ": INT_NORXBUF" : "",
			    status & FTMAC100_INT_RPKT_LOST ? ": INT_RPKT_LOST" : "",
			    status & FTMAC100_INT_AHB_ERR ? ": INT_AHB_ERR" : "",
			    status & FTMAC100_INT_PHYSTS_CHG ? " : INT_PHYSTS_CHG" : "");


