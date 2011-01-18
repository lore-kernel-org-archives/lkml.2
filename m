Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1ARQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:05:21 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:3109 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1ARQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:05:19 -0500
Subject: Re: [PATCH net-next 5/8] vmxnet3: Make ethtool handlers multiqueue
 aware
From: Ben Hutchings <bhutchings@solarflare.com>
To: Shreyas N Bhatewara <sbhatewara@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
In-Reply-To: <20110115005946.1064.97955.stgit@sbhatewara-dev1.eng.vmware.com>
References: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
	 <20110115005946.1064.97955.stgit@sbhatewara-dev1.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 18 Jan 2011 16:05:14 +0000
Message-ID: <1295366715.3537.9.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2011 16:05:18.0696 (UTC) FILETIME=[80762680:01CBB729]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17900.005
X-TM-AS-Result: No--15.249000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 16:59 -0800, Shreyas N Bhatewara wrote:
> Show per-queue stats in ethtool -S output for vmxnet3 interface. Register dump
> of ethtool should dump registers for all tx and rx queues.
> 
> Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |  259 ++++++++++++++++++---------------
>  1 files changed, 145 insertions(+), 114 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> index 8e17fc8..d70cee1 100644
> --- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
> +++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> @@ -68,76 +68,78 @@ vmxnet3_set_rx_csum(struct net_device *netdev, u32 val)
>  static const struct vmxnet3_stat_desc
>  vmxnet3_tq_dev_stats[] = {
>  	/* description,         offset */
> -	{ "TSO pkts tx",        offsetof(struct UPT1_TxStats, TSOPktsTxOK) },
> -	{ "TSO bytes tx",       offsetof(struct UPT1_TxStats, TSOBytesTxOK) },
> -	{ "ucast pkts tx",      offsetof(struct UPT1_TxStats, ucastPktsTxOK) },
> -	{ "ucast bytes tx",     offsetof(struct UPT1_TxStats, ucastBytesTxOK) },
> -	{ "mcast pkts tx",      offsetof(struct UPT1_TxStats, mcastPktsTxOK) },
> -	{ "mcast bytes tx",     offsetof(struct UPT1_TxStats, mcastBytesTxOK) },
> -	{ "bcast pkts tx",      offsetof(struct UPT1_TxStats, bcastPktsTxOK) },
> -	{ "bcast bytes tx",     offsetof(struct UPT1_TxStats, bcastBytesTxOK) },
> -	{ "pkts tx err",        offsetof(struct UPT1_TxStats, pktsTxError) },
> -	{ "pkts tx discard",    offsetof(struct UPT1_TxStats, pktsTxDiscard) },
> +	{ "Tx Queue#",        0 },
> +	{ "  TSO pkts tx",	offsetof(struct UPT1_TxStats, TSOPktsTxOK) },
> +	{ "  TSO bytes tx",	offsetof(struct UPT1_TxStats, TSOBytesTxOK) },
[...]

I really don't like this.  You're making the assumption that these stats
will always be displayed as they are now by the ethtool command, but
that is not the only user of the ethtool API.

I expect that some people have scripts that involve reading ethtool
stats into a hash/dictionary.  (In fact, I wrote a diagnostic script for
Solarflare that does that.)  After this change to your driver, they
would get results from only one TX queue (with different names from
before).

So please:
- Don't use leading or trailing spaces in names
- Keep the global statistics, as most users will be more interested in
these
- If you think users actually want per-queue statistics, add them with
unique names (like bnx2x does)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

