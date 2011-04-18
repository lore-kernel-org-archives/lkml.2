Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DRUxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:53:14 -0400
Received: from mail.solarflare.com ([216.237.3.220]:19227 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1DRUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:53:12 -0400
Subject: Re: [PATCH V14 3/4] ptp: Added a clock driver for the IXP46x.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <dbee2487a57fd7f41e4efbbd2ddfb1313b8d71bc.1303107532.git.richard.cochran@omicron.at>
References: <cover.1303107532.git.richard.cochran@omicron.at>
	 <dbee2487a57fd7f41e4efbbd2ddfb1313b8d71bc.1303107532.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 18 Apr 2011 21:53:06 +0100
Message-ID: <1303159986.2857.56.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2011 20:53:11.0455 (UTC) FILETIME=[A10182F0:01CBFE0A]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18080.005
X-TM-AS-Result: No--12.618400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 08:29 +0200, Richard Cochran wrote:
> This patch adds a driver for the hardware time stamping unit found on the
> IXP465. The basic clock operations and an external trigger are implemented.
[...]
> --- a/drivers/net/arm/ixp4xx_eth.c
> +++ b/drivers/net/arm/ixp4xx_eth.c
[...]
> @@ -246,6 +255,169 @@ static int ports_open;
>  static struct port *npe_port_tab[MAX_NPES];
>  static struct dma_pool *dma_pool;
>  
> +static struct sock_filter ptp_filter[] = {
> +	PTP_FILTER
> +};
> +
> +static int ixp_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seq)
> +{
> +	unsigned int type;
> +	u16 *hi, *id;
> +	u8 *lo, *data = skb->data;
> +
> +	type = sk_run_filter(skb, ptp_filter);
> +
> +	if (PTP_CLASS_V1_IPV4 == type) {
> +
> +		id = (u16 *)(data + 42 + 30);
> +		hi = (u16 *)(data + 42 + 22);
> +		lo = data + 42 + 24;
[...]

PTP_FILTER does not verify that the packet length is sufficient to hold
a complete PTP header, nor does it require that the IPv4 header length
is 5 (i.e. 20 bytes).  So you have to check those here rather than using
magic numbers.

I think you also need to use be16_to_cpup() to read 'id' and 'hi', since
the host byte order may vary.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

