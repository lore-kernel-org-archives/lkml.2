Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2CEGEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:04:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34325 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636Ab2CEGEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:04:37 -0500
Message-ID: <1330927473.3140.1.camel@joe2Laptop>
Subject: Re: [PATCH] net/pch_gbe: supports eg20t ptp clock
From: Joe Perches <joe@perches.com>
To: Takahiro Shimizu <tshimizu818@gmail.com>
Cc: jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        lucas.demarchi@profusion.mobi, mirq-linux@rere.qmqm.pl,
        paul.gortmaker@windriver.com, toshiharu-linux@dsn.okisemi.com,
        jdmason@kudzu.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Date: Sun, 04 Mar 2012 22:04:33 -0800
In-Reply-To: <1330926377-11531-1-git-send-email-tshimizu818@gmail.com>
References: <1330926377-11531-1-git-send-email-tshimizu818@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 14:46 +0900, Takahiro Shimizu wrote:
> From: Takahiroi Shimizu <tshimizu818@gmail.com>
> Supports EG20T ptp clock in the driver

just some trivial comments...

> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> +/* 0x40 Time Synchronization Channel Control Register Bits */
> +#define MASTER_MODE   (1<<0)
> +#define SLAVE_MODE    (0<<0)

> +#define V2_MODE       (1<<31)
> +#define CAP_MODE0     (0<<16)

0 << anything is pretty ugly.

[]

> +static void pch_rx_timestamp(
> +			struct pch_gbe_adapter *adapter, struct sk_buff *skb)

Also not too pretty.

Maybe

static void
pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)

[]

> +static void pch_tx_timestamp(
> +			struct pch_gbe_adapter *adapter, struct sk_buff *skb)

here too.

[]

> +	shtx = skb_shinfo(skb);
> +	if (unlikely(shtx->tx_flags & SKBTX_HW_TSTAMP && adapter->hwts_tx_en))
> +		shtx->tx_flags |= SKBTX_IN_PROGRESS;
> +	else
> +		return;

probably better as

	if (likely(!(shtx->tx_flags & SKBTX_HW_TSTAMP &&
		     adapter->hwts_tx_en)))
		return;

	shtx->tx_flags |= etc...

> +
> +	/* Get ieee1588's dev information */
> +	pdev = adapter->ptp_pdev;
> +
> +	/*
> +	 * This really stinks, but we have to poll for the Tx time stamp.
> +	 * Usually, the time stamp is ready after 4 to 6 microseconds.
> +	 */
> +	for (cnt = 0; cnt < 100; cnt++) {
> +		val = pch_ch_event_read(pdev);
> +		if (val & TX_SNAPSHOT_LOCKED)
> +			break;
> +		udelay(1);
> +	}

why not just continually poll until timeout instead of udelay?

[]

> +static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)

[]

> +	switch (cfg.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		adapter->hwts_rx_en = 0;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +		adapter->hwts_rx_en = 0;
> +		pch_ch_control_write(pdev, (SLAVE_MODE | CAP_MODE0));

parentheses are not necessary around SLAVE_MODE | CAP_MODE0

> +		break;
> +	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +		adapter->hwts_rx_en = 1;
> +		pch_ch_control_write(pdev, (MASTER_MODE | CAP_MODE0));

here too.


